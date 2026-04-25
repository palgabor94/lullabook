import { HeroRepository } from '../../infrastructure/firestore/HeroRepository';
import { StoryRepository } from '../../infrastructure/firestore/StoryRepository';
import { GptStoryWriter } from '../../infrastructure/ai/GptStoryWriter';
import { ElevenLabsTts } from '../../infrastructure/ai/ElevenLabsTts';
import { ContentModerator } from '../../infrastructure/ai/ContentModerator';
import { RunningHubClient } from '../../infrastructure/ai/RunningHubClient';
import { AssetUploader } from '../../infrastructure/storage/AssetUploader';
import { StoryDoc, AdventureSetup } from '../entities/Story';
import { logger } from '../../utils/logger';

interface OrchestratorInput {
  uid: string;
  heroId: string;
  setup: AdventureSetup;
  language: string;
}

interface Secrets {
  runninghub: string;
  openai: string;
  elevenlabs: string;
}

export class StoryOrchestrator {
  private heroRepo = new HeroRepository();
  private storyRepo = new StoryRepository();
  private uploader = new AssetUploader();

  private gptWriter: GptStoryWriter;
  private tts: ElevenLabsTts;
  private moderator: ContentModerator;
  private runningHub: RunningHubClient;

  private taskIds: string[] = [];
  private totalCostUsd = 0;
  private retryCount = 0;

  constructor(
    private input: OrchestratorInput,
    secrets: Secrets
  ) {
    this.gptWriter = new GptStoryWriter(secrets.openai);
    this.tts = new ElevenLabsTts(secrets.elevenlabs);
    this.moderator = new ContentModerator(secrets.openai);
    this.runningHub = new RunningHubClient(secrets.runninghub);
  }

  async generate(): Promise<StoryDoc> {
    const startTime = Date.now();
    const { uid, heroId, setup, language } = this.input;

    // 1. Load hero
    const hero = await this.heroRepo.get(uid, heroId);
    if (!hero) throw new Error('hero_not_found');

    // 2. Write story text (GPT-4o)
    logger.info('story_orchestrator: writing story text', { uid, heroId });
    const storyOutput = await this.gptWriter.write({ hero, setup, language });
    this.totalCostUsd += 0.05; // rough GPT-4o estimate

    // 3. Moderate the full text
    const allText = storyOutput.pages.map((p) => p.text).join('\n');
    await this.moderator.assertSafe(allText);

    // 4. Determine if first story (page 1 reuses hero anchor)
    const isFirstStory = await this.heroRepo.isFirstStoryForHero(uid, heroId);

    // 5. Generate images in parallel (skip page 1 if first story)
    const pagesToGenerate = isFirstStory
      ? storyOutput.pages.slice(1)
      : storyOutput.pages;

    logger.info('story_orchestrator: generating images', {
      uid,
      count: pagesToGenerate.length,
    });

    const imageResults = await Promise.allSettled(
      pagesToGenerate.map((page) =>
        this.generateImageWithRetry({
          heroAnchorStoragePath: hero.heroAnchorStoragePath,
          definingTraits: hero.definingTraits,
          scenePrompt: page.imagePrompt,
          artStyle: hero.artStyle,
        })
      )
    );

    // 6. Generate TTS for all 8 pages in parallel
    const voiceId = this.tts.voiceIdFor(language);
    logger.info('story_orchestrator: synthesizing TTS', { uid, voiceId });

    const audioResults = await Promise.all(
      storyOutput.pages.map((page) =>
        this.tts.synthesize({ text: page.text, voiceId })
      )
    );

    // 7. Reserve story ID and upload all assets
    const storyId = require('uuid').v4() as string;
    logger.info('story_orchestrator: uploading assets', { uid, storyId });

    // Upload images
    const imageUrlMap = new Map<number, string>();
    if (isFirstStory) {
      // Page 1 uses the hero anchor URL
      imageUrlMap.set(1, hero.heroAnchorImageUrl);
    }

    let imgIndex = 0;
    for (const page of pagesToGenerate) {
      const result = imageResults[imgIndex++];
      if (result.status === 'fulfilled') {
        const url = await this.uploader.uploadStoryPageImage(
          uid,
          storyId,
          page.pageNumber,
          result.value.imageBuffer
        );
        imageUrlMap.set(page.pageNumber, url);
        this.totalCostUsd += result.value.costUsd;
        this.taskIds.push(result.value.taskId);
      } else {
        logger.warn('story_orchestrator: image generation failed for page', {
          pageNumber: page.pageNumber,
          error: result.reason,
        });
        imageUrlMap.set(page.pageNumber, '');
      }
    }

    // Upload audio
    const audioUrlMap = new Map<number, string>();
    for (let i = 0; i < storyOutput.pages.length; i++) {
      const page = storyOutput.pages[i];
      const url = await this.uploader.uploadStoryPageAudio(
        uid,
        storyId,
        page.pageNumber,
        audioResults[i]
      );
      audioUrlMap.set(page.pageNumber, url);
    }
    this.totalCostUsd += storyOutput.pages.length * 0.0003; // ElevenLabs estimate

    // 8. Assemble final pages
    const finalPages = storyOutput.pages.map((p) => ({
      pageNumber: p.pageNumber,
      text: p.text,
      imagePrompt: p.imagePrompt,
      imageUrl: imageUrlMap.get(p.pageNumber) ?? '',
      audioUrl: audioUrlMap.get(p.pageNumber) ?? '',
      isReusedFromHeroReveal: isFirstStory && p.pageNumber === 1,
    }));

    // 9. Estimate duration from page count (fallback: 30s per page)
    const durationSeconds = storyOutput.pages.length * 30;

    // 10. Persist to Firestore
    const story = await this.storyRepo.create(uid, {
      heroId,
      title: storyOutput.title,
      language,
      setup,
      pages: finalPages,
      durationSeconds,
      generationMetadata: {
        imageProvider: 'runninghub',
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
    heroAnchorStoragePath: string;
    definingTraits: string;
    scenePrompt: string;
    artStyle: string;
  }): Promise<{ imageBuffer: Buffer; taskId: string; costUsd: number }> {
    try {
      return await this.runningHub.generateScene(input as Parameters<typeof this.runningHub.generateScene>[0]);
    } catch (firstErr) {
      this.retryCount++;
      logger.warn('story_orchestrator: image retry', { error: firstErr });
      return await this.runningHub.generateScene(input as Parameters<typeof this.runningHub.generateScene>[0]);
    }
  }
}
