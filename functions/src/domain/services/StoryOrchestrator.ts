import { HeroRepository } from '../../infrastructure/firestore/HeroRepository';
import { StoryRepository } from '../../infrastructure/firestore/StoryRepository';
import { GptStoryWriter } from '../../infrastructure/ai/GptStoryWriter';
import { ElevenLabsTts } from '../../infrastructure/ai/ElevenLabsTts';
import { ContentModerator } from '../../infrastructure/ai/ContentModerator';
import { IImageProvider } from '../../infrastructure/ai/IImageProvider';
import { createImageProvider } from '../../infrastructure/ai/createImageProvider';
import { AssetUploader } from '../../infrastructure/storage/AssetUploader';
import { StoryDoc, AdventureSetup } from '../entities/Story';
import { logger } from '../../utils/logger';

interface OrchestratorInput {
  uid: string;
  heroId: string;
  storyId: string;
  setup: AdventureSetup;
  language: string;
  debugMode: boolean;
  debugPageCount?: number;
  debugImageCount?: number;
}


interface Secrets {
  imageProvider: string;
  runninghub: string;
  nanobanana: string;
  openai: string;
  elevenlabs?: string;
}

export class StoryOrchestrator {
  private heroRepo = new HeroRepository();
  private storyRepo = new StoryRepository();
  private uploader = new AssetUploader();

  private gptWriter: GptStoryWriter;
  private tts: ElevenLabsTts | null;
  private moderator: ContentModerator;
  private imageClient: IImageProvider;
  private imageProviderName: string;

  private taskIds: string[] = [];
  private totalCostUsd = 0;
  private retryCount = 0;

  constructor(
    private input: OrchestratorInput,
    secrets: Secrets
  ) {
    this.gptWriter = new GptStoryWriter(secrets.openai);
    this.tts = secrets.elevenlabs ? new ElevenLabsTts(secrets.elevenlabs) : null;
    this.moderator = new ContentModerator(secrets.openai);
    this.imageProviderName = secrets.imageProvider;
    this.imageClient = createImageProvider(secrets.imageProvider, secrets.runninghub, secrets.nanobanana);
  }

  async generate(): Promise<StoryDoc> {
    const startTime = Date.now();
    const { uid, heroId, storyId, setup, language } = this.input;

    // 1. Load hero (always from Firestore; debugMode only controls generation behaviour)
    logger.info('story_orchestrator: step1 load hero', { uid, heroId, debugMode: this.input.debugMode });
    const hero = await this.heroRepo.get(uid, heroId);
    if (!hero) throw new Error('hero_not_found');

    // 2. Write story text (GPT-4o) — includes coverImagePrompt + coverCaption
    logger.info('story_orchestrator: step2 writing story text', { uid, heroId });
    const storyOutput = await this.gptWriter.write({
      hero, setup, language,
      pageCount: this.input.debugPageCount,
    });
    logger.info('story_orchestrator: step2 done', { uid, title: storyOutput.title });
    this.totalCostUsd += 0.05;

    // 3. Moderate the full text
    logger.info('story_orchestrator: step3 moderation', { uid });
    const allText = storyOutput.pages.map((p) => p.text).join('\n');
    await this.moderator.assertSafe(allText);
    logger.info('story_orchestrator: step3 done', { uid });

    // 4. Write initial Firestore stub so Flutter can subscribe immediately
    logger.info('story_orchestrator: step4 init pending story', { uid, storyId });
    await this.storyRepo.initPending(uid, storyId, {
      heroId,
      title: storyOutput.title,
      language,
      setup,
    });

    // 5. Generate cover image first (sequential) — all characters together
    const PLACEHOLDER_URL = 'https://placehold.co/512x512/7C3AED/white?text=📖';
    let coverImageUrl = '';
    let coverStoragePath: string | null = null;

    if (this.input.debugMode) {
      logger.info('story_orchestrator: debug mode — skipping cover image', { uid });
      coverImageUrl = PLACEHOLDER_URL;
      await this.storyRepo.updateCoverReady(uid, storyId, coverImageUrl, storyOutput.coverCaption);
    } else {
      logger.info('story_orchestrator: step5 generating cover image', { uid });
      const coverInput = {
        coverImagePrompt: storyOutput.coverImagePrompt,
        definingTraits: hero.definingTraits,
        heroAnchorStoragePath: hero.heroAnchorStoragePath,
        artStyle: hero.artStyle,
        originalPhotoStoragePath:
          hero.originalPhotoStoragePath && !hero.originalPhotoDeletedAt
            ? hero.originalPhotoStoragePath
            : null,
        buddyPhotoStoragePath: setup.buddyPhotoStoragePath ?? null,
      };

      const maxCoverAttempts = 3;
      let coverGenerated = false;
      for (let attempt = 1; attempt <= maxCoverAttempts; attempt++) {
        try {
          const coverResult = await this.imageClient.generateCoverImage(coverInput);
          const coverUpload = await this.uploader.uploadStoryCoverImage(uid, storyId, coverResult.imageBuffer);
          coverImageUrl = coverUpload.imageUrl;
          coverStoragePath = coverUpload.storagePath;
          this.totalCostUsd += coverResult.costUsd;
          this.taskIds.push(coverResult.taskId);
          coverGenerated = true;
          logger.info('story_orchestrator: step5 cover ready', { uid, storyId, attempt });
          await this.storyRepo.updateCoverReady(uid, storyId, coverImageUrl, storyOutput.coverCaption);
          break;
        } catch (err) {
          logger.warn('story_orchestrator: cover attempt failed', {
            uid,
            attempt,
            error: err instanceof Error ? err.message : String(err),
          });
          if (attempt < maxCoverAttempts) await this.sleep(2000);
        }
      }
      if (!coverGenerated) {
        logger.warn('story_orchestrator: cover image failed after all retries, continuing', { uid });
        await this.storyRepo.updateCoverError(uid, storyId);
      }
    }

    // 6. Determine the single reference image for page generation.
    //    Prefer the cover (all characters together); fall back to hero anchor if cover failed.
    const pageRefStoragePath = coverStoragePath ?? hero.heroAnchorStoragePath;

    // 7. Generate page images (all in prod; debug can limit via debugImageCount)
    let imageResults: PromiseSettledResult<{ imageBuffer: Buffer; taskId: string; costUsd: number }>[];

    const imageCount = this.input.debugMode
      ? (this.input.debugImageCount ?? 0)
      : storyOutput.pages.length;

    if (this.input.debugMode && imageCount === 0) {
      logger.info('story_orchestrator: debug mode — skipping all page images', { uid });
      imageResults = storyOutput.pages.map(() => ({
        status: 'fulfilled' as const,
        value: { imageBuffer: Buffer.alloc(0), taskId: 'debug', costUsd: 0 },
      }));
    } else if (this.input.debugMode) {
      logger.info('story_orchestrator: debug mode — generating partial page images', { uid, imageCount });
      const realResults = await Promise.allSettled(
        storyOutput.pages.slice(0, imageCount).map((page) =>
          this.generateImageWithRetry({
            refStoragePath: pageRefStoragePath,
            definingTraits: hero.definingTraits,
            scenePrompt: page.imagePrompt,
            artStyle: hero.artStyle,
          })
        )
      );
      const placeholders = storyOutput.pages.slice(imageCount).map(() => ({
        status: 'fulfilled' as const,
        value: { imageBuffer: Buffer.alloc(0), taskId: 'debug', costUsd: 0 },
      }));
      imageResults = [...realResults, ...placeholders];
    } else {
      logger.info('story_orchestrator: step7 generating page images', { uid, count: storyOutput.pages.length });
      imageResults = await Promise.allSettled(
        storyOutput.pages.map((page) =>
          this.generateImageWithRetry({
            refStoragePath: pageRefStoragePath,
            definingTraits: hero.definingTraits,
            scenePrompt: page.imagePrompt,
            artStyle: hero.artStyle,
          })
        )
      );
    }

    // 8. Generate TTS for all 8 pages in parallel
    const voiceId = this.tts ? this.tts.voiceIdFor(language) : '';
    let audioResults: (Buffer | null)[] = storyOutput.pages.map(() => null);

    if (this.tts) {
      logger.info('story_orchestrator: step8 synthesizing TTS', { uid, voiceId });
      // Starter plan allows max 3 concurrent requests — process in batches of 3
      const CONCURRENCY = 3;
      const settled: PromiseSettledResult<Buffer>[] = [];
      for (let i = 0; i < storyOutput.pages.length; i += CONCURRENCY) {
        const batch = storyOutput.pages.slice(i, i + CONCURRENCY);
        const batchResults = await Promise.allSettled(
          batch.map((page) => this.tts!.synthesize({ text: page.text, voiceId, language }))
        );
        settled.push(...batchResults);
      }
      audioResults = settled.map((r, i) => {
        if (r.status === 'fulfilled') return r.value;
        logger.warn('story_orchestrator: tts failed for page', {
          pageNumber: storyOutput.pages[i].pageNumber,
          error: r.reason instanceof Error ? r.reason.message : String(r.reason),
        });
        return null;
      });
    } else {
      logger.info('story_orchestrator: skipping TTS (no ElevenLabs key)', { uid });
    }

    // 9. Upload page images
    logger.info('story_orchestrator: step9 uploading assets', { uid, storyId });
    const imageUrlMap = new Map<number, string>();

    for (let i = 0; i < storyOutput.pages.length; i++) {
      const page = storyOutput.pages[i];
      const result = imageResults[i];
      if (result.status === 'fulfilled') {
        if (this.input.debugMode) {
          imageUrlMap.set(page.pageNumber, PLACEHOLDER_URL);
        } else {
          const url = await this.uploader.uploadStoryPageImage(
            uid, storyId, page.pageNumber, result.value.imageBuffer
          );
          imageUrlMap.set(page.pageNumber, url);
          this.totalCostUsd += result.value.costUsd;
          this.taskIds.push(result.value.taskId);
        }
      } else {
        logger.warn('story_orchestrator: image generation failed for page', {
          pageNumber: page.pageNumber,
          error: result.reason instanceof Error ? result.reason.message : String(result.reason),
        });
        imageUrlMap.set(page.pageNumber, '');
      }
    }

    // 10. Upload audio
    const audioUrlMap = new Map<number, string>();
    for (let i = 0; i < storyOutput.pages.length; i++) {
      const page = storyOutput.pages[i];
      const audioBuffer = audioResults[i];
      if (audioBuffer) {
        const url = await this.uploader.uploadStoryPageAudio(uid, storyId, page.pageNumber, audioBuffer);
        audioUrlMap.set(page.pageNumber, url);
        this.totalCostUsd += 0.0003;
      } else {
        audioUrlMap.set(page.pageNumber, '');
      }
    }

    // 11. Assemble final pages
    const finalPages = storyOutput.pages.map((p) => ({
      pageNumber: p.pageNumber,
      text: p.text,
      imagePrompt: p.imagePrompt,
      imageUrl: imageUrlMap.get(p.pageNumber) ?? '',
      audioUrl: audioUrlMap.get(p.pageNumber) ?? '',
      isReusedFromHeroReveal: false,
    }));

    const durationSeconds = storyOutput.pages.length * 30;

    // 12. Final Firestore write (overwrites the stub with complete data)
    logger.info('story_orchestrator: step12 finalizing story', { uid, storyId });
    const story = await this.storyRepo.finalize(uid, storyId, {
      heroId,
      title: storyOutput.title,
      language,
      setup,
      status: 'complete',
      coverImageUrl,
      coverCaption: storyOutput.coverCaption,
      pages: finalPages,
      durationSeconds,
      generationMetadata: {
        imageProvider: this.imageProviderName,
        runningHubTaskIds: this.taskIds,
        retryCount: this.retryCount,
        totalCostUsd: Math.round(this.totalCostUsd * 10000) / 10000,
        durationMs: Date.now() - startTime,
        storyWriterModel: 'gpt-4o-2024-11-20',
        ttsProvider: 'elevenlabs',
        ttsVoiceId: voiceId,
      },
    });

    logger.info('story_orchestrator: done', {
      uid,
      storyId: story.storyId,
      durationMs: Date.now() - startTime,
      totalCostUsd: this.totalCostUsd,
    });

    return story;
  }

  private async generateImageWithRetry(input: {
    refStoragePath: string;
    definingTraits: string;
    scenePrompt: string;
    artStyle: string;
  }): Promise<{ imageBuffer: Buffer; taskId: string; costUsd: number }> {
    const maxAttempts = 3;
    let lastErr: unknown;
    for (let attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        return await this.imageClient.generateScene(input);
      } catch (err) {
        lastErr = err;
        this.retryCount++;
        const errMsg = err instanceof Error ? err.message : String(err);
        const timeoutMatch = errMsg.match(/(?:runninghub|nanobanana)_timeout_(.+)/);
        const abandonedTaskId = timeoutMatch ? timeoutMatch[1] : undefined;
        logger.warn('story_orchestrator: image retry', {
          attempt,
          ...(abandonedTaskId ? { abandonedTaskId } : {}),
          error: errMsg,
        });
        if (attempt < maxAttempts) await this.sleep(2000);
      }
    }
    throw lastErr;
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((r) => setTimeout(r, ms));
  }
}
