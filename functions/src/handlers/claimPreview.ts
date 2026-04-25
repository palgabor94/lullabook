import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';
import { PreviewRepository } from '../infrastructure/firestore/PreviewRepository';
import { logger } from '../utils/logger';

export const claimPreview = onCall<{ previewId: string }>(
  { cors: true },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');

    const uid = request.auth.uid;
    const { previewId } = request.data;

    if (!previewId) throw new HttpsError('invalid-argument', 'previewId required');

    const previewRepo = new PreviewRepository();
    const preview = await previewRepo.get(previewId);

    if (!preview) throw new HttpsError('not-found', 'Preview not found');
    if (preview.claimedByUid) throw new HttpsError('already-exists', 'Preview already claimed');

    // Link preview to user
    await previewRepo.claim(previewId, uid);

    // Increment previewsUsed on user doc
    await getFirestore().collection('users').doc(uid).update({
      previewsUsed: FieldValue.increment(1),
    });

    logger.info('preview_claimed', { previewId, uid });

    // Return hero anchor data so the client can proceed to hero setup
    return {
      heroRevealImageUrl: preview.heroRevealImageUrl,
      childName: preview.childName,
      artStyle: preview.artStyle,
    };
  }
);
