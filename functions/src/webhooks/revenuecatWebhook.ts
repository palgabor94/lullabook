import { onRequest } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import { logger } from '../utils/logger';

const RC_AUTH = defineSecret('REVENUECAT_WEBHOOK_AUTH_HEADER');

type SubscriptionTier = 'free' | 'weekly' | 'yearly';
type PurchaseSource = 'apple' | 'google';

interface RcEvent {
  type: string;
  app_user_id: string;
  product_id: string;
  period_type: string;
  expiration_at_ms: number;
  store: string;
  cancel_reason?: string;
}

export const revenuecatWebhook = onRequest(
  { secrets: [RC_AUTH], cors: false },
  async (req, res) => {
    if (req.headers.authorization !== `Bearer ${RC_AUTH.value()}`) {
      res.status(401).send('Unauthorized');
      return;
    }

    const event: RcEvent = req.body.event;
    if (!event?.app_user_id) {
      res.status(400).send('Missing event data');
      return;
    }

    const uid = event.app_user_id;
    logger.info('revenuecat_webhook', { type: event.type, uid });

    try {
      switch (event.type) {
        case 'INITIAL_PURCHASE':
        case 'RENEWAL':
        case 'PRODUCT_CHANGE':
          await syncSubscription(uid, {
            tier: deriveTier(event.product_id),
            isInTrial: event.period_type === 'TRIAL',
            expiresAt: Timestamp.fromMillis(event.expiration_at_ms),
            subscriptionId: uid,
            purchaseSource: event.store === 'APP_STORE' ? 'apple' : 'google',
            cancelledAt: null,
          });
          break;

        case 'CANCELLATION':
        case 'EXPIRATION':
          await syncSubscription(uid, {
            tier: 'free',
            isInTrial: false,
            expiresAt: null,
            subscriptionId: null,
            purchaseSource: null,
            cancelledAt: Timestamp.now(),
          });
          break;

        case 'BILLING_ISSUE':
          // Grace period — do not downgrade immediately
          logger.warn('billing_issue', { uid });
          break;

        default:
          logger.info('revenuecat_unhandled_event', { type: event.type });
      }

      res.status(200).send('OK');
    } catch (err) {
      logger.error('revenuecat_webhook_error', { uid, error: err });
      res.status(500).send('Internal error');
    }
  }
);

async function syncSubscription(
  uid: string,
  sub: {
    tier: SubscriptionTier;
    isInTrial: boolean;
    expiresAt: Timestamp | null;
    subscriptionId: string | null;
    purchaseSource: PurchaseSource | null;
    cancelledAt: Timestamp | null;
  }
): Promise<void> {
  await getFirestore().collection('users').doc(uid).update({
    subscription: {
      tier: sub.tier,
      isInTrial: sub.isInTrial,
      expiresAt: sub.expiresAt,
      subscriptionId: sub.subscriptionId,
      purchaseSource: sub.purchaseSource,
      cancelledAt: sub.cancelledAt,
    },
    lastActiveAt: FieldValue.serverTimestamp(),
  });
}

function deriveTier(productId: string): SubscriptionTier {
  if (productId.includes('weekly')) return 'weekly';
  if (productId.includes('yearly')) return 'yearly';
  throw new Error(`Unknown product: ${productId}`);
}
