import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { getStorage } from 'firebase-admin/storage';
import { HeroRepository } from '../infrastructure/firestore/HeroRepository';
import { logger } from '../utils/logger';

export const deleteHero = onCall<{ heroId: string }>(
  { cors: true, memory: '256MiB', timeoutSeconds: 30 },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');

    const uid = request.auth.uid;
    const { heroId } = request.data;
    if (!heroId) throw new HttpsError('invalid-argument', 'heroId required');

    const heroRepo = new HeroRepository();
    const hero = await heroRepo.get(uid, heroId);
    if (!hero) throw new HttpsError('not-found', 'Hero not found');

    await heroRepo.delete(uid, heroId);

    // Best-effort storage cleanup — don't fail the whole operation if this errors
    try {
      const bucket = getStorage().bucket();
      const [files] = await bucket.getFiles({ prefix: `heroes/${uid}/${heroId}/` });
      await Promise.all(files.map((f) => f.delete()));
      if (hero.originalPhotoStoragePath) {
        await bucket.file(hero.originalPhotoStoragePath).delete().catch(() => {});
      }
    } catch (err) {
      logger.warn('deleteHero: storage cleanup failed', { uid, heroId, error: err });
    }

    logger.info('hero_deleted', { uid, heroId });
    return { success: true };
  }
);
