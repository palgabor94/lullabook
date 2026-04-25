import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret } from 'firebase-functions/params';
import { logger } from '../utils/logger';
import { StoryOrchestrator } from '../domain/services/StoryOrchestrator';
import { DailyCapManager } from '../domain/services/DailyCapManager';
import { AdventureSetup } from '../domain/entities/Story';

const RUNNINGHUB_KEY = defineSecret('RUNNINGHUB_API_KEY');
const OPENAI_KEY = defineSecret('OPENAI_API_KEY');
const ELEVENLABS_KEY = defineSecret('ELEVENLABS_API_KEY');

interface GenerateStoryInput {
  heroId: string;
  setup: AdventureSetup;
  language: string;
}

export const generateStory = onCall<GenerateStoryInput>(
  {
    secrets: [RUNNINGHUB_KEY, OPENAI_KEY, ELEVENLABS_KEY],
    cors: true,
    memory: '1GiB',
    timeoutSeconds: 300,
    maxInstances: 50,
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign in required');
    }

    const uid = request.auth.uid;
    const { heroId, setup, language } = request.data;

    if (!heroId) throw new HttpsError('invalid-argument', 'heroId required');
    if (!setup?.theme) throw new HttpsError('invalid-argument', 'setup.theme required');

    const capManager = new DailyCapManager(uid);
    const capCheck = await capManager.canGenerate();

    if (!capCheck.allowed) {
      if (capCheck.reason === 'daily_cap_reached') {
        throw new HttpsError(
          'resource-exhausted',
          'Daily story limit reached. New stories available tomorrow at midnight.'
        );
      }
      if (capCheck.reason === 'free_tier_used') {
        throw new HttpsError(
          'resource-exhausted',
          'Free story already used. Upgrade to create more stories.'
        );
      }
      throw new HttpsError('resource-exhausted', 'Story limit reached.');
    }

    const orchestrator = new StoryOrchestrator(
      { uid, heroId, setup, language: language ?? 'en-US' },
      {
        runninghub: RUNNINGHUB_KEY.value(),
        openai: OPENAI_KEY.value(),
        elevenlabs: ELEVENLABS_KEY.value(),
      }
    );

    try {
      const story = await orchestrator.generate();
      await capManager.incrementUsage();
      return { storyId: story.storyId, title: story.title, success: true };
    } catch (err) {
      logger.error('generateStory failed', { uid, heroId, error: err });
      if (err instanceof Error && err.message.startsWith('content_')) {
        throw new HttpsError('invalid-argument', 'Story content could not be approved. Please try different settings.');
      }
      throw new HttpsError('internal', 'Story generation failed. Please try again.');
    }
  }
);
