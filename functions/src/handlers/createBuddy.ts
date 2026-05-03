import { onCall, HttpsError } from 'firebase-functions/v2/https';

import { AssetUploader } from '../infrastructure/storage/AssetUploader';
import { BuddyRepository } from '../infrastructure/firestore/BuddyRepository';
import { logger } from '../utils/logger';

const VALID_TYPES = ['dad', 'mom', 'sibling', 'dog', 'cat', 'grandpa', 'grandma', 'friend'];

interface CreateBuddyInput {
  buddyId: string;      // = type id, e.g. 'dad'
  type: string;
  name?: string;
  photoBase64?: string;
}

export const createBuddy = onCall<CreateBuddyInput>(
  {
    cors: true,
    memory: '512MiB',
    timeoutSeconds: 60,
  },
  async (request) => {
    if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');

    const uid = request.auth.uid;
    const { buddyId, type, name, photoBase64 } = request.data;

    if (!buddyId || !VALID_TYPES.includes(buddyId)) {
      throw new HttpsError('invalid-argument', 'Valid buddyId (type) is required');
    }

    const buddyRepo = new BuddyRepository();
    let photoUrl: string | undefined;
    let photoStoragePath: string | undefined;

    if (photoBase64) {
      const uploader = new AssetUploader();
      const photoBuffer = Buffer.from(photoBase64, 'base64');
      const upload = await uploader.uploadBuddyPhoto(uid, buddyId, photoBuffer);
      photoUrl = upload.imageUrl;
      photoStoragePath = upload.storagePath;
    }

    await buddyRepo.upsert(uid, {
      buddyId,
      type: type ?? buddyId,
      ...(name?.trim() ? { name: name.trim() } : {}),
      ...(photoUrl ? { photoUrl, photoThumbUrl: photoUrl, photoStoragePath } : {}),
    });

    logger.info('buddy_upserted', { uid, buddyId, hasPhoto: !!photoUrl });
    return { buddyId, photoUrl: photoUrl ?? null };
  }
);
