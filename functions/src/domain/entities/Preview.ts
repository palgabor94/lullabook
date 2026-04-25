import { Timestamp } from 'firebase-admin/firestore';

export interface PreviewDoc {
  previewId: string;
  deviceFingerprint: string;
  ipHash: string;
  childName: string;
  adventureChoice: string;
  artStyle: string;
  heroRevealImageUrl: string;
  openingText: string;
  claimedByUid: string | null;
  claimedAt: Timestamp | null;
  createdAt: Timestamp;
  expiresAt: Timestamp;
}

export const ADVENTURE_CHOICES = [
  'space_explorer',
  'ocean_diver',
  'dragon_rider',
  'forest_fairy',
  'treasure_hunter',
  'time_traveler',
] as const;

export type AdventureChoice = (typeof ADVENTURE_CHOICES)[number];

export const ADVENTURE_SCENES: Record<string, string> = {
  space_explorer: 'standing at the entrance of a colorful rocket ship, ready for a cosmic adventure among the stars',
  ocean_diver: 'swimming with friendly dolphins in a glowing magical underwater kingdom full of colorful fish',
  dragon_rider: 'riding a friendly rainbow dragon soaring through cotton candy clouds at sunset',
  forest_fairy: 'exploring an enchanted forest glade surrounded by glowing fireflies and giant magical mushrooms',
  treasure_hunter: 'discovering an ancient golden treasure chest on a sunny tropical island beach',
  time_traveler: 'stepping through a glowing swirling portal into a prehistoric world of friendly dinosaurs',
};

export const ADVENTURE_OPENING_LINES: Record<string, (name: string) => string> = {
  space_explorer: (n) => `${n} gazed up at the stars, heart pounding with excitement. Tonight, the whole galaxy was waiting.`,
  ocean_diver: (n) => `The moment ${n} dipped a toe into the sparkling sea, a friendly dolphin appeared with a wink.`,
  dragon_rider: (n) => `${n} reached out a hand, and the rainbow dragon lowered its head with a happy rumble.`,
  forest_fairy: (n) => `With one step into the glowing forest, ${n} knew tonight would be like no other.`,
  treasure_hunter: (n) => `${n}'s map led here — and sure enough, a glimmer of gold peeked through the sand.`,
  time_traveler: (n) => `The portal hummed and swirled, and ${n} stepped through into a world no one else had ever seen.`,
};
