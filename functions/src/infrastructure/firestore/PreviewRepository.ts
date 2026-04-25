import { getFirestore, FieldValue, Timestamp } from 'firebase-admin/firestore';
import { PreviewDoc } from '../../domain/entities/Preview';

const MAX_PREVIEWS_PER_DEVICE = 3;
const WINDOW_HOURS = 24;

export class PreviewRepository {
  private db = getFirestore();
  private col = this.db.collection('previews');
  private abuse = this.db.collection('abuseTracking');

  async create(preview: PreviewDoc): Promise<void> {
    await this.col.doc(preview.previewId).set(preview);
  }

  async get(previewId: string): Promise<PreviewDoc | null> {
    const snap = await this.col.doc(previewId).get();
    return snap.exists ? (snap.data() as PreviewDoc) : null;
  }

  async claim(previewId: string, uid: string): Promise<void> {
    await this.col.doc(previewId).update({
      claimedByUid: uid,
      claimedAt: FieldValue.serverTimestamp(),
    });
  }

  async isRateLimited(fingerprint: string, ipHash: string): Promise<boolean> {
    const windowStart = Timestamp.fromMillis(Date.now() - WINDOW_HOURS * 60 * 60 * 1000);

    const snap = await this.col
      .where('deviceFingerprint', '==', fingerprint)
      .where('createdAt', '>=', windowStart)
      .get();

    if (snap.size >= MAX_PREVIEWS_PER_DEVICE) {
      await this.abuse.doc(fingerprint).set(
        {
          deviceFingerprint: fingerprint,
          ipHashes: FieldValue.arrayUnion(ipHash),
          blockedUntil: Timestamp.fromMillis(Date.now() + WINDOW_HOURS * 60 * 60 * 1000),
          totalAttempts: FieldValue.increment(1),
          previewAttempts: FieldValue.arrayUnion({
            timestamp: Timestamp.now(),
            ipHash,
            result: 'blocked',
          }),
        },
        { merge: true }
      );
      return true;
    }

    await this.abuse.doc(fingerprint).set(
      {
        deviceFingerprint: fingerprint,
        ipHashes: FieldValue.arrayUnion(ipHash),
        totalAttempts: FieldValue.increment(1),
        previewAttempts: FieldValue.arrayUnion({
          timestamp: Timestamp.now(),
          ipHash,
          result: 'success',
        }),
      },
      { merge: true }
    );

    return false;
  }
}
