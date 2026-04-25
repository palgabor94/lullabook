export class ElevenLabsTts {
  private apiKey: string;
  private baseUrl = 'https://api.elevenlabs.io/v1';

  // Default voice IDs per language — can be overridden via systemPrompts doc
  private static readonly DEFAULT_VOICES: Record<string, string> = {
    'en-US': 'EXAVITQu4vr4xnSDxMaL', // Sarah — warm, calm
    'hu-HU': 'EXAVITQu4vr4xnSDxMaL',
    'de-DE': 'EXAVITQu4vr4xnSDxMaL',
  };

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  voiceIdFor(language: string): string {
    return ElevenLabsTts.DEFAULT_VOICES[language] ?? ElevenLabsTts.DEFAULT_VOICES['en-US'];
  }

  async synthesize(input: { text: string; voiceId: string }): Promise<Buffer> {
    const response = await fetch(
      `${this.baseUrl}/text-to-speech/${input.voiceId}`,
      {
        method: 'POST',
        headers: {
          'xi-api-key': this.apiKey,
          'Content-Type': 'application/json',
          Accept: 'audio/mpeg',
        },
        body: JSON.stringify({
          text: input.text,
          model_id: 'eleven_multilingual_v2',
          voice_settings: {
            stability: 0.6,
            similarity_boost: 0.7,
            style: 0.3,
            use_speaker_boost: true,
          },
        }),
      }
    );

    if (!response.ok) {
      const body = await response.text();
      throw new Error(`tts_failed_${response.status}: ${body}`);
    }

    return Buffer.from(await response.arrayBuffer());
  }
}
