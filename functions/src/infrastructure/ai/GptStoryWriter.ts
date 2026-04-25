import OpenAI from 'openai';
import { getFirestore } from 'firebase-admin/firestore';
import { HeroDoc } from '../../domain/entities/Hero';
import { AdventureSetup, GptStoryOutput } from '../../domain/entities/Story';

export class GptStoryWriter {
  private client: OpenAI;
  private db = getFirestore();

  constructor(apiKey: string) {
    this.client = new OpenAI({ apiKey });
  }

  async write(input: {
    hero: HeroDoc;
    setup: AdventureSetup;
    language: string;
  }): Promise<GptStoryOutput> {
    const systemPrompt = await this.loadSystemPrompt(input.language);

    const userMessage = JSON.stringify({
      heroName: input.hero.name,
      heroAge: input.hero.age,
      heroPronouns: input.hero.pronouns,
      definingTraits: input.hero.definingTraits,
      artStyle: input.hero.artStyle,
      setup: input.setup,
      language: input.language,
    });

    const response = await this.client.chat.completions.create({
      model: 'gpt-4o-2024-11-20',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userMessage },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.8,
      max_tokens: 4000,
    });

    const content = response.choices[0].message.content;
    if (!content) throw new Error('gpt_empty_response');

    return this.parseAndValidate(content);
  }

  private async loadSystemPrompt(language: string): Promise<string> {
    const snap = await this.db.collection('systemPrompts').doc(language).get();
    if (snap.exists) {
      const data = snap.data()!;
      return data.storyWriterPrompt as string;
    }
    return this.defaultSystemPrompt();
  }

  private parseAndValidate(content: string): GptStoryOutput {
    let parsed: GptStoryOutput;
    try {
      parsed = JSON.parse(content) as GptStoryOutput;
    } catch {
      throw new Error('gpt_invalid_json');
    }

    if (!parsed.title || typeof parsed.title !== 'string') {
      throw new Error('gpt_missing_title');
    }
    if (!Array.isArray(parsed.pages) || parsed.pages.length !== 8) {
      throw new Error(`gpt_wrong_page_count: ${parsed.pages?.length}`);
    }
    for (const page of parsed.pages) {
      if (!page.pageNumber || !page.text || !page.imagePrompt) {
        throw new Error('gpt_invalid_page');
      }
    }

    return parsed;
  }

  private defaultSystemPrompt(): string {
    return `You are a children's bedtime story writer. Create a personalized, calming, age-appropriate 8-page story.

The user provides: heroName, heroAge, heroPronouns, definingTraits, artStyle, setup (theme/companion/location/goal/teachingMoment), and language.

Return ONLY valid JSON matching this schema:
{
  "title": "string (creative story title, max 60 chars)",
  "pages": [
    {
      "pageNumber": 1,
      "text": "string (2-4 sentences, calming bedtime tone, in the requested language)",
      "imagePrompt": "string (vivid scene description in English for image generation, 50-100 words)"
    }
    // pages 1 through 8
  ]
}

Guidelines:
- Story arc: setup (p1-2), rising action (p3-5), climax (p6-7), resolution/sleep (p8)
- Page 8 always ends with the hero settling down to sleep peacefully
- Text written in the requested language; imagePrompt always in English
- Age-appropriate vocabulary for the hero's age
- If teachingMoment is provided, weave it naturally into the story
- If companion is provided, include them meaningfully
- imagePrompts must describe what the hero looks like doing/experiencing the scene — include art style context
- Each imagePrompt must be self-contained (the image AI sees only one prompt per page)`;
  }
}
