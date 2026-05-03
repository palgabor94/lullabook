export class ElevenLabsTts {
  private apiKey: string;
  private baseUrl = 'https://api.elevenlabs.io/v1';

  // Vera — multilingual community voice, natural in Hungarian and other languages
  private static readonly DEFAULT_VOICE_ID = 'xjlfQQ3ynqiEyRpArrT8';

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  voiceIdFor(_language: string): string {
    return ElevenLabsTts.DEFAULT_VOICE_ID;
  }

  async synthesize(input: { text: string; voiceId: string; language?: string }): Promise<Buffer> {
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
          model_id: 'eleven_flash_v2_5',
          voice_settings: {
            stability: 0.6,
            similarity_boost: 0.7,
            style: 0.3,
            use_speaker_boost: true,
            speed: 0.85,
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
