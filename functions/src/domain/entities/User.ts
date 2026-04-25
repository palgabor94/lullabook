import { Timestamp } from 'firebase-admin/firestore';

export interface UserDoc {
  uid: string;
  email: string;
  displayName: string | null;
  locale: string;
  contentLanguage: string;
  timezone: string;
  createdAt: Timestamp;
  lastActiveAt: Timestamp;

  subscription: {
    tier: 'free' | 'weekly' | 'yearly';
    purchaseSource: 'apple' | 'google' | null;
    subscriptionId: string | null;
    expiresAt: Timestamp | null;
    isInTrial: boolean;
    cancelledAt: Timestamp | null;
  };

  dailyUsage: {
    date: string;
    storiesGenerated: number;
  };

  totalStoriesCreated: number;
  totalHeroesCreated: number;
  previewsUsed: number;
  hasVoiceModel: boolean;
  voiceModelId: string | null;
}
