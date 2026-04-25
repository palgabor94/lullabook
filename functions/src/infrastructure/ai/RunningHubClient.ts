import { getStorage } from 'firebase-admin/storage';
import { logger } from '../../utils/logger';

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

export interface GeneratedImage {
  taskId: string;
  imageBuffer: Buffer;
  costUsd: number;
}

export interface HeroRevealInput {
  artStyle: 'pixar_3d' | 'watercolor' | 'flat_modern' | 'storybook_classic';
  openingSceneDescription: string;
  definingTraits: string | null;
  childPhotoStoragePath: string;
}

export interface SceneInput {
  scenePrompt: string;
  definingTraits: string;
  heroAnchorStoragePath: string;
}

const ART_STYLE_PROMPTS: Record<string, string> = {
  pixar_3d: "warm 3D-rendered children's book illustration, Pixar-style, soft cinematic lighting, expressive features",
  watercolor: "gentle watercolor children's book illustration, soft edges, pastel palette, traditional storybook aesthetic",
  flat_modern: "contemporary flat-vector children's book illustration, bold colors, clean geometric shapes, modern picture book style",
  storybook_classic: "detailed ink-and-wash children's book illustration, warm tones, classic heritage storybook style",
};

export class RunningHubClient {
  private editEndpoint = 'https://www.runninghub.ai/openapi/v2/rhart-image-v1/edit';
  private queryEndpoint = 'https://www.runninghub.ai/openapi/v2/query';
  private pollIntervalMs = 2500;
  private maxPollMs = 120_000;

  constructor(private apiKey: string) {}

  async generateHeroReveal(input: HeroRevealInput): Promise<GeneratedImage> {
    const photoUrl = await this.signedUrlFor(input.childPhotoStoragePath);
    const prompt = this.buildHeroRevealPrompt(input);
    return this.submitAndPoll({ prompt, imageUrls: [photoUrl] });
  }

  async generateScene(input: SceneInput): Promise<GeneratedImage> {
    const anchorUrl = await this.signedUrlFor(input.heroAnchorStoragePath);
    const prompt = this.buildScenePrompt(input);
    return this.submitAndPoll({ prompt, imageUrls: [anchorUrl] });
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

    if (!res.ok) throw new Error(`runninghub_http_${res.status}`);
    return res.json() as Promise<SubmitResponse>;
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

      if (result.status === 'SUCCESS' || result.status === 'FAILED') return result;
      await this.sleep(this.pollIntervalMs);
    }

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

  private buildHeroRevealPrompt(input: HeroRevealInput): string {
    const style = ART_STYLE_PROMPTS[input.artStyle];
    return `
Create a ${style}.

This is the opening illustration of a personalized children's bedtime storybook.
Transform the child in the reference photo into the hero of this scene.

Scene: ${input.openingSceneDescription}

Character requirements:
- Faithfully preserve the child's facial features, hair color and style, skin tone, and any distinctive traits visible in the reference photo
- Friendly, warm expression, engaged with the scene
- Three-quarter or full body visible
${input.definingTraits ? `- Defining traits: ${input.definingTraits}` : ''}

Composition: Cinematic storybook illustration, warm and inviting, soft lighting suitable for a bedtime story.
The character is the focal point and the background tells part of the story.
This image will be reused as the master reference for consistency across 7 additional pages.
    `.trim();
  }

  private buildScenePrompt(input: SceneInput): string {
    return `
Create an illustration matching the reference image's art style and character EXACTLY.

Scene: ${input.scenePrompt}

CRITICAL CONSISTENCY RULES:
- The character must be visually identical to the reference: same face, hair, skin tone, defining features
- Defining traits to preserve: ${input.definingTraits}
- Art style must match the reference precisely
- The character's outfit may change to fit the scene

Composition: Cinematic storybook page illustration. Character should be clearly visible and identifiable.
    `.trim();
  }
}
