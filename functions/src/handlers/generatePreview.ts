import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import { Timestamp } from 'firebase-admin/firestore';
import { v4 as uuid } from 'uuid';

import { createImageProvider } from '../infrastructure/ai/createImageProvider';
import { AssetUploader } from '../infrastructure/storage/AssetUploader';
import { PreviewRepository } from '../infrastructure/firestore/PreviewRepository';
import { ADVENTURE_SCENES, ADVENTURE_OPENING_LINES } from '../domain/entities/Preview';
import { hashFingerprint, hashIp } from '../utils/deviceFingerprint';
import { logger } from '../utils/logger';

const RUNNINGHUB_KEY = defineSecret('RUNNINGHUB_API_KEY');
const NANOBANANA_KEY = defineSecret('NANOBANANA_API_KEY');
const IMAGE_PROVIDER = defineString('IMAGE_PROVIDER', { default: 'runninghub' });

interface GeneratePreviewInput {
  childName: string;
  adventureChoice: string;
  artStyle: 'pixar_3d' | 'watercolor' | 'flat_modern' | 'storybook_classic';
  photoBase64: string;
  deviceFingerprint: string;
}

export const generatePreview = onCall<GeneratePreviewInput>(
  {
    secrets: [RUNNINGHUB_KEY, NANOBANANA_KEY],
    invoker: 'public',
    cors: true,
    memory: '1GiB',
    timeoutSeconds: 300,
    maxInstances: 50,
  },
  async (request) => {
    const { childName, adventureChoice, artStyle, photoBase64, deviceFingerprint } = request.data;

    if (!childName || !adventureChoice || !artStyle || !photoBase64 || !deviceFingerprint) {
      throw new HttpsError('invalid-argument', 'Missing required fields');
    }

    const ipHash = hashIp(request.rawRequest?.ip ?? 'unknown');
    const fpHash = hashFingerprint(deviceFingerprint);

    const previewRepo = new PreviewRepository();
    const blocked = await previewRepo.isRateLimited(fpHash, ipHash);
    if (blocked) {
      throw new HttpsError('resource-exhausted', 'Too many preview attempts. Try again in 24 hours.');
    }

    const photoBuffer = Buffer.from(photoBase64, 'base64');
    const uploader = new AssetUploader();
    const photoPath = await uploader.uploadTempPhoto(fpHash, photoBuffer);

    const runningHub = createImageProvider(IMAGE_PROVIDER.value(), RUNNINGHUB_KEY.value(), NANOBANANA_KEY.value());
    const sceneDescription = ADVENTURE_SCENES[adventureChoice] ?? ADVENTURE_SCENES.space_explorer;

    let generated;
    try {
      generated = await runningHub.generateHeroReveal({
        artStyle,
        openingSceneDescription: sceneDescription,
        definingTraits: null,
        childPhotoStoragePath: photoPath,
      });
    } catch (err) {
      logger.error('hero_reveal_failed', { adventureChoice, error: err });
      throw new HttpsError('internal', 'Image generation failed. Please try again.');
    }

    const previewId = uuid();
    const imageUrl = await uploader.uploadPreviewImage(previewId, generated.imageBuffer);

    const openingTextFn = ADVENTURE_OPENING_LINES[adventureChoice] ?? ADVENTURE_OPENING_LINES.space_explorer;
    const openingText = openingTextFn(childName);

    await previewRepo.create({
      previewId,
      deviceFingerprint: fpHash,
      ipHash,
      childName,
      adventureChoice,
      artStyle,
      heroRevealImageUrl: imageUrl,
      openingText,
      claimedByUid: null,
      claimedAt: null,
      createdAt: Timestamp.now(),
      expiresAt: Timestamp.fromMillis(Date.now() + 24 * 60 * 60 * 1000),
    });

    logger.info('preview_generated', { previewId, adventureChoice, artStyle });
    return { previewId, imageUrl, openingText, childName };
  }
);
