import { Timestamp } from 'firebase-admin/firestore';

export interface StoryPage {
  pageNumber: number;
  text: string;
  imageUrl: string;
  audioUrl: string;
  imagePrompt: string;
  isReusedFromHeroReveal: boolean;
}

export interface GenerationMetadata {
  imageProvider: string;
  runningHubTaskIds: string[];
  retryCount: number;
  totalCostUsd: number;
  durationMs: number;
  storyWriterModel: string;
  ttsProvider: 'elevenlabs';
  ttsVoiceId: string;
}

export interface StoryDoc {
  storyId: string;
  heroId: string;
  title: string;
  language: string;
  setup: AdventureSetup;
  status: 'cover_generating' | 'cover_ready' | 'cover_error' | 'complete';
  coverImageUrl: string;
  coverCaption: string;
  pages: StoryPage[];
  durationSeconds: number;
  readCount: number;
  lastReadAt: Timestamp | null;
  favorite: boolean;
  generationMetadata: GenerationMetadata;
  createdAt: Timestamp;
}

export interface AdventureSetup {
  theme: string;
  themeId?: string;               // machine id: 'cosy_home' | 'astronaut' | ...
  companion: string | null;       // type id: 'dad' | 'mom' | 'dog' | ...
  companionName: string | null;   // display name: 'Rex', 'Bence', 'Kutya', ...
  location: string;
  goal: string;
  teachingMoment: string | null;
  buddyPhotoStoragePath: string | null;
}

// GPT-4o output schema
export interface GptStoryOutput {
  title: string;
  coverImagePrompt: string;
  coverCaption: string;
  pages: Array<{
    pageNumber: number;
    text: string;
    imagePrompt: string;
  }>;
}
