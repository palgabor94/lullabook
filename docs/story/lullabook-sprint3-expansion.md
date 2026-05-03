# Lullabook — Adventure Setup Expansion (Sprint 3)

> Scope: 12+12 options per theme + new `cosy_home` theme + `quiet_moment` flavour
> Effort: ~3-4 hours total (mostly i18n string work)
> Status: ready to apply

---

## What's in this delivery

1. **`adventure_setup_screen.dart`** — the full updated screen
2. **`app_en_additions.arb`** — English string keys to merge into `app_en.arb`
3. **`app_hu_additions.arb`** — Hungarian string keys to merge into `app_hu.arb`
4. **`GptStoryWriter_cosy_patch.ts`** — TypeScript patches for the story writer

---

## Summary of changes

### Adventure setup screen
- **17 themes total** (was 16) — added `cosy_home` 🏠 as the FIRST theme
- **12 locations + 12 goals per theme** (was 8+8) — that's 17 × 12 × 2 = 408 options total
- Each new option is themed to fit the universe (e.g. pirate gets `kraken_waters`, `ghost_ship`, `mermaid_lagoon`; cosy_home gets `bedroom`, `library`, `farmers_market`)
- New `themeId` field passed through to backend so the story writer can detect cosy_home

### Cosy home theme (new)
- **Locations**: bedroom, kitchen, garden, attic, living room, park, library, playground, market, forest clearing, pond, meadow (mix of indoor / outdoor / nature as requested)
- **Goals**: lost toy, new friend, help neighbour, tidy room, bake together, feed birds, brave the dark, share a toy, plant a seed, rainy afternoon, visit grandparents, find a special pebble
- **Tone**: ordinary moments, no hero role, no quest, no climax — just gentle slices of bedtime warmth

### GPT story writer
- New `quiet_moment` narrative flavour for cosy_home only
- New `pickFlavourForTheme()` — uses cosy-only flavours when `themeId === 'cosy_home'`
- `softenGuidelinesForCosy()` — relaxes the writing rules:
  - emotional depth becomes "gentle, quiet emotions, no conflict"
  - plot complexity becomes "no plot, just one moment unfolding"
  - repetition becomes welcome (refrains anchor cosy mood)
- `planCompositions()` accepts new `isCosy` param — biases motion to mostly static (70%) and gentle reacting (30%), never `in_motion`
- New system prompt section for cosy stories with 10 rules
- Cover and imagePrompt rules adjusted: ordinary clothes (no costumes), real-world warmth, no fantasy effects

---

## How to apply

### Step 1: Replace the screen (5 min)
```bash
cp /mnt/user-data/outputs/adventure_setup_screen.dart \
   flutter_app/lib/features/adventure_setup/presentation/adventure_setup_screen.dart
```

### Step 2: Merge ARB additions (15 min)

Open `flutter_app/lib/l10n/app_en.arb` and add all the keys from `app_en_additions.arb` (skip the `_section_*` and `_comment_` keys — those are just visual dividers, not real keys).

Same for `flutter_app/lib/l10n/app_hu.arb` with `app_hu_additions.arb`.

For other languages (the 8 you have besides en/hu) you'll need to translate. Quickest path: use Claude or DeepL to translate the en file → paste into each locale.

### Step 3: Generate localizations
```bash
cd flutter_app
flutter gen-l10n
```

### Step 4: Apply GPT writer patches (30 min)

Open `GptStoryWriter_cosy_patch.ts` — it contains 8 targeted changes to apply to `functions/src/generation/llm/GptStoryWriter.ts`:

1. Add `quiet_moment` to `NARRATIVE_FLAVOURS`
2. Add `pickFlavourForTheme()` helper
3. Replace `pickFlavour()` call with `pickFlavourForTheme(input.setup.themeId, NARRATIVE_FLAVOURS)`
4. Add `softenGuidelinesForCosy()` and use it in `write()`
5. Modify `planCompositions()` motion bias when `isCosy === true`
6. Append `COSY_PROMPT_SECTION` to system prompt
7. Append `COSY_COVER_NOTE` to coverImagePrompt rules
8. Append `COSY_IMAGE_NOTE` to imagePrompt rules

### Step 5: Backend wiring

The Cloud Function that calls `GptStoryWriter.write()` needs to pass through `themeId` from the setup object. Find your story-generation entry point (likely `functions/src/orchestration/generateStoryHandler.ts` or similar) and ensure:

```typescript
await gptWriter.write({
  hero: heroDoc,
  setup: {
    theme: setup.theme,
    themeId: setup.themeId,  // ← NEW: pass through
    companion: setup.companion,
    companionName: setup.companionName,
    location: setup.location,
    goal: setup.goal,
    teachingMoment: setup.teachingMoment,
  },
  language,
  pageCount,
});
```

Also update the `AdventureSetup` TypeScript type in `domain/entities/Story.ts` to include the optional `themeId` field.

### Step 6: Delete cached system prompts in Firestore

```bash
# Firestore console or CLI:
firebase firestore:delete systemPrompts --recursive --force
```

This forces `loadSystemPrompt()` to fall back to `buildSystemPrompt()` which contains the new cosy rules.

### Step 7: Test
```bash
cd functions
npm run build
firebase deploy --only functions:generateStory
```

Then in the app, generate:
1. **Cosy home story** — pick `Cosy Tale` theme, `Kitchen` location, `Bake Together` goal, no companion
   - Expect: soft prose, ordinary kitchen scenes, mostly static compositions, warm lighting
2. **Adventure story** — pick `Pirate` theme, `Kraken Waters` location, `Tame the Kraken` goal, with companion
   - Expect: dynamic motion, varied compositions, classic narrative arc

---

## Risks / things to watch

1. **i18n string explosion**: you went from ~250 strings to ~430+. For 10 languages that's ~4,300 strings to manage. Consider a translation management tool (Lokalise, Crowdin, Phrase) before scaling further. For V1 launch, en + hu can be hand-curated; the other 8 can use machine translation initially.

2. **First-time users see cosy_home first**: that's intentional — cosy is the safest "no commitment" entry point and works for the youngest kids (3-4). But monitor analytics: if 80% of users never explore beyond cosy_home, the discovery of other themes is broken and you'll need a "Try something different tonight?" suggestion on the home screen.

3. **GPT-4o cosy adherence**: the model is trained on adventure stories more than slow slice-of-life. The system prompt is explicit but watch the first 5-10 cosy generations carefully. If GPT inserts conflict where there shouldn't be any, tighten the prompt or add a hard validation.

4. **Image generation cosy vs adventure**: the RunningHub character anchor should still work, but if cosy stories suddenly produce dramatic dramatic-lit scenes, check that the imagePrompt rules section is being respected. The `lighting is warm and natural` instruction is the key constraint.

5. **Don't forget the analytics event**: track `theme_id` selected, not just theme label, so you can see how cosy_home performs vs the adventures over time.

---

## Done criteria

- [ ] App builds with new screen, no missing localization keys
- [ ] Cosy Tale theme appears first in theme picker
- [ ] All 17 themes have 12 locations + 12 goals
- [ ] Selecting cosy_home + a goal → generates a soft story with no big climax
- [ ] Selecting astronaut + a goal → generates an adventure with dynamic compositions
- [ ] No regression on existing themes
- [ ] Hungarian + English both work; other languages have at least the new theme name translated (rest can ship in next localization pass)

---

## What's left for V1.1

- **Translate new strings to remaining 8 languages** (Italian, French, Spanish, German, Polish, Russian, Belarusian, Ukrainian, Indonesian)
- **Custom watercolor SVG icons** for the cosy_home locations (the 🏠 emoji works but a custom illustration would set this theme apart visually)
- **"Sleep tight" sub-mode** — if cosy_home performs well, consider a `bedtime_lullaby` theme that's even calmer (5-page stories, drowsier prose, narration uses softer voice)
