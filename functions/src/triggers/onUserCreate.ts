import { auth } from 'firebase-functions/v1';
import { UserRepository } from '../infrastructure/firestore/UserRepository';
import { logger } from '../utils/logger';

const userRepo = new UserRepository();

export const onUserCreate = auth.user().onCreate(async (user) => {
  try {
    await userRepo.create(
      user.uid,
      user.email ?? '',
      user.displayName ?? null,
    );

    logger.info('user_created', { uid: user.uid, email: user.email });
  } catch (err) {
    logger.error('user_create_failed', { uid: user.uid, error: err });
    throw err;
  }
});
