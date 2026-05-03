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

interface NanoBananaSubmitResponse {
  code: number;
  msg: string;
  data: {
    taskId: string;
  };
}

interface NanoBananaQueryResponse {
  code: number;
  msg: string;
  data: {
    taskId: string;
    successFlag: 0 | 1 | 2 | 3;
    errorCode: number | null;
    errorMessage: string | null;
    response: {
      originImageUrl: string | null;
      resultImageUrl: string;
    } | null;
  };
}

export class NanoBananaClient implements IImageProvider {
  private generateEndpoint = 'https://api.nanobananaapi.ai/api/v1/nanobanana/generate';
  private queryEndpoint = 'https://api.nanobananaapi.ai/api/v1/nanobanana/record-info';
  private pollIntervalMs = 2500;
  private maxPollMs = 150_000;

  constructor(private apiKey: string) {}

  async generateHeroReveal(input: HeroRevealInput): Promise<GeneratedImage> {
    const photoUrl = await this.signedUrlFor(input.childPhotoStoragePath);
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
    const result = await this.pollUntilDone(submitRes.data.taskId);

    if (result.data?.successFlag !== 1 || !result.data?.response?.resultImageUrl) {
      throw new Error(`nanobanana_task_failed: ${result.data?.errorCode} ${result.data?.errorMessage}`);
    }

    const imageBuffer = await this.downloadImage(result.data.response.resultImageUrl);
    return { taskId: submitRes.data.taskId, imageBuffer, costUsd: 0.02 };
  }

  private async submit(payload: { prompt: string; imageUrls: string[] }): Promise<NanoBananaSubmitResponse> {
    const hasImages = payload.imageUrls.length > 0;
    const body: Record<string, unknown> = {
      prompt: payload.prompt,
      type: hasImages ? 'IMAGETOIAMGE' : 'TEXTTOIAMGE',
      image_size: '3:4',
      numImages: 1,
      callBackUrl: 'https://example.com/noop',
    };
    if (hasImages) {
      body['imageUrls'] = payload.imageUrls;
    }

    const res = await fetch(this.generateEndpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${this.apiKey}`,
      },
      body: JSON.stringify(body),
    });

    if (!res.ok) {
      const text = await res.text();
      throw new Error(`nanobanana_http_${res.status}: ${text}`);
    }

    const submitRes = await res.json() as NanoBananaSubmitResponse;
    if (submitRes.code !== 200) {
      throw new Error(`nanobanana_submit_failed: ${submitRes.code} ${submitRes.msg}`);
    }

    logger.info('nanobanana_submit', { taskId: submitRes.data.taskId });
    return submitRes;
  }

  private async pollUntilDone(taskId: string): Promise<NanoBananaQueryResponse> {
    const deadline = Date.now() + this.maxPollMs;

    while (Date.now() < deadline) {
      const res = await fetch(`${this.queryEndpoint}?taskId=${encodeURIComponent(taskId)}`, {
        headers: { Authorization: `Bearer ${this.apiKey}` },
      });

      const rawBody = await res.text();
      let result: NanoBananaQueryResponse;
      try {
        result = JSON.parse(rawBody) as NanoBananaQueryResponse;
      } catch {
        logger.error('nanobanana_poll_parse_error', { taskId, httpStatus: res.status, rawBody: rawBody.slice(0, 500) });
        await this.sleep(this.pollIntervalMs);
        continue;
      }

      const flag = result.data?.successFlag;
      logger.info('nanobanana_poll', {
        taskId,
        httpStatus: res.status,
        responseCode: result.code,
        responseMsg: result.msg,
        successFlag: flag,
        dataKeys: result.data ? Object.keys(result.data) : null,
      });

      if (!res.ok || result.code !== 200) {
        logger.error('nanobanana_poll_http_error', { taskId, httpStatus: res.status, code: result.code, msg: result.msg });
        throw new Error(`nanobanana_poll_error_${res.status}_code_${result.code}`);
      }

      if (flag === 1) return result;
      if (flag === 2 || flag === 3) {
        logger.error('nanobanana_task_failed', {
          taskId,
          successFlag: flag,
          errorCode: result.data?.errorCode,
          errorMessage: result.data?.errorMessage,
        });
        return result;
      }

      await this.sleep(this.pollIntervalMs);
    }

    logger.warn('nanobanana_poll_timeout', { taskId, maxPollMs: this.maxPollMs });
    throw new Error(`nanobanana_timeout_${taskId}`);
  }

  private async downloadImage(url: string): Promise<Buffer> {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`nanobanana_image_download_failed_${res.status}`);
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
