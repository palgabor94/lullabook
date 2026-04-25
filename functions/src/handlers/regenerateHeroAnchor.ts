import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';

import { RunningHubClient } from '../infrastructure/ai/RunningHubClient';
import { AssetUploader } from '../infrastructure/storage/AssetUploader';
import { HeroRepository } from '../infrastructure/firestore/HeroRepository';
import { logger } from '../utils/logger';

const RUNNINGHUB_KEY = defineSecret('RUNNINGHUB_API_KEY');
const MAX_REGENS = 2;

export const regenerateHeroAnchor = onCall<{ heroId: string }>(
  {
    secrets: [RUNNINGHUB_KEY],
    cors: true,
    memory: '1GiB',
    timeoutSeconds: 180,
  },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');

    const uid = request.auth.uid;
    const { heroId } = request.data;
    if (!heroId) throw new HttpsError('invalid-argument', 'heroId required');

    const heroRepo = new HeroRepository();
    const hero = await heroRepo.get(uid, heroId);
    if (!hero) throw new HttpsError('not-found', 'Hero not found');

    if (hero.regenCount >= MAX_REGENS) {
      throw new HttpsError(
        'resource-exhausted',
        `Maximum ${MAX_REGENS} regenerations allowed during onboarding.`
      );
    }

    const runningHub = new RunningHubClient(RUNNINGHUB_KEY.value());
    let generated;
    try {
      generated = await runningHub.generateScene({
        scenePrompt: `${hero.name} stands ready for a magical adventure, smiling warmly`,
        definingTraits: hero.definingTraits,
        heroAnchorStoragePath: hero.heroAnchorStoragePath,
      });
    } catch (err) {
      logger.error('hero_regen_failed', { uid, heroId, error: err });
      throw new HttpsError('internal', 'Image generation failed. Please try again.');
    }

    const uploader = new AssetUploader();
    const paths = await uploader.uploadHeroAnchor(uid, heroId, generated.imageBuffer);

    await heroRepo.updateAnchor(uid, heroId, {
      heroAnchorStoragePath: paths.storagePath,
      heroAnchorImageUrl: paths.imageUrl,
      heroAnchorThumbUrl: paths.thumbUrl,
    });

    logger.info('hero_anchor_regenerated', { uid, heroId, regenCount: hero.regenCount + 1 });
    return { heroAnchorImageUrl: paths.imageUrl, regenCount: hero.regenCount + 1 };
  }
);
