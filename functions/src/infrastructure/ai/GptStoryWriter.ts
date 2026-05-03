import { getFirestore } from 'firebase-admin/firestore';
import OpenAI from 'openai';
import { HeroDoc } from '../../domain/entities/Hero';
import { AdventureSetup, GptStoryOutput } from '../../domain/entities/Story';

// ── Age groups ────────────────────────────────────────────────────────────────

interface AgeGuidelines {
  group: string;
  sentencesPerPage: string;
  sentenceStructure: string;
  vocabulary: string;
  emotionalDepth: string;
  plotComplexity: string;
  wordsPerPage: string;
  repetitionStyle: string;
}

function ageGuidelinesFor(age: number): AgeGuidelines {
  if (age <= 4) {
    return {
      group: 'toddler (age 3–4)',
      sentencesPerPage: '1–2 very short sentences',
      sentenceStructure: 'simple subject-verb-object; no subordinate clauses',
      vocabulary: 'everyday words a 3-year-old already knows; introduce ONE new word per story maximum',
      emotionalDepth: 'simple happy/scared/excited/sad; always resolves to safe and happy',
      plotComplexity: 'single clear goal; no subplots; obstacle is concrete and small (a locked door, a missing item)',
      wordsPerPage: '20–35 words',
      repetitionStyle: 'repetition of a phrase or action across pages is strongly encouraged (e.g. "{name} looked left, looked right…") — children this age love it',
    };
  } else if (age <= 6) {
    return {
      group: 'preschool (age 5–6)',
      sentencesPerPage: '2–3 sentences',
      sentenceStructure: 'mostly simple sentences; one "because" or "so" connective per page is fine',
      vocabulary: 'familiar words + 2–3 gently new words per story; explain new words in context through action',
      emotionalDepth: 'curiosity, pride, a moment of doubt then courage; mild tension only',
      plotComplexity: 'clear 3-beat structure (problem → try → succeed); one helper character adds richness',
      wordsPerPage: '40–60 words',
      repetitionStyle: 'light repetition for rhythm; vary the exact wording slightly each time',
    };
  } else {
    return {
      group: 'early reader (age 7–8)',
      sentencesPerPage: '3–4 sentences',
      sentenceStructure: 'compound and occasionally complex sentences; vivid adjectives; some figurative language (similes)',
      vocabulary: 'richer descriptive vocabulary; 4–6 ambitious words per story that stretch the child; define them through context',
      emotionalDepth: 'genuine challenge, doubt, frustration → perseverance → earned success; secondary character has their own small arc',
      plotComplexity: 'proper 3-act structure with a real obstacle and at least one unexpected twist in pages 5–6',
      wordsPerPage: '65–95 words',
      repetitionStyle: 'avoid repetition; vary sentence openings; use callbacks (reference something from page 1 on page 7)',
    };
  }
}

// ── Narrative flavours (randomly picked each generation) ─────────────────────

const NARRATIVE_FLAVOURS = [
  { id: 'classic_quest', description: 'Classic quest structure: hero is called to adventure, travels to a far place, faces the central challenge, earns the reward, returns home changed.', openingTone: 'wide-eyed wonder — the hero can barely believe what\'s about to happen', twist: 'the expected path is blocked; hero must find a clever alternative', climaxStyle: 'action + emotional beat combined (physical challenge AND a moment of heart)', endingMood: 'triumphant but tired — the hero is proud and ready for sleep' },
  { id: 'mystery_solver', description: 'Mystery-driven: something is missing, broken, or unexplained. The hero notices clues page by page, pieces them together, and solves it.', openingTone: 'something feels odd — a small detail is out of place', twist: 'a clue turns out to mean something completely different than expected', climaxStyle: 'the "aha!" moment — hero makes the connection and everything clicks', endingMood: 'cosy satisfaction — the mystery is solved and all is well' },
  { id: 'unlikely_friendship', description: 'Friendship story: hero meets someone (or something) who seems scary or different, discovers they have something in common, and forms an unexpected bond.', openingTone: 'nervous and uncertain — the hero doesn\'t know what to make of this stranger', twist: 'the "scary" thing turns out to need help, not the hero', climaxStyle: 'emotional — a moment of vulnerability and trust between the two', endingMood: 'warm and connected — the hero made a friend they didn\'t expect' },
  { id: 'underdog_triumph', description: 'Underdog story: hero starts off doubting themselves or being underestimated. Through small acts of determination, they prove themselves in an unexpected way.', openingTone: 'self-doubt — "am I really the right hero for this?"', twist: 'hero\'s "weakness" turns out to be exactly what saves the day', climaxStyle: 'internal resolve — hero decides to try one more time and it works', endingMood: 'quietly proud — not loud triumph, but deep personal satisfaction' },
  { id: 'rescue_mission', description: 'Rescue story: someone or something the hero loves is in trouble. The hero must be brave, act quickly, and overcome obstacles to help.', openingTone: 'urgent and worried — no time to lose', twist: 'the path to the rescue requires the hero to ask for help (they can\'t do it alone)', climaxStyle: 'teamwork moment — hero and an ally work together at the critical instant', endingMood: 'relief and warmth — everyone is safe, the hero feels the weight lift' },
  { id: 'discovery_wonder', description: 'Discovery story: the hero stumbles upon something magical, hidden, or extraordinary that nobody else has ever seen. The wonder of discovery IS the story.', openingTone: 'curiosity and a little stubbornness — "I wonder what\'s through there"', twist: 'the discovery has a surprising caretaker or guardian who must be convinced', climaxStyle: 'awe — a moment of pure beauty or magic that makes the hero stop and breathe', endingMood: 'dreamy and content — carrying a secret wonder back to bed' },
  { id: 'learning_to_share', description: 'A gentle conflict story: hero has something wonderful (a skill, an object, a place) and must choose between keeping it or sharing it. Sharing makes everything better.', openingTone: 'possessive and a little proud — "this is MINE"', twist: 'sharing unexpectedly multiplies the thing rather than divides it', climaxStyle: 'generosity moment — hero makes the choice and immediately feels lighter', endingMood: 'community warmth — surrounded by others, not alone' },
  { id: 'big_mistake_fixed', description: 'Accountability story: hero accidentally causes a problem (breaks something, loses something, says the wrong thing). The story is about owning it and making it right.', openingTone: 'sinking feeling — uh oh, something just went very wrong', twist: 'trying to hide the mistake makes things briefly worse', climaxStyle: 'honest moment — hero admits what happened and asks for help fixing it', endingMood: 'forgiven and restored — the hero feels much lighter having told the truth' },
  { id: 'quiet_moment', description: 'A gentle slice-of-life story: no quest, no twist, no big climax. The hero notices something small in their everyday world, sits with a feeling, and carries a tiny realization to bed. The whole story is one soft breath.', openingTone: 'a small, ordinary moment — the world pausing for a beat', twist: 'NOT a plot twist — a quiet shift in the hero\'s feelings or attention. They notice something they missed before.', climaxStyle: 'the softest possible peak — a held gaze, a small kindness, a window into something tender. NO action, NO conflict resolution. Just a moment of inner warmth.', endingMood: 'safe, drowsy, gently happy — like being tucked in by someone who loves you' },
];

const COSY_FLAVOUR_IDS = ['quiet_moment', 'unlikely_friendship', 'discovery_wonder', 'learning_to_share', 'big_mistake_fixed'];

function pickFlavourForTheme(themeId: string | undefined, allFlavours: typeof NARRATIVE_FLAVOURS): typeof NARRATIVE_FLAVOURS[0] {
  if (themeId === 'cosy_home') {
    const eligible = allFlavours.filter((f) => COSY_FLAVOUR_IDS.includes(f.id));
    return eligible[Math.floor(Math.random() * eligible.length)];
  }
  const eligible = allFlavours.filter((f) => f.id !== 'quiet_moment');
  return eligible[Math.floor(Math.random() * eligible.length)];
}

// ── Composition planning (NEW) ───────────────────────────────────────────────

/** Camera framing — varies the visual rhythm across pages. */
type ShotType =
  | 'wide_establishing'      // wide shot, character small in landscape
  | 'medium_action'          // waist-up, mid-distance
  | 'close_up_emotion'       // face/upper-body, emotional beat
  | 'over_shoulder'    
  | 'hero_with_environment'    // looking past character at world
  | 'low_angle_hero'         // looking up at hero (powerful)
  | 'high_angle_overview'    // looking down at scene
  | 'silhouette_dramatic'    // backlit, atmospheric
  | 'detail_close';          // close-up of an object/hand

/**
 * A pre-planned composition assignment for one page.
 * The GPT MUST follow these constraints when writing the imagePrompt for that page.
 */
interface PageComposition {
  pageNumber: number;
  /** Who appears in the IMAGE (story text can mention companion regardless). */
  characters: 'hero_only' | 'both' | 'hero_with_environment';
  /** Camera framing. */
  shot: ShotType;
  /** Whether the hero is in motion or static — forces dynamic scenes. */
  motion: 'static' | 'in_motion' | 'reacting';
}

/**
 * Generate a composition plan that enforces variety across pages.
 *
 * Rules baked in:
 * - Page 1 is always wide_establishing (sets the world).
 * - Final page is one of: close_up_emotion (most common, intimate close),
 *   hero_with_environment (peaceful landscape), or wide_establishing (cinematic finale).
 * - If a companion exists, hero appears ALONE on roughly 55% of pages.
 *   - Companion never on the opening page or final page.
 *   - Companion never on two adjacent pages.
 * - For solo heroes, ~25% of middle pages use hero_with_environment to add visual variety
 *   (the environment becomes the "second character").
 * - No two adjacent pages share the same shot type.
 * - Middle pages bias toward in_motion (50%) or reacting (35%) — only 15% static.
 */
function planCompositions(pageCount: number, hasCompanion: boolean, isCosy: boolean = false): PageComposition[] {
  const allShots: ShotType[] = [
    'wide_establishing',
    'medium_action',
    'close_up_emotion',
    'over_shoulder',
    'low_angle_hero',
    'high_angle_overview',
    'silhouette_dramatic',
    'detail_close',
  ];

  // Decide which pages show the companion in the IMAGE.
  // Target: companion appears on ~45% of pages (NOT every page),
  // never adjacent, never on opening or final.
  const companionPageIndices = new Set<number>();

  if (hasCompanion) {
    const targetCompanionPages = Math.max(2, Math.floor(pageCount * 0.45));
    const candidatePages: number[] = [];
    for (let i = 2; i <= pageCount - 1; i++) candidatePages.push(i);

    const shuffled = [...candidatePages].sort(() => Math.random() - 0.5);
    for (const p of shuffled) {
      if (companionPageIndices.size >= targetCompanionPages) break;
      const adjacent = companionPageIndices.has(p - 1) || companionPageIndices.has(p + 1);
      if (!adjacent) companionPageIndices.add(p);
    }
  }

  // Build per-page composition.
  const pages: PageComposition[] = [];
  let lastShot: ShotType | null = null;

  for (let i = 1; i <= pageCount; i++) {
    let shot: ShotType;
    let characters: PageComposition['characters'];
    let motion: PageComposition['motion'];

    if (i === 1) {
      // Always open wide.
      shot = 'wide_establishing';
      characters = hasCompanion ? 'both' : 'hero_with_environment';
      motion = 'static';
    } else if (i === pageCount) {
      // Close with a peaceful, sleep-ready moment. Three flavours for variety:
      // - close_up_emotion: intimate face shot (most common)
      // - hero_with_environment: hero small in a peaceful landscape
      // - wide_establishing: airy, cinematic finale
      const finalShots: ShotType[] = [
        'close_up_emotion',
        'close_up_emotion',     // weighted: appears twice for slight bias toward intimacy
        'hero_with_environment',
        'wide_establishing',
      ];
      shot = finalShots[Math.floor(Math.random() * finalShots.length)];
      characters = shot === 'wide_establishing' ? 'hero_with_environment' : 'hero_only';
      motion = 'static';
    } else {
      // Pick a shot that differs from the previous one. Avoid wide_establishing in the middle.
      const eligible = allShots.filter((s) => s !== lastShot && s !== 'wide_establishing');
      shot = eligible[Math.floor(Math.random() * eligible.length)];

      // Solo hero stories: occasionally use hero_with_environment for visual variety
      // (the environment becomes the "second character"). For companion stories, use the
      // pre-computed companionPageIndices set to determine presence.
      if (!hasCompanion && Math.random() < 0.25) {
        characters = 'hero_with_environment';
      } else {
        characters = companionPageIndices.has(i) ? 'both' : 'hero_only';
      }

      // Bias toward dynamic motion in the middle pages (cosy: mostly still).
      const motionRoll = Math.random();
      motion = isCosy
        ? (motionRoll < 0.7 ? 'static' : 'reacting')
        : (motionRoll < 0.5 ? 'in_motion' : motionRoll < 0.85 ? 'reacting' : 'static');
    }

    pages.push({ pageNumber: i, characters, shot, motion });
    lastShot = shot;
  }

  return pages;
}

/**
 * Convert a composition plan entry into a human-readable instruction
 * that the GPT translates into the imagePrompt.
 */
function compositionToInstruction(comp: PageComposition): string {
  const characterRule = (() => {
    switch (comp.characters) {
      case 'hero_only':
        return 'ONLY THE HERO. The companion is NOT in this image. Do not mention or include the companion in any way — no "in the background", no "watching from afar". The companion does not exist for this page.';
      case 'both':
        return 'BOTH the hero AND the companion. They must INTERACT — not just stand side by side. Show them doing something together: handing an object, pointing at something together, helping each other, reacting to the same thing.';
      case 'hero_with_environment':
        return 'ONLY THE HERO. The environment plays a major role — the hero is small in a vast or detailed setting.';
    }
  })();

  const shotDescription = (() => {
    switch (comp.shot) {
      case 'wide_establishing':
        return 'WIDE ESTABLISHING SHOT — pull the camera back. Character takes up roughly 1/4 of the frame. The world fills the rest. Emphasize landscape and atmosphere.';
      case 'medium_action':
        return 'MEDIUM ACTION SHOT — waist-up framing, mid-distance. Show what the hands and torso are doing.';
      case 'close_up_emotion':
        return 'CLOSE-UP EMOTION SHOT — face and shoulders only. Eyes and expression dominate the frame.';
      case 'over_shoulder':
        return 'OVER-THE-SHOULDER SHOT — camera positioned behind the character\'s shoulder, looking out at what they see. The back of their head/shoulder frames one corner.';
      case 'hero_with_environment':
        return 'HERO WITH ENVIRONMENT — medium-wide framing. The character and the world share equal visual weight. The setting is as important as the character; both must be clearly readable.';
      case 'low_angle_hero':
        return 'LOW ANGLE — camera near the ground, looking up at the character. Makes them look powerful, brave, larger than life.';
      case 'high_angle_overview':
        return 'HIGH ANGLE OVERVIEW — camera above, looking down at the scene. Character appears small. Shows the full layout of the environment.';
      case 'silhouette_dramatic':
        return 'SILHOUETTE / BACKLIT — character is dark against a bright background (sunset, glowing portal, fire, moon). Atmospheric and dramatic.';
      case 'detail_close':
        return 'EXTREME CLOSE-UP DETAIL — focus on a single object the character is holding or touching (hands, an item, a clue). Character\'s body mostly out of frame.';
    }
  })();

  const motionRule = (() => {
    switch (comp.motion) {
      case 'static':
        return 'Character is in a still moment — paused, considering, observing. NOT just standing and looking forward — give a specific reason for the stillness (kneeling to inspect something, frozen mid-thought, leaning against a tree).';
      case 'in_motion':
        return 'Character is ACTIVELY MOVING — running, climbing, leaping, reaching, falling, swimming, ducking. Capture mid-motion with dynamic body language. NOT standing.';
      case 'reacting':
        return 'Character is REACTING to something — caught mid-gasp, recoiling in surprise, lighting up with realization, freezing in alarm, flinching, leaning forward in curiosity. Body language captures the instant.';
    }
  })();

  return `[Page ${comp.pageNumber}]
  • CHARACTERS: ${characterRule}
  • CAMERA: ${shotDescription}
  • ACTION: ${motionRule}`;
}

function softenGuidelinesForCosy(guidelines: AgeGuidelines): AgeGuidelines {
  return {
    ...guidelines,
    emotionalDepth: 'gentle, quiet emotions: cosiness, mild curiosity, soft affection, the warmth of being known. NO mild tension or conflict. NO doubt-then-courage arcs. Just small good feelings.',
    plotComplexity: 'NO plot in the traditional sense. ONE small everyday moment unfolding slowly: noticing something, paying attention, feeling something small. The "story" is the texture of the moment, not a problem-solution arc.',
    repetitionStyle: 'gentle repetition is welcome — soft refrains like "and the kettle whistled" or "and the rain kept falling" anchor the cosy mood.',
  };
}

// ── Story writer ──────────────────────────────────────────────────────────────

export class GptStoryWriter {
  private client: OpenAI;
  private db = getFirestore();

  constructor(apiKey: string) {
    this.client = new OpenAI({ apiKey, fetch: globalThis.fetch });
  }

  async write(input: {
    hero: HeroDoc;
    setup: AdventureSetup;
    language: string;
    pageCount?: number;
  }): Promise<GptStoryOutput> {
    const pageCount = input.pageCount ?? 8;
    const systemPrompt = await this.loadSystemPrompt(input.language);
    const isCosy = input.setup.themeId === 'cosy_home';
    const guidelines = isCosy
      ? softenGuidelinesForCosy(ageGuidelinesFor(input.hero.age))
      : ageGuidelinesFor(input.hero.age);
    const flavour = pickFlavourForTheme(input.setup.themeId, NARRATIVE_FLAVOURS);

    const hasCompanion = !!input.setup.companion;
    const compositionPlan = planCompositions(pageCount, hasCompanion, isCosy);

    const companionInfo = input.setup.companion
      ? {
          companionType: input.setup.companion,
          companionName: input.setup.companionName ?? input.setup.companion,
        }
      : null;

    const userMessage = JSON.stringify({
      heroName: input.hero.name,
      heroAge: input.hero.age,
      ageGroup: guidelines.group,
      heroPronouns: input.hero.pronouns,
      definingTraits: input.hero.definingTraits,
      artStyle: input.hero.artStyle,
      setup: {
        ...input.setup,
        companion: companionInfo,
      },
      language: input.language,
      pageCount,
      writingGuidelines: {
        sentencesPerPage:    guidelines.sentencesPerPage,
        sentenceStructure:   guidelines.sentenceStructure,
        vocabulary:          guidelines.vocabulary,
        emotionalDepth:      guidelines.emotionalDepth,
        plotComplexity:      guidelines.plotComplexity,
        wordsPerPage:        guidelines.wordsPerPage,
        repetitionStyle:     guidelines.repetitionStyle,
      },
      narrativeStyle: {
        type:          flavour.id,
        description:   flavour.description,
        openingTone:   flavour.openingTone,
        twist:         flavour.twist,
        climaxStyle:   flavour.climaxStyle,
        endingMood:    flavour.endingMood,
      },
      // NEW: pre-planned compositions enforce variety mechanically
      compositionPlan: compositionPlan.map((comp) => ({
        pageNumber: comp.pageNumber,
        instructions: compositionToInstruction(comp),
      })),
    });

    const response = await this.client.chat.completions.create({
      model: 'gpt-4o-2024-11-20',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userMessage },
      ],
      response_format: { type: 'json_object' },
      temperature: 0.9,
      max_tokens: 4000,
    });

    const content = response.choices[0].message.content;
    if (!content) throw new Error('gpt_empty_response');

    const parsed = this.parseAndValidate(content, pageCount);

    // Soft validation — log warnings if GPT didn't follow the plan well.
    this.validateCompositionAdherence(parsed, compositionPlan, hasCompanion);

    return parsed;
  }

  private async loadSystemPrompt(language: string): Promise<string> {
    const snap = await this.db.collection('systemPrompts').doc(language).get();
    if (snap.exists) {
      const data = snap.data()!;
      return data.storyWriterPrompt as string;
    }
    return this.buildSystemPrompt();
  }

  private buildSystemPrompt(): string {
    return `You are a master children's bedtime story writer. Your goal is to write a personalized, emotionally resonant story that feels genuinely different every time — not a template with names swapped in.

## Your inputs
The user provides a JSON object with:
- heroName, heroAge, ageGroup, heroPronouns, definingTraits, artStyle
- setup: { theme, companion, location, goal, teachingMoment }
- language, pageCount
- writingGuidelines: STRICT rules about sentence length, vocabulary, complexity
- narrativeStyle: blueprint for plot arc
- compositionPlan: PRE-DETERMINED instructions for each page's image — character presence, camera angle, motion. THIS IS NOT OPTIONAL. You translate these into prose for each imagePrompt.

## Output format
Return ONLY valid JSON:
{
  "title": "string — creative, evocative title (max 60 chars, in the story language, NOT 'The Adventure of X')",
  "coverImagePrompt": "string — character reference sheet, see rules below, in English, 60–100 words",
  "coverCaption": "string — 1–2 sentence teaser in the story language",
  "pages": [
    { "pageNumber": 1, "text": "...", "imagePrompt": "..." }
    // ... exactly pageCount pages
  ]
}

═══════════════════════════════════════════════════════════
CRITICAL: COMPOSITION PLAN ADHERENCE
═══════════════════════════════════════════════════════════

Every page in the user input has a compositionPlan entry. It is a strict contract you MUST follow:

1. **CHARACTERS** — if the plan says "ONLY THE HERO", the imagePrompt must NOT reference the companion in any form. No "in the background", no "watching from afar". The companion is GONE for that page. If the plan says "BOTH", they must INTERACT, not just stand near each other.

2. **CAMERA** — the plan dictates the framing exactly. CLOSE-UP means face-and-shoulders only, NOT full body. WIDE means character is small in a large environment. LOW ANGLE means camera at ground level looking up.

3. **MOTION** — the plan dictates whether the character is moving. IN MOTION means running/leaping/reaching/climbing — NEVER standing. REACTING means mid-gasp, recoiling, lighting up — NEVER neutral.

**FAILURE EXAMPLES** (do NOT do these):
- Plan says "hero_only" but you write "the boy and his father stand in the forest" → FAILURE
- Plan says "close_up_emotion" but you write "wide shot of the boy walking down a path" → FAILURE
- Plan says "in_motion" but you write "the boy stands looking at the river" → FAILURE
- Plan says "low_angle_hero" but you write "high angle view from above" → FAILURE

═══════════════════════════════════════════════════════════

## Story structure
- First ~25%: Establish world and hero, opening tone from narrativeStyle.openingTone.
- Middle ~50%: Rising action, obstacle, narrativeStyle.twist.
- Last page before final: Climax using narrativeStyle.climaxStyle.
- Final page: Resolution. ALWAYS ends with the hero peacefully settling to sleep. Mood: narrativeStyle.endingMood.

## Writing quality rules
1. FOLLOW writingGuidelines PRECISELY — sentence count, word count, vocabulary level. Non-negotiable.
2. Use heroName naturally (not every sentence). Use pronouns too.
3. If setup.companion is given, refer to them by companionName throughout the story TEXT. Give them at least 2 meaningful moments. NOTE: the story TEXT can mention the companion even on pages where the IMAGE shows only the hero (e.g. "Kevin remembered what apa had said earlier..." while the image shows Kevin alone).
4. NEVER describe any character's physical appearance (hair, eyes, skin, clothing) — handled by image generator via reference images.
5. If teachingMoment is given, weave it into the emotional arc — never state it as a lesson.
6. Make the hero ACTIVE — they make choices.
7. Every page ends on a micro-hook (except the final).
8. Title fresh and specific to THIS story.

## coverImagePrompt rules (ONE image, character reference sheet)
- Show ALL named characters in neutral poses for visual reference.
- Plain studio backdrop. NO scenery. Empty hands. No interaction.
- Specify EACH character's exact outfit (this is the ONLY place outfits are defined; image generator reuses them).
- Relative sizes critical:
  • 3–4 year old child: waist-height on adult
  • 5–6 year old child: chest-height on adult
  • 7–8 year old child: shoulder-height on adult
  • Animals at realistic sizes
- 60–100 words English. Match artStyle.

## coverCaption rules
- 1–2 sentences in story language, engaging for a child, no "Once upon a time" clichés.

═══════════════════════════════════════════════════════════
imagePrompt rules — CRITICAL FOR VISUAL VARIETY
═══════════════════════════════════════════════════════════

For each page, follow this mental order:

**STEP 1**: Read that page's compositionPlan instructions. They are non-negotiable.

**STEP 2**: Translate the plan into the prompt:
  • Open with art style and shot type: e.g. "Warm [art style] illustration. CLOSE-UP shot of..."
  • State who is present using VISUAL ROLES, never names:
    - Hero: "the boy/girl/child from the reference image" (based on heroPronouns: he→boy, she→girl, they→child)
    - Companion: "the [man/woman/elderly woman/dog/cat/etc.] from the character sheet"
    - NEVER use proper names — the image AI does not know who "Kevin" or "apa" is.
  • Describe pose for every visible character with anatomy:
    - BAD: "the boy stands looking forward"
    - GOOD: "the boy crouches on his right knee, left hand pressed against the moss-covered ground, head tilted up toward the canopy, mouth slightly open"
  • Describe facial expression with muscles, not just emotion:
    - BAD: "looking surprised"
    - GOOD: "eyebrows arched high, mouth slightly open, eyes fixed wide on something just out of frame"
  • Describe environment richly: location, lighting source/quality, atmosphere, foreground framing.

**STEP 3** — Self-check before finishing:
  • Does this prompt describe a STILL POSE on a page where the plan said "IN MOTION"? Rewrite.
  • Does this prompt include the companion on a page where the plan said "hero_only"? Delete the companion.
  • Does this prompt say just "stands" or "looks at"? Rewrite with anatomy.
  • Does this prompt look IDENTICAL in composition to an adjacent page? Vary it.

═══════════════════════════════════════════════════════════

## Anti-pattern list — these fail the variety test
❌ "The boy and his father stand in the forest" (no shot, no pose, both characters static)
❌ "Kevin and apa walk down the path together" (uses names, generic pose)
❌ "Looking happy / sad / scared" (no facial detail)
❌ Same composition on consecutive pages (hero left + companion right + standing)
❌ Companion present on every page (violates planned variety)

## Forbidden in imagePrompts
- Character names (use visual roles)
- Text, speech bubbles, writing in the scene
- Clothing or facial feature descriptions (handled by reference images)

## Story opening variety
Prohibited openings:
- "One [day/night/morning], [name] was…"
- "[Name] woke up and…"
- "It was a [adjective] day when…"
Instead: drop reader into mid-action, sensory detail, or a thought.

═══════════════════════════════════════════════════════════
COSY HOME THEME — special tone (ONLY when narrativeStyle.type === "quiet_moment")
═══════════════════════════════════════════════════════════

If the narrativeStyle is "quiet_moment", you are NOT writing an adventure. You are writing a tiny slice of bedtime warmth. Critical rules:

1. **No grand conflict.** No villain, no danger, no race against time. The whole story is one soft moment lingering.

2. **No twist.** The "shift" in narrativeStyle.twist is just a small change in attention — the hero notices the way the cat is sleeping in the sunbeam, or that grandma always hums while she stirs the soup.

3. **No climax in the action sense.** The peak moment is something like: a held hand, a shared smile, watching dust dance in a sunbeam, hearing rain on the window while warm under a blanket.

4. **Tiny stakes.** The "goal" (e.g. "find a lost toy", "help a neighbour") is real but small and never urgent. If the toy is never found, that's fine — the story is about the looking, not the finding.

5. **Sensory richness over plot.** Spend words on textures, sounds, smells, soft light. The smell of toast. The creak of a wooden floor. The warmth of a hand. These ARE the story.

6. **Pacing is slow.** Each page is one small beat — don't try to advance the plot. Linger. Children at bedtime want to slow down, not hurry.

7. **Hero is mostly still.** The hero observes, listens, sits, watches. Avoid running, climbing, leaping. Composition plan reflects this — most pages will be "static" or gentle "reacting".

8. **No "moral" or "lesson" framing.** If teachingMoment is given (e.g. "kindness"), let it emerge through what the hero notices and feels — never name it, never wrap up with a takeaway.

9. **Language is soft and warm.** Use words like: cosy, soft, warm, quiet, drowsy, gentle, slow, small, kind. Avoid: brave, fierce, dared, burst, raced, suddenly, finally.

10. **Final page is especially tender.** The hero is tucked in or settling. The world is good. Sleep is welcoming.

═══════════════════════════════════════════════════════════

NOTE: If narrativeStyle.type === "quiet_moment" (cosy home theme), the outfits in coverImagePrompt should be ordinary everyday clothing (cosy sweater, jeans, soft slippers, a favourite t-shirt) — NOT costumes. The hero is not playing a role; they are themselves at home.

When narrativeStyle.type === "quiet_moment" (imagePrompts):
- Settings are ordinary, recognisable spaces (a kitchen with a kettle on the hob, a bedroom with morning light, a meadow with one tree). NOT fantasy environments.
- Lighting is warm and natural: golden afternoon sun through a window, lamplight in the evening, soft grey light during rain.
- Avoid dramatic angles. Prefer eye-level shots, slight high angles, warm medium framings.
- The mood word in your prompt should be one of: cosy, peaceful, warm, gentle, dreamy, intimate.
- No special effects, no glow, no magic sparkles. Real-world warmth only.`;
  }

  private parseAndValidate(content: string, expectedPageCount = 8): GptStoryOutput {
    let parsed: GptStoryOutput;
    try {
      parsed = JSON.parse(content) as GptStoryOutput;
    } catch {
      throw new Error('gpt_invalid_json');
    }

    if (!parsed.title || typeof parsed.title !== 'string') {
      throw new Error('gpt_missing_title');
    }
    if (!parsed.coverImagePrompt || typeof parsed.coverImagePrompt !== 'string') {
      throw new Error('gpt_missing_cover_image_prompt');
    }
    if (!parsed.coverCaption || typeof parsed.coverCaption !== 'string') {
      throw new Error('gpt_missing_cover_caption');
    }
    if (!Array.isArray(parsed.pages) || parsed.pages.length !== expectedPageCount) {
      throw new Error(`gpt_wrong_page_count: expected ${expectedPageCount}, got ${parsed.pages?.length}`);
    }
    for (const page of parsed.pages) {
      if (!page.pageNumber || !page.text || !page.imagePrompt) {
        throw new Error('gpt_invalid_page');
      }
    }

    return parsed;
  }

  /**
   * Soft validation — logs warnings if the GPT ignored the composition plan.
   * Hard rejection would cost a regeneration cycle (~$0.02 + ~5s), so we log and
   * track via metrics instead. If violation rate is consistently high (>20%),
   * tighten the prompt or switch to hard rejection + retry.
   */
  private validateCompositionAdherence(
    output: GptStoryOutput,
    plan: PageComposition[],
    hasCompanion: boolean,
  ): void {
    if (!hasCompanion) return;

    let companionAppearances = 0;
    const violations: Array<{ page: number; issue: string }> = [];

    for (let i = 0; i < output.pages.length; i++) {
      const page = output.pages[i];
      const planEntry = plan[i];
      if (!planEntry) continue;

      const promptLower = page.imagePrompt.toLowerCase();
      // Detect companion mentions via typical phrases.
      const companionMentioned =
        /\b(?:from the character sheet|the man|the woman|the elderly|the dog|the cat|the rabbit)\b/.test(promptLower) ||
        /\b(?:both characters|together they|side by side|next to (?:him|her|them))\b/.test(promptLower);

      if (companionMentioned) companionAppearances++;

      if (planEntry.characters === 'hero_only' && companionMentioned) {
        violations.push({ page: page.pageNumber, issue: 'companion appears in hero_only page' });
      }
    }

    const totalPages = output.pages.length;
    const companionRatio = companionAppearances / totalPages;

    if (companionRatio > 0.7) {
      console.warn(
        `[GptStoryWriter] Companion appears on ${(companionRatio * 100).toFixed(0)}% of pages — variety rule may not be working.`,
        { totalPages, companionAppearances, violations },
      );
    }

    if (violations.length > 0) {
      console.warn(`[GptStoryWriter] ${violations.length} composition plan violations`, violations);
    }
  }
}