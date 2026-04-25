import { initializeApp } from 'firebase-admin/app';
initializeApp();

export { generatePreview } from './handlers/generatePreview';
export { claimPreview } from './handlers/claimPreview';
export { createHero } from './handlers/createHero';
export { regenerateHeroAnchor } from './handlers/regenerateHeroAnchor';
export { generateStory } from './handlers/generateStory';
export { regeneratePage } from './handlers/regeneratePage';
export { deleteAccount } from './handlers/deleteAccount';
export { onUserCreate } from './triggers/onUserCreate';
export { revenuecatWebhook } from './webhooks/revenuecatWebhook';
export { cleanupExpiredPreviews } from './scheduled/cleanupExpiredPreviews';
export { resetDailyUsage } from './scheduled/resetDailyUsage';
