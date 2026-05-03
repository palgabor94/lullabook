import { onCall, HttpsError } from 'firebase-functions/v2/https';
import { defineSecret, defineString } from 'firebase-functions/params';
import { v4 as uuid } from 'uuid';

import { createImageProvider } from '../infrastructure/ai/createImageProvider';
import { AssetUploader } from '../infrastructure/storage/AssetUploader';
import { HeroRepository } from '../infrastructure/firestore/HeroRepository';
import { PreviewRepository } from '../infrastructure/firestore/PreviewRepository';
import { UserRepository } from '../infrastructure/firestore/UserRepository';
import { ArtStyle, Pronouns } from '../domain/entities/Hero';
import { logger } from '../utils/logger';

const RUNNINGHUB_KEY = defineSecret('RUNNINGHUB_API_KEY');
const NANOBANANA_KEY = defineSecret('NANOBANANA_API_KEY');
const IMAGE_PROVIDER = defineString('IMAGE_PROVIDER', { default: 'runninghub' });

interface CreateHeroInput {
  name: string;
  age: number;
  pronouns: Pronouns;
  definingTraits: string;
  artStyle: ArtStyle;
  debugMode?: boolean;
  // One of the two must be provided:
  photoBase64?: string;   // fresh photo upload
  previewId?: string;     // reuse preview image as anchor
}

export const createHero = onCall<CreateHeroInput>(
  {
    secrets: [RUNNINGHUB_KEY, NANOBANANA_KEY],
    cors: true,
    memory: '1GiB',
    timeoutSeconds: 180,
  },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');

    const uid = request.auth.uid;
    const { name, age, pronouns, definingTraits, artStyle, photoBase64, previewId, debugMode } = request.data;

    if (!name || !age || !artStyle) throw new HttpsError('invalid-argument', 'Missing required hero fields');
    if (!photoBase64 && !previewId) throw new HttpsError('invalid-argument', 'Provide photoBase64 or previewId');

    if (!debugMode) {
      try {
        await new UserRepository().checkAndIncrementHeroCreation(uid);
      } catch {
        throw new HttpsError('resource-exhausted', 'You can only create one hero per day. Come back tomorrow!');
      }
    }

    const heroId = uuid();
    const uploader = new AssetUploader();
    const heroRepo = new HeroRepository();
    let anchorStoragePath: string;
    let anchorImageUrl: string;
    let originalPhotoStoragePath: string | null = null;

    if (previewId) {
      // Reuse preview image as hero anchor — no original photo stored
      const previewRepo = new PreviewRepository();
      const preview = await previewRepo.get(previewId);
      if (!preview) throw new HttpsError('not-found', 'Preview not found');

      // Copy preview image to heroes/ path
      const imageRes = await fetch(preview.heroRevealImageUrl);
      const buffer = Buffer.from(await imageRes.arrayBuffer());
      const paths = await uploader.uploadHeroAnchor(uid, heroId, buffer);
      anchorStoragePath = paths.storagePath;
      anchorImageUrl = paths.imageUrl;
    } else {
      // Generate new anchor from fresh photo via RunningHub
      const photoBuffer = Buffer.from(photoBase64!, 'base64');
      const photoPath = await uploader.uploadTempPhoto(uid, photoBuffer);
      originalPhotoStoragePath = photoPath;

      const runningHub = createImageProvider(IMAGE_PROVIDER.value(), RUNNINGHUB_KEY.value(), NANOBANANA_KEY.value());
      let generated;
      try {
        generated = await runningHub.generateHeroReveal({
          artStyle,
          definingTraits: definingTraits || null,
          childPhotoStoragePath: photoPath,
        });
      } catch (err) {
        logger.error('hero_anchor_generation_failed', { uid, error: err });
        throw new HttpsError('internal', 'Hero image generation failed. Please try again.');
      }

      const paths = await uploader.uploadHeroAnchor(uid, heroId, generated.imageBuffer);
      anchorStoragePath = paths.storagePath;
      anchorImageUrl = paths.imageUrl;
    }

    await heroRepo.create(uid, {
      heroId,
      name,
      age,
      pronouns: pronouns ?? 'they/them',
      definingTraits: definingTraits ?? '',
      heroAnchorStoragePath: anchorStoragePath,
      heroAnchorImageUrl: anchorImageUrl,
      heroAnchorThumbUrl: anchorImageUrl,
      artStyle,
      regenCount: 0,
      narrativeTraits: [],
      originalPhotoStoragePath,
      originalPhotoDeletedAt: null,
    });

    logger.info('hero_created', { uid, heroId, artStyle });
    return { heroId, heroAnchorImageUrl: anchorImageUrl };
  }
);
