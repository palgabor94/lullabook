import { onCall, HttpsError } from 'firebase-functions/v2/https';

export const claimPreview = onCall(async (request) => {
  if (!request.auth) throw new HttpsError('unauthenticated', 'Sign in required');
  throw new HttpsError('unimplemented', 'claimPreview not yet implemented');
});
