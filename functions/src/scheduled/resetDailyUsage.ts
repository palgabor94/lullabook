import { onSchedule } from 'firebase-functions/v2/scheduler';

export const resetDailyUsage = onSchedule('every 60 minutes', async () => {
  // TODO: implement
});
