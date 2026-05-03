import { HeroRevealInput, SceneInput, CoverImageInput } from './IImageProvider';

export const ART_STYLE_PROMPTS: Record<string, string> = {
  pixar_3d: "warm 3D-rendered children's book illustration, Pixar-style, soft cinematic lighting, expressive features",
  watercolor: "gentle watercolor children's book illustration, soft edges, pastel palette, traditional storybook aesthetic",
  flat_modern: "contemporary flat-vector children's book illustration, bold colors, clean geometric shapes, modern picture book style",
  storybook_classic: "detailed ink-and-wash children's book illustration, warm tones, classic heritage storybook style",
  ghibli: "hand-painted Studio Ghibli-style illustration, soft painterly textures, lush warm colors, dreamy atmospheric lighting, whimsical nature details, gentle expressive characters in the style of Hayao Miyazaki",
  anime: "vibrant Japanese anime-style children's illustration, large expressive eyes, clean crisp linework, bright saturated colors, dynamic and charming character design",
  comic: "bold comic book style children's illustration, strong ink outlines, vivid flat colors, energetic halftone accents, fun and playful panel composition",
};

export function buildHeroRevealPrompt(input: HeroRevealInput): string {
  const style = ART_STYLE_PROMPTS[input.artStyle];
  const traits = input.definingTraits ? `- Additional defining traits: ${input.definingTraits}\n` : '';

  const faceRules = `FACE LIKENESS — absolute top priority:
- Copy the child's EXACT face structure from the reference photo: face shape (round/oval/square/heart), eye shape and colour, nose shape, mouth and lip shape, eyebrow shape and thickness
- Preserve every distinctive feature without exception: freckles, dimples, birthmarks, glasses, gap teeth, skin tone
- Hair: exact colour (do not lighten or darken), texture (straight/wavy/curly), length, and style
- The illustrated character must be immediately recognisable as the same child — a parent must look at it and say "that's my child"
- Do NOT idealise, symmetrise, round out, or average the face — render THIS specific child's unique features
- STYLE BALANCE: Translate the child's features into the chosen illustration style — apply slightly larger expressive eyes, softer skin rendering, and stylised proportions appropriate for a children's book character. The result must look like an ILLUSTRATION of this specific child, not a photograph. Recognisable likeness and illustration style must coexist — neither should sacrifice the other.`;

  if (!input.openingSceneDescription) {
    return `Art style: ${style}.

CHARACTER REFERENCE SHEET — this will be the master visual identity reused across all story pages.

${faceRules}
${traits}
COMPOSITION:
- Full body, facing forward or slight three-quarter view, clearly visible head to toe
- PLAIN WHITE or soft neutral solid background — no scenery, no props, no decorations
- Completely empty hands — nothing held or carried
- Warm, even studio lighting — character sharply and evenly lit
- Friendly, natural expression`.trim();
  }

  return `Art style: ${style}.

Transform the child in the reference photo into the hero of this scene.

${faceRules}
${traits}
Scene: ${input.openingSceneDescription}

Composition: Cinematic storybook illustration, warm and inviting, soft lighting. The character is the focal point.`.trim();
}

export function buildScenePrompt(input: SceneInput): string {
  const style = ART_STYLE_PROMPTS[input.artStyle ?? 'pixar_3d'];
  return `${style} storybook illustration.

Scene: ${input.scenePrompt}

The main character is the child shown in the FIRST reference image (${input.definingTraits}).
Reproduce their exact face, hair, skin tone and all features from the first reference image. Do NOT invent a new character or use a generic face.
Render the character's pose and facial expression EXACTLY as described in the scene — every body position detail and every expression detail matters.
Only draw characters explicitly shown in the scene description above.`.trim();
}

export function buildCoverPrompt(input: CoverImageInput): string {
  const styleDesc = ART_STYLE_PROMPTS[input.artStyle] ?? ART_STYLE_PROMPTS['pixar_3d'];
  return `Art style: ${styleDesc}.

${input.coverImagePrompt}

CHARACTER SHEET RULES — follow strictly:

HERO FACE FIDELITY — absolute top priority:
- The FIRST reference image is the hero — reproduce the hero's face EXACTLY: same face shape, eye shape and colour, nose shape, mouth shape, eyebrow shape, skin tone, hair colour and texture
- Do NOT average the face or replace it with a generic face — render THIS specific child's unique features
- Defining traits of the hero: ${input.definingTraits}
- STYLE BALANCE: Translate the hero's features into the chosen illustration style — apply slightly larger expressive eyes, softer skin rendering, and stylised proportions appropriate for a children's book character. The result must look like an ILLUSTRATION of this specific child, not a photograph. Recognisable likeness and illustration style must coexist — neither should sacrifice the other.

COMPANION CHARACTERS:
- Reproduce every companion's appearance exactly from their reference image
- Same face structure, skin tone, hair, and distinctive features as in the reference

PROPORTIONS — mandatory:
- Draw every character at their realistic height relative to the others
- An adult must visibly tower over a young child — do NOT draw them at the same height
- A 5-year-old child reaches roughly to an adult's chest; a 3-year-old to the waist
- Size differences between characters must be immediately obvious in the image

COMPOSITION:
- ALL characters shown full-body, facing forward or slight three-quarter view, clearly separated from each other
- PLAIN NEUTRAL BACKGROUND only — soft gradient or solid pastel backdrop, no environment, no scenery
- Every character has EMPTY HANDS — nothing held or carried
- Warm, flat studio lighting — every character equally lit and sharply visible
- No action, no interaction between characters, no story context

This is a character consistency reference sheet used to lock in every character's exact appearance for all 8 story pages.`.trim();
}
