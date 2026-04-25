import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { logger } from '../utils/logger';
import { HeroRepository } from '../infrastructure/firestore/HeroRepository';
import { StoryRepository } from '../infrastructure/firestore/StoryRepository';
import { RunningHubClient } from '../infrastructure/ai/RunningHubClient';
import { AssetUploader } from '../infrastructure/storage/AssetUploader';

const RUNNINGHUB_KEY = defineSecret('RUNNINGHUB_API_KEY');

interface RegeneratePageInput {
  storyId: string;
  pageNumber: number;
}

export const regeneratePage = onCall<RegeneratePageInput>(
  {
    secrets: [RUNNINGHUB_KEY],
    cors: true,
    memory: '512MiB',
    timeoutSeconds: 180,
    maxInstances: 50,
  },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');

    const uid = request.auth.uid;
    const { storyId, pageNumber } = request.data;

    if (!storyId) throw new HttpsError('invalid-argument', 'storyId required');
    if (!pageNumber) throw new HttpsError('invalid-argument', 'pageNumber required');

    const storyRepo = new StoryRepository();
    const heroRepo = new HeroRepository();
    const uploader = new AssetUploader();
    const runningHub = new RunningHubClient(RUNNINGHUB_KEY.value());

    const story = await storyRepo.get(uid, storyId);
    if (!story) throw new HttpsError('not-found', 'Story not found');

    const page = story.pages.find((p) => p.pageNumber === pageNumber);
    if (!page) throw new HttpsError('not-found', 'Page not found');

    const hero = await heroRepo.get(uid, story.heroId);
    if (!hero) throw new HttpsError('not-found', 'Hero not found');

    try {
      const result = await runningHub.generateScene({
        heroAnchorStoragePath: hero.heroAnchorStoragePath,
        definingTraits: hero.definingTraits,
        scenePrompt: page.imagePrompt,
        artStyle: hero.artStyle,
      });

      const imageUrl = await uploader.uploadStoryPageImage(uid, storyId, pageNumber, result.imageBuffer);

      await storyRepo.updatePage(uid, storyId, pageNumber, {
        imageUrl,
        imagePrompt: page.imagePrompt,
      });

      return { imageUrl, success: true };
    } catch (err) {
      logger.error('regeneratePage failed', { uid, storyId, pageNumber, error: err });
      throw new HttpsError('internal', 'Image regeneration failed. Please try again.');
    }
  }
);
