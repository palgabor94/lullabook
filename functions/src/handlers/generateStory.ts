import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import { logger } from '../utils/logger';
import { StoryOrchestrator } from '../domain/services/StoryOrchestrator';
import { DailyCapManager } from '../domain/services/DailyCapManager';
import { AdventureSetup } from '../domain/entities/Story';

const RUNNINGHUB_KEY = defineSecret('RUNNINGHUB_API_KEY');
const NANOBANANA_KEY = defineSecret('NANOBANANA_API_KEY');
const OPENAI_KEY = defineSecret('OPENAI_API_KEY');
const ELEVENLABS_KEY = defineSecret('ELEVENLABS_API_KEY');
const IMAGE_PROVIDER = defineString('IMAGE_PROVIDER', { default: 'runninghub' });

interface GenerateStoryInput {
  storyId: string;
  heroId: string;
  setup: AdventureSetup;
  language: string;
  debugMode?: boolean;
  debugPageCount?: number;
  debugImageCount?: number;
}

export const generateStory = onCall<GenerateStoryInput>(
  {
    secrets: [RUNNINGHUB_KEY, NANOBANANA_KEY, OPENAI_KEY, ELEVENLABS_KEY],
    cors: true,
    memory: '1GiB',
    timeoutSeconds: 540,
    maxInstances: 50,
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign in required');
    }

    const uid = request.auth.uid;
    const { storyId, heroId, setup, language, debugMode, debugPageCount, debugImageCount } = request.data;

    if (!storyId) throw new HttpsError('invalid-argument', 'storyId required');
    if (!debugMode && !heroId) throw new HttpsError('invalid-argument', 'heroId required');
    if (!setup?.theme) throw new HttpsError('invalid-argument', 'setup.theme required');

    // Skip daily cap check in debug mode
    if (!debugMode) {
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
    }

    const orchestrator = new StoryOrchestrator(
      {
        uid, storyId, heroId: heroId ?? 'debug', setup, language: language ?? 'en-US',
        debugMode: debugMode ?? false,
        debugPageCount: debugMode ? (debugPageCount ?? 8) : undefined,
        debugImageCount: debugMode ? (debugImageCount ?? debugPageCount ?? 8) : undefined,
      },
      {
        imageProvider: IMAGE_PROVIDER.value(),
        runninghub: RUNNINGHUB_KEY.value(),
        nanobanana: NANOBANANA_KEY.value(),
        openai: OPENAI_KEY.value(),
        elevenlabs: ELEVENLABS_KEY.value(),
      }
    );

    let story;
    try {
      story = await orchestrator.generate();
    } catch (err) {
      const errMsg = err instanceof Error ? err.message : String(err);
      const errStack = err instanceof Error ? err.stack : undefined;
      logger.error('generateStory failed', { uid, heroId, errMsg, errStack });
      if (err instanceof Error && err.message.startsWith('content_')) {
        throw new HttpsError('invalid-argument', 'Story content could not be approved. Please try different settings.');
      }
      throw new HttpsError('internal', `Story generation failed: ${errMsg}`);
    }

    // Increment usage separately — failure here must not undo a successful story generation
    if (!debugMode) {
      try {
        await new DailyCapManager(uid).incrementUsage();
      } catch (err) {
        logger.warn('incrementUsage failed (non-fatal)', { uid, error: err });
      }
    }

    return { storyId: story.storyId, title: story.title, success: true };
  }
);
