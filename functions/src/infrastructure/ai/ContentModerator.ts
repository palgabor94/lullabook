import OpenAI from 'openai';

// Patterns that should never appear in a children's story regardless of moderation score
const CHILD_SAFETY_PATTERNS = [
  /\b(blood|gore|murder|kill|dead body|corpse|torture)\b/i,
  /\b(sex|sexual|naked|nude|adult content)\b/i,
  /\b(drug|cocaine|heroin|marijuana|alcohol)\b/i,
  /\b(bomb|weapon|gun|shoot|stab)\b/i,
];

export class ContentModerator {
  private client: OpenAI;

  constructor(apiKey: string) {
    this.client = new OpenAI({ apiKey });
  }

  async assertSafe(text: string): Promise<void> {
    // Quick regex check first (cheaper)
    for (const pattern of CHILD_SAFETY_PATTERNS) {
      if (pattern.test(text)) {
        throw new Error(`content_blocked_regex: pattern matched`);
      }
    }

    // OpenAI moderation API
    const response = await this.client.moderations.create({ input: text });
    const result = response.results[0];

    if (result.flagged) {
      const flaggedCategories = Object.entries(result.categories)
        .filter(([, flagged]) => flagged)
        .map(([cat]) => cat)
        .join(', ');
      throw new Error(`content_flagged: ${flaggedCategories}`);
    }
  }
}
