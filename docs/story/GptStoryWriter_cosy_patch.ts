// ─────────────────────────────────────────────────────────────────────────────
// GptStoryWriter — patch additions for cosy_home theme
//
// This file shows ONLY the changes needed in the existing GptStoryWriter.ts.
// Apply these diffs to the version that includes mechanical composition planning.
// ─────────────────────────────────────────────────────────────────────────────


// ─── 1. Add new flavour to NARRATIVE_FLAVOURS array ──────────────────────────
//
// Add this entry to the NARRATIVE_FLAVOURS const array:

const NEW_FLAVOUR = {
  id: 'quiet_moment',
  description: 'A gentle slice-of-life story: no quest, no twist, no big climax. The hero notices something small in their everyday world, sits with a feeling, and carries a tiny realization to bed. The whole story is one soft breath.',
  openingTone: 'a small, ordinary moment — the world pausing for a beat',
  twist: 'NOT a plot twist — a quiet shift in the hero\'s feelings or attention. They notice something they missed before.',
  climaxStyle: 'the softest possible peak — a held gaze, a small kindness, a window into something tender. NO action, NO conflict resolution. Just a moment of inner warmth.',
  endingMood: 'safe, drowsy, gently happy — like being tucked in by someone who loves you',
};


// ─── 2. New helper to pick flavour based on theme ────────────────────────────

const COSY_FLAVOUR_IDS = ['quiet_moment', 'unlikely_friendship', 'discovery_wonder', 'learning_to_share', 'big_mistake_fixed'];

function pickFlavourForTheme(themeId: string | undefined, allFlavours: typeof NARRATIVE_FLAVOURS): typeof NARRATIVE_FLAVOURS[0] {
  if (themeId === 'cosy_home') {
    // Cosy home stories use only soft-mood flavours
    const eligible = allFlavours.filter((f) => COSY_FLAVOUR_IDS.includes(f.id));
    return eligible[Math.floor(Math.random() * eligible.length)];
  }
  // For other themes, exclude quiet_moment (it's reserved for cosy_home)
  const eligible = allFlavours.filter((f) => f.id !== 'quiet_moment');
  return eligible[Math.floor(Math.random() * eligible.length)];
}


// ─── 3. Replace the existing pickFlavour() call in write() ───────────────────
//
// In GptStoryWriter.write(), replace:
//
//   const flavour = pickFlavour();
//
// With:
//
//   const flavour = pickFlavourForTheme(input.setup.themeId, NARRATIVE_FLAVOURS);


// ─── 4. Adjust writingGuidelines for cosy_home ───────────────────────────────
//
// In write(), AFTER computing `guidelines`, add this softening pass for cosy_home:

function softenGuidelinesForCosy(guidelines: AgeGuidelines): AgeGuidelines {
  return {
    ...guidelines,
    emotionalDepth: 'gentle, quiet emotions: cosiness, mild curiosity, soft affection, the warmth of being known. NO mild tension or conflict. NO doubt-then-courage arcs. Just small good feelings.',
    plotComplexity: 'NO plot in the traditional sense. ONE small everyday moment unfolding slowly: noticing something, paying attention, feeling something small. The "story" is the texture of the moment, not a problem-solution arc.',
    repetitionStyle: 'gentle repetition is welcome — soft refrains like "and the kettle whistled" or "and the rain kept falling" anchor the cosy mood.',
  };
}

// In write():
//
//   const isCosy = input.setup.themeId === 'cosy_home';
//   const guidelines = isCosy
//     ? softenGuidelinesForCosy(ageGuidelinesFor(input.hero.age))
//     : ageGuidelinesFor(input.hero.age);


// ─── 5. Adjust composition plan motion bias for cosy_home ────────────────────
//
// In planCompositions(), change the motion bias on middle pages for cosy stories:
//
// Replace:
//   const motionRoll = Math.random();
//   motion = motionRoll < 0.5 ? 'in_motion' : motionRoll < 0.85 ? 'reacting' : 'static';
//
// With (when isCosy is true):
//   const motionRoll = Math.random();
//   motion = motionRoll < 0.7 ? 'static' : 'reacting';
//   // Cosy stories: 70% still moments, 30% gentle reaction. Never "in_motion" — no running.

// To pass isCosy into planCompositions, change its signature:
//
//   function planCompositions(
//     pageCount: number,
//     hasCompanion: boolean,
//     isCosy: boolean = false,
//   ): PageComposition[] { ... }
//
// And call it from write() like:
//
//   const isCosy = input.setup.themeId === 'cosy_home';
//   const compositionPlan = planCompositions(pageCount, hasCompanion, isCosy);


// ─── 6. System prompt addition for cosy_home tone ────────────────────────────
//
// In buildSystemPrompt(), add this section AFTER the "Story structure" section:

const COSY_PROMPT_SECTION = `

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
`;


// ─── 7. Cover image prompt note for cosy_home ────────────────────────────────
//
// In buildSystemPrompt(), modify the coverImagePrompt rules section. Add this
// note at the bottom of that section:

const COSY_COVER_NOTE = `

NOTE: If narrativeStyle.type === "quiet_moment" (cosy home theme), the outfits
should be ordinary everyday clothing (cosy sweater, jeans, soft slippers, a
favourite t-shirt) — NOT costumes. The hero is not playing a role; they are
themselves at home.
`;


// ─── 8. imagePrompt rules — soften for cosy_home ─────────────────────────────
//
// In the imagePrompt rules section of buildSystemPrompt(), append this guidance:

const COSY_IMAGE_NOTE = `

When narrativeStyle.type === "quiet_moment":
- Settings are ordinary, recognisable spaces (a kitchen with a kettle on the hob, a bedroom with morning light, a meadow with one tree). NOT fantasy environments.
- Lighting is warm and natural: golden afternoon sun through a window, lamplight in the evening, soft grey light during rain.
- Avoid dramatic angles. Prefer eye-level shots, slight high angles, warm medium framings.
- The mood word in your prompt should be one of: cosy, peaceful, warm, gentle, dreamy, intimate.
- No special effects, no glow, no magic sparkles. Real-world warmth only.
`;


// ─── Summary of the patch ────────────────────────────────────────────────────
//
// Files touched:
//   • functions/src/generation/llm/GptStoryWriter.ts — apply the 8 changes above
//
// Required input change:
//   • The Flutter app already sends `themeId` in the setup object (added in
//     adventure_setup_screen.dart). The Cloud Function endpoint should pass
//     `themeId` through to GptStoryWriter.write({ ..., setup: { themeId, ... } }).
//
// Test plan:
//   1. Generate a story with theme=cosy_home, location=home_kitchen, goal=bake_together
//      → expect: soft prose, no twist, mostly static composition, warm imagePrompts
//   2. Generate a story with theme=astronaut, location=moon, goal=fix_rocket
//      → expect: dynamic composition (in_motion bias), classic narrative arc,
//        no quiet_moment flavour selected
//   3. Verify console logs:
//      - cosy_home: companion ratio low, motion mostly static
//      - astronaut: companion ratio ~45%, motion mostly in_motion
