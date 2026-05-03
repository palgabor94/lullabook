export interface GeneratedImage {
  taskId: string;
  imageBuffer: Buffer;
  costUsd: number;
}

import { ArtStyle } from '../../domain/entities/Hero';

export interface HeroRevealInput {
  artStyle: ArtStyle;
  definingTraits: string | null;
  childPhotoStoragePath: string;
  openingSceneDescription?: string;
}

export interface SceneInput {
  scenePrompt: string;
  definingTraits: string;
  refStoragePath: string;
  artStyle?: string;
}

export interface CoverImageInput {
  coverImagePrompt: string;
  definingTraits: string;
  heroAnchorStoragePath: string;
  artStyle: string;
  originalPhotoStoragePath?: string | null;
  buddyPhotoStoragePath?: string | null;
}

export interface IImageProvider {
  generateHeroReveal(input: HeroRevealInput): Promise<GeneratedImage>;
  generateCoverImage(input: CoverImageInput): Promise<GeneratedImage>;
  generateScene(input: SceneInput): Promise<GeneratedImage>;
}
