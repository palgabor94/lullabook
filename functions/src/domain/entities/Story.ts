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
  imageProvider: 'runninghub';
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
  setup: {
    theme: string;
    companion: string | null;
    location: string;
    goal: string;
    teachingMoment: string | null;
  };
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
  companion: string | null;
  location: string;
  goal: string;
  teachingMoment: string | null;
}

// GPT-4o output schema
export interface GptStoryOutput {
  title: string;
  pages: Array<{
    pageNumber: number;
    text: string;
    imagePrompt: string;
  }>;
}
