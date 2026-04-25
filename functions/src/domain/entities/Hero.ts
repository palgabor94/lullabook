import { Timestamp } from 'firebase-admin/firestore';

export type ArtStyle = 'pixar_3d' | 'watercolor' | 'flat_modern' | 'storybook_classic';
export type Pronouns = 'he/him' | 'she/her' | 'they/them';

export interface HeroDoc {
  heroId: string;
  name: string;
  age: number;
  pronouns: Pronouns;
  definingTraits: string;
  heroAnchorStoragePath: string;
  heroAnchorImageUrl: string;
  heroAnchorThumbUrl: string;
  artStyle: ArtStyle;
  regenCount: number;            // 0-2 free regens during onboarding
  narrativeTraits: string[];
  originalPhotoDeletedAt: Timestamp | null;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}
