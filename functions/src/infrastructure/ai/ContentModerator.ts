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
    this.client = new OpenAI({ apiKey, fetch: globalThis.fetch });
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

    // Children's stories naturally contain mild conflict (dragons, villains, chases).
    // Use score thresholds instead of the binary flag to avoid false positives.
    const THRESHOLDS: Record<string, number> = {
      'violence':           0.85, // high threshold — adventure/conflict is normal
      'violence/graphic':   0.50, // graphic violence still blocked at lower threshold
    };
    const DEFAULT_THRESHOLD = 0.50;

    const blocked = Object.entries(result.category_scores)
      .filter(([cat, score]) => score > (THRESHOLDS[cat] ?? DEFAULT_THRESHOLD))
      .map(([cat]) => cat);

    if (blocked.length > 0) {
      throw new Error(`content_flagged: ${blocked.join(', ')}`);
    }
  }
}
