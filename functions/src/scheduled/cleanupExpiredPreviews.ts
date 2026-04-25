import { onSchedule } from 'firebase-functions/v2/scheduler';

export const cleanupExpiredPreviews = onSchedule('every 60 minutes', async () => {
  // TODO: implement
});
