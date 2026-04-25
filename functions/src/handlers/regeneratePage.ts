import { onCall, HttpsError } from 'firebase-functions/v2/https';

export const regeneratePage = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');
  throw new HttpsError('unimplemented', 'regeneratePage not yet implemented');
});
