import { getStorage } from 'firebase-admin/storage';
import { logger } from '../../utils/logger';
import {
  IImageProvider,
  GeneratedImage,
  HeroRevealInput,
  SceneInput,
  CoverImageInput,
} from './IImageProvider';
import { buildHeroRevealPrompt, buildScenePrompt, buildCoverPrompt } from './imagePrompts';

interface SubmitResponse {
  taskId: string;
  status: 'QUEUED' | 'RUNNING' | 'SUCCESS' | 'FAILED';
  errorCode: string;
  errorMessage: string;
}

interface QueryResponse {
  taskId: string;
  status: 'QUEUED' | 'RUNNING' | 'SUCCESS' | 'FAILED';
  errorCode: string;
  errorMessage: string;
  results: Array<{ url: string; nodeId: string; outputType: string }> | null;
}

export class RunningHubClient implements IImageProvider {
  private editEndpoint = 'https://www.runninghub.ai/openapi/v2/rhart-image-v1/edit';
  private queryEndpoint = 'https://www.runninghub.ai/openapi/v2/query';
  private pollIntervalMs = 2500;
  private maxPollMs = 120_000;

  constructor(private apiKey: string) {}

  async generateHeroReveal(input: HeroRevealInput): Promise<GeneratedImage> {
    const photoUrl = await this.signedUrlFor(input.childPhotoStoragePath);
    logger.info('runninghub_hero_reveal_submit', {
      storagePath: input.childPhotoStoragePath,
      signedUrlPrefix: photoUrl.substring(0, 100),
    });
    const prompt = buildHeroRevealPrompt(input);
    return this.submitAndPoll({ prompt, imageUrls: [photoUrl] });
  }

  async generateCoverImage(input: CoverImageInput): Promise<GeneratedImage> {
    const anchorUrl = await this.signedUrlFor(input.heroAnchorStoragePath);
    const extraPaths = [
      input.originalPhotoStoragePath,
      input.buddyPhotoStoragePath,
    ].filter((p): p is string => !!p);
    const extraUrls = await Promise.all(extraPaths.map((p) => this.signedUrlFor(p)));
    const prompt = buildCoverPrompt(input);
    return this.submitAndPoll({ prompt, imageUrls: [anchorUrl, ...extraUrls] });
  }

  async generateScene(input: SceneInput): Promise<GeneratedImage> {
    const refUrl = await this.signedUrlFor(input.refStoragePath);
    const prompt = buildScenePrompt(input);
    return this.submitAndPoll({ prompt, imageUrls: [refUrl] });
  }

  private async submitAndPoll(payload: { prompt: string; imageUrls: string[] }): Promise<GeneratedImage> {
    const submitRes = await this.submit(payload);

    if (submitRes.status === 'FAILED') {
      throw new Error(`runninghub_submit_failed: ${submitRes.errorCode} ${submitRes.errorMessage}`);
    }

    const result = await this.pollUntilDone(submitRes.taskId);

    if (result.status !== 'SUCCESS' || !result.results?.[0]?.url) {
      throw new Error(`runninghub_task_failed: ${result.errorCode} ${result.errorMessage}`);
    }

    const imageBuffer = await this.downloadImage(result.results[0].url);
    return { taskId: submitRes.taskId, imageBuffer, costUsd: 0.012 };
  }

  private async submit(payload: { prompt: string; imageUrls: string[] }): Promise<SubmitResponse> {
    const res = await fetch(this.editEndpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.apiKey}`,
      },
      body: JSON.stringify({ ...payload, aspectRatio: '3:4' }),
    });

    if (!res.ok) {
      const body = await res.text();
      throw new Error(`runninghub_http_${res.status}: ${body}`);
    }
    const submitRes = await res.json() as SubmitResponse;
    logger.info('runninghub_submit', {
      taskId: submitRes.taskId,
      status: submitRes.status,
      errorCode: submitRes.errorCode,
      errorMessage: submitRes.errorMessage,
    });
    return submitRes;
  }

  private async pollUntilDone(taskId: string): Promise<QueryResponse> {
    const deadline = Date.now() + this.maxPollMs;

    while (Date.now() < deadline) {
      const res = await fetch(this.queryEndpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${this.apiKey}`,
        },
        body: JSON.stringify({ taskId }),
      });

      const result = await res.json() as QueryResponse;
      logger.info('runninghub_poll', { taskId, status: result.status });

      if (result.status === 'SUCCESS') return result;
      if (result.status === 'FAILED') {
        logger.error('runninghub_task_failed', {
          taskId,
          errorCode: result.errorCode,
          errorMessage: result.errorMessage,
        });
        return result;
      }
      await this.sleep(this.pollIntervalMs);
    }

    logger.warn('runninghub_poll_timeout', { taskId, maxPollMs: this.maxPollMs });
    throw new Error(`runninghub_timeout_${taskId}`);
  }

  private async downloadImage(url: string): Promise<Buffer> {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`image_download_failed_${res.status}`);
    return Buffer.from(await res.arrayBuffer());
  }

  private async signedUrlFor(storagePath: string): Promise<string> {
    const file = getStorage().bucket().file(storagePath);
    const [url] = await file.getSignedUrl({
      action: 'read',
      expires: Date.now() + 60 * 60 * 1000,
    });
    return url;
  }

  private sleep(ms: number): Promise<void> {
    return new Promise((r) => setTimeout(r, ms));
  }
}
