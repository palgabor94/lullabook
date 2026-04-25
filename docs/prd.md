# Lullabook — Product Requirements Document

> **Product name**: Lullabook (confirmed)
> **Domain**: lullabook.app (primary) + getlullabook.com (redirect fallback)
> **App Store subtitle**: "AI Bedtime Stories for Kids"
> **Version**: 1.6 — Draft (architecture clarified: Hero Reveal = preview = anchor = page 1)
> **Last updated**: April 2026
> **Author**: Gábor
> **Status**: Pre-build specification
>
> **Changelog v1.0 → v1.1**:
> - Voice cloning (F-5) deferred from MVP to V1.1 release
> - Print-on-demand (F-12) confirmed as V2 (unchanged)
> - Art-style strategy: reference-image based, no bespoke illustrator commissioned
> - Hero anchor strategy locked: single-image approach
> - Story writer model locked: GPT-4o
> - New MVP feature added: F-0 Pre-Signup Preview
> - Unit economics re-baselined at $0.012/image generation cost
> - MVP timeline compressed from ~10 weeks to ~7 weeks
>
> **Changelog v1.1 → v1.2**:
> - Product name changed: Sleepyhero → **Chapterly** (initial rename; revised again in v1.5)
> - Domain placeholder secured at time
> - App Store subtitle locked: "AI Bedtime Stories for Kids"
>
> **Changelog v1.2 → v1.3**:
> - TTS provider for MVP locked: **ElevenLabs Multilingual v2**
> - Per-story cost updated from $0.16 to ~$0.23
> - Narration caching strategy added for scale-time cost reduction
>
> **Changelog v1.3 → v1.4**:
> - Pricing model restructured from Monthly-first to **Weekly + Yearly only**
> - **Weekly $7.99/week** with 3-day free trial — 3 stories/day fair-use cap
> - **Yearly $99.99/year** — 1 story/day cap, up to 2 heroes included
> - **Family tier removed** (was mathematically unsustainable due to per-story cost; 2-hero Yearly covers most family use cases; 3+ child families buy multiple Yearly subs)
> - Monthly tier eliminated to simplify paywall decision (Weekly + Yearly only, matching Remini/Photoleap/Facetune industry pattern)
> - Worst-case margin mathematically guaranteed positive on both tiers
>
> **Changelog v1.4 → v1.5**:
> - Product name changed: Chapterly → **Lullabook** (Chapterly felt too SaaS/B2B; Lullabook better conveys the bedtime storybook category to parents at first glance)
> - Domain secured: **lullabook.app** primary, **getlullabook.com** fallback (the .com is taken by an unrelated site)
> - All references in document updated to reflect Lullabook branding
>
> **Changelog v1.5 → v1.6**:
> - **Hero Reveal architecture consolidated**: the image generated in F-0 (pre-signup preview) is now explicitly the same asset as the Hero Anchor (F-1) and the page 1 illustration of the first story (F-3). One image, three jobs.
> - F-0 reframed: scene-grounded Hero Reveal (e.g., "Sofia on the moon") instead of neutral portrait — better preview hook + better story page 1.
> - F-1 simplified: no separate anchor generation step. Hero Reveal is automatically promoted to Hero Card on signup.
> - F-3 first-story pipeline: only 7 new images generated (page 1 reuses Hero Reveal). Subsequent stories generate all 8 pages new.
> - F-1 adds **defining traits text field** (e.g., "brown wavy hair, blue glasses, freckles") as text reinforcement included in every scene generation prompt alongside the visual reference.
> - F-1 adds **Hero Card validation step**: parent confirms "Does this look like [child's name]?" before locking the anchor; up to 2 free regenerations during onboarding.

---

## 0. How to use this document

This PRD is the single source of truth for Lullabook v1. It is meant to be lived-in: update it when scope changes, and treat unresolved questions (marked **[OPEN]**) as deliverables before implementation begins. Sections 1–5 are the "why"; sections 6–8 are the "what"; sections 9–16 are the "how".

---

## 1. Executive Summary

Lullabook is a mobile-first personalized bedtime storybook app for families with children aged 3–8. Parents upload a single photo of their child, and the app turns that child into the consistent protagonist of an endless library of AI-generated illustrated stories — read aloud in the parent's own cloned voice.

The app is built around **three structural differentiators** that no existing competitor combines:

1. **Kid-participation setup** — a playful, gamified flow where the child helps choose tonight's adventure, making the setup itself part of the bedtime ritual.
2. **Recurring hero universe** — the same illustrated hero (their child) continues across unlimited stories, building emotional continuity and retention that one-shot competitors cannot match.
3. **Parent voice cloning** — after a 60-second voice sample, every story is narrated in the parent's own voice, making the app a proxy for parental presence.

The target market is proven: the US personalized children's book market alone is valued at $661M and projected to reach $1.1B by 2032. Existing mobile apps in this space (StoryMe, MyStorybook, Face in a Book) are stale, English-only, and structurally fail at retention. Lullabook is positioned to replace occasional-use competitors with a nightly-ritual product.

**North Star Metric**: weekly active story generations per family (WASGF). Target: 3+ by week 4.

---

## 2. Product Vision & Positioning

### 2.1 Vision

> *"The app that turns bedtime into the moment your child looks forward to all day — where they are the hero, you are the voice, and every night is a new adventure."*

### 2.2 Positioning statement

For **parents of young children** who struggle to make bedtime feel special and who want more than another generic kids' app, Lullabook is a **personalized AI bedtime storybook platform** that, unlike Google Gemini Storybook, StoryMe, or generic AI storybook tools, creates a **recurring ritual** where both parent and child actively participate in creating nightly adventures starring their child, narrated in the parent's own voice.

### 2.3 Anti-positioning (what Lullabook is NOT)

- Not a one-shot gift generator (Wonderbly, StoryMe).
- Not a content-library kids' reading app (Epic!, Kidly).
- Not a general AI storybook generator for any use case (Gemini Storybook, Lullaby.ink).
- Not a creative tool for children to build their own stories (My Story Kids' Storybook Maker).
- Not a print-first service (Wonderbly, I See Me).

Lullabook is an **opinionated, ritualized, parent-and-child bedtime experience** that happens to use AI underneath.

### 2.4 Why now

- **Nano Banana (Gemini 2.5 Flash Image)** solves the photo-to-character consistency problem that made pre-2025 attempts in this space look like "floating heads on stock illustrations". Quality is now premium-book-level.
- **ElevenLabs and OpenAI Realtime Voice** make 60-second voice cloning commercially viable at sub-$0.10/minute generation cost.
- **Every existing competitor is inactive or stale** (last meaningful updates: StoryMe Jun 2024, MyStorybook Oct 2024, Face in a Book Oct 2023), indicating the market is under-served, not over-saturated.
- **Localization advantage**: no competitor has shipped beyond English. The EU market alone (Germany, France, Italy, Spain, Poland, Netherlands) is under-served.

---

## 3. Target Users & Personas

### 3.1 Primary persona — "The Ritualistic Parent"

- **Demographics**: 30–42 years old, one or two children aged 3–8, household income $60K+ or equivalent, urban or suburban, iOS or Android, English/German/French/Spanish/Hungarian/Polish/Italian native.
- **Behavior**: Reads to child at bedtime ~5 nights/week. Runs out of book variety and ideas. Already pays for $5–$15/month "nice-to-have" family apps (Calm, Moshi, Duolingo Kids, Epic!).
- **Emotional driver**: Guilt about not being "creative enough" or "present enough" at bedtime; joy when child is delighted; strong desire to see child represented in media.
- **Pain points**:
  - "We've read every book on the shelf three times."
  - "My kid doesn't want me to read boring adult audiobooks."
  - "I work late and miss bedtime, but I want to still be part of it."
  - "I want more ways to teach values through stories, not lectures."

### 3.2 Secondary persona — "The Distant Grandparent / Gift-Giver"

- **Demographics**: 55–75 years old, has 1–4 grandchildren, lives in different city or country.
- **Behavior**: Looks for meaningful gifts 3–6× per year (birthdays, holidays, milestones). Willing to spend $30–$100 per special occasion.
- **Use case**: One-time purchase of a printed keepsake book featuring the grandchild.
- **Acquisition**: Paid social, Mother's Day / Christmas gift guides, family-member referral.

### 3.3 Tertiary persona — "The Child-Advocate Co-Parent"

- **Demographics**: Parent who is separated, divorced, travels a lot, or works atypical shifts; the parent-voice feature is the killer feature.
- **Use case**: Cloning voice so their voice can read stories even when they're physically absent.

### 3.4 Excluded audiences

- Children under 3 (developmental fit weak; parents rarely pay for personalized content for this age).
- Teens (different content expectations; safety requirements more complex).
- Classroom / educator use (different pricing, admin, compliance — deferred to v2+).

---

## 4. Core Value Propositions

In priority order, the user experiences these as they use the app:

### 4.1 "My child is the hero, every single night"

The child appears as a consistent, premium-quality illustrated character across every story generated. This is not a floating photo — it is a stylized character that matches the book's art style, in different outfits, poses, and situations.

### 4.2 "We made this together"

The setup is a 60–90 second ritual where the parent hands the phone to the child to tap emoji cards: what they want to be, who comes with them, what the adventure is. The parent's role is presence, not input.

### 4.3 "Instant magic — see your child as the hero before even signing up"

Upload a photo + pick one adventure type → within 15 seconds, see a full-quality "Hero Reveal" illustration of your child as an astronaut, pirate, or explorer. No account, no card. This is the emotional hook that opens the funnel.

### 4.4 "Tonight's story continues tomorrow"

The same hero recurs across stories. Side characters can return. The library grows. Long-term users build a genuine personal canon of dozens of stories starring their child.

### 4.5 "I'll hear the story in my parent's voice" *(V1.1, post-MVP)*

After a one-time 60-second voice sample, every future story is narrated in the parent's voice. Works on airplane mode (once downloaded). Accommodates shared custody, travel, late work nights. **Not in MVP** — default high-quality TTS voices used at launch.

### 4.6 "I can hold this in my hands" *(V2)*

The best stories can be ordered as high-quality printed hardcover books (via Gelato print-on-demand integration), shipped globally in 7–12 days, at $29–49 per book.

---

## 5. Competitive Differentiation

### 5.1 Feature matrix vs existing market

| Capability | Lullabook MVP | Lullabook V1.1+ | Gemini Storybook | StoryMe | MyStorybook | Face in a Book | Lullaby (web) |
|---|---|---|---|---|---|---|---|
| Photo-to-character (AI) | ✅ Premium | ✅ Premium | ✅ Basic | ✅ Premium | ✅ Basic | ❌ | ✅ Premium |
| Unlimited AI-generated stories | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **Pre-signup preview with user's photo** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Parent voice cloning | ❌ | ✅ | ❌ | ❌ | ✅ (partial) | ❌ | ❌ |
| Kid-participation setup | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Page-flip book reader | ✅ | ✅ | ✅ | ✅ | ❌ (video) | ✅ | ✅ |
| Recurring hero across stories | ✅ | ✅ | ⚠️ | ❌ | ❌ | ⚠️ | ⚠️ |
| Mobile-native (iOS + Android) | ✅ | ✅ | ✅ | ❌ (iPhone only) | ✅ | ✅ | ❌ (web) |
| iPad-optimized reader | ✅ | ✅ | ⚠️ | ❌ | ✅ | ✅ | — |
| Multi-language (10+) | ✅ | ✅ | ✅ (45) | ❌ | ❌ | ❌ | ❌ |
| Offline reading | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Physical print option | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Print (V2) | — | — | ❌ | ❌ (broken promise) | ❌ | ❌ | ✅ |
| Active development in 2026 | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |

### 5.2 The structural gap

Three patterns stand out in competitor analysis:

1. **Template-based competitors** (StoryMe, Face in a Book) have good illustration quality but plateau at retention because content feels finite.
2. **Generation-based competitors** (Gemini Storybook, Lullaby) have infinite content but no ritual, no voice, no episode continuity — so they're occasional-use.
3. **Nobody bundles kid-participation + voice + recurring hero** — which is the ritual combination that turns "occasional use" into "nightly habit".

This third combination is Lullabook's moat.

---

## 6. Feature Specifications

### 6.1 Core Features (MVP)

#### F-0: Pre-Signup Preview ("Hero Reveal")

**Purpose**: The highest-leverage acquisition feature — let parents *see their child as a hero* before committing to an account. This is an industry-first on mobile: no existing iOS competitor allows a personalized preview without signup.

**Architectural note (important)**: The image generated in F-0 is **the same asset that serves three roles** in the user lifecycle:
1. **Pre-signup preview** — the emotional hook shown to the parent before signup
2. **Hero Anchor reference** — the master image used by Nano Banana to maintain character + style consistency for all subsequent story pages
3. **Page 1 of the user's first story** — the opening illustration of the first generated bedtime story

This consolidation means we generate **one image, not three**, saving generation cost and creating a coherent narrative thread from preview → signup → first story.

**Flow**:
1. App launch → skippable onboarding → "See yourself in the story" CTA visible immediately.
2. Parent grants one-time photo permission, uploads 1 photo of child.
3. Parent enters child's first name.
4. Parent taps one adventure tile from 6 options (astronaut, pirate, chef, wizard, explorer, princess).
5. App generates **one rich, scene-grounded "Hero Reveal" illustration** — the child transformed into the chosen hero, in a recognizable opening scene from the adventure (e.g., Sofia in astronaut suit standing on a moon crater). Plus 1–2 opening lines of the story.
6. Reveal screen displays the image with animated unveil + text: *"This is just page 1 of Sofia's adventure. Sign up free to see the full story."*
7. Sign-up paywall with email / Apple / Google auth.
8. Post-signup: the Hero Reveal image is **automatically promoted to be the user's Hero Card master reference** (F-1) and **page 1 of the first story** (F-3).

**Why scene-grounded vs neutral portrait**:
- A neutral portrait ("hero standing against plain background") is a weaker preview hook than a rich scene ("hero on the moon"). The latter sells the value proposition immediately.
- Nano Banana handles scene-grounded references well; the model can extract the character identity even when the reference includes background context.
- One asset, three jobs: lower cost, simpler architecture, more coherent UX.

**Abuse prevention**:
- Rate limit: 1 preview per device ID per 24 hours.
- Rate limit: 1 preview per IP per 24 hours.
- Photo validation: face-detection required; rejects non-child-face images (general adult face detector + age estimator).
- Optional: require phone number verification for >3 attempts from same device.

**Cost per preview**: ~$0.015 (1 image + minimal text generation).

**Target conversion**: 25–35% of preview-completers sign up (vs ~10% industry standard for "sign up first" flows).

**Acceptance criterion**: preview image is generated and displayed within 15 seconds from photo upload on average 4G connection.

#### F-1: Hero Profile

**Purpose**: Persistent character identity that recurs across all future stories.

**Inputs (collected during onboarding, post-signup)**:
- The child's photo (carried over from F-0 preview, or uploaded if user skipped F-0).
- Name (already collected in F-0; confirmed here).
- Age (drives story complexity).
- Pronouns.
- Defining traits text field — short description like "brown wavy hair, green eyes, freckles on nose, round blue glasses" (used as text reinforcement in all generation prompts).
- Preferred art style (4 options at launch: "Pixar-style 3D", "Watercolor", "Flat Modern", "Storybook Classic").

**Output**: A "Hero Card" stored in Firestore containing:
- **Hero Anchor image** — the Hero Reveal image generated in F-0, OR (if F-0 was skipped) generated fresh during onboarding using the same prompt structure.
- **Defining traits text** — short character description, included in every future image generation prompt as text reinforcement alongside the visual reference.
- Character metadata JSON: name, age, pronouns, art style.
- The original uploaded photo is used only for the Hero Reveal generation, then **deleted within 24 hours**.

**Anchor strategy (confirmed)**:
- **Single-image reference approach**: one rich, scene-grounded image is generated and reused as the visual reference for all subsequent story pages.
- **Text reinforcement**: defining traits text is included in every scene generation prompt, alongside the visual reference, to stabilize identity even when the reference is interpreted loosely by the model.
- **No separate anchor generation step**: the Hero Reveal IS the anchor. This saves cost and aligns the user-facing flow with the technical pipeline.

**Hero Card validation step (UX)**:
After Hero Reveal is generated, the parent sees the image and confirms with: "Does this look like [child's name]?" If yes → Hero Card is locked. If no → one-tap regenerate (max 2 free regenerations during onboarding to control cost). This step matters because it catches AI-introduced facial drift before the user invests in stories.

**Acceptance**: Generate 5 test scenes using the Hero Anchor — the hero should be recognizable as the same child in all 5.

#### F-2: Kid-Participation Setup ("Tonight's Adventure")

**Purpose**: Make the setup a shared parent-child ritual rather than an adult form-filling task.

**Flow**:
1. Parent opens app, taps "Tonight's Adventure".
2. App says (in parent's cloned voice if available): *"Here comes [child's name]. Hand me the phone."*
3. Child sees a playful card-swipe UI with large emoji/icon tiles:
   - **"Who do you want to be tonight?"** — 12 rotating options (astronaut, pirate, chef, ninja, firefighter, vet, princess, wizard, paleontologist, robot pilot, mermaid, inventor).
   - **"Who goes with you?"** — parent, sibling, pet, best friend, mystery creature, nobody.
   - **"Where does the adventure happen?"** — jungle, space, underwater, castle, grandma's house, moon, volcano, enchanted forest, our backyard.
   - **"What do you want to find?"** — treasure, a lost friend, a magical thing, a big surprise, a new home.
4. Optional fifth step: parent can add a "teaching moment" (courage, kindness, sharing, not giving up) from a menu — done silently out of child's view.
5. Tap "Start the Magic".

**Design constraints**:
- Max 60 seconds for full setup.
- Accessible to non-readers: every tile is both an icon and has voiced narration in-parent-voice-if-available.
- No text input from the child.
- No complex multi-select; everything is single-tap.

**Acceptance**: A 4-year-old can complete the setup unassisted from step 3 onward.

#### F-3: AI Story Generation

**Purpose**: Generate a complete, age-appropriate, 8-page illustrated bedtime story arc, in which **page 1 is the Hero Reveal image** (already generated in F-0) and **pages 2–8 are newly generated scenes** referencing that anchor.

**Total assets generated per story**: **8 images, but only 7 new generations** for the first story (page 1 reuses Hero Reveal). Subsequent stories generate all 8 pages new, all referencing the same Hero Anchor.

**Pipeline (first story — leverages F-0)**:

1. **Input synthesis** — app composes a structured JSON with: hero profile, setup choices (theme, companion, goal, teaching moment), language, target age, page 1 description (matches the Hero Reveal that was already generated).
2. **Story writer (GPT-4o, confirmed)** — receives the JSON + a system prompt that enforces:
   - Page 1 narrative matches the existing Hero Reveal image (the model is told what page 1 shows and writes 2-4 sentences accordingly).
   - Pages 2–8 follow the 8-page arc (see Appendix A): inciting incident → threshold → challenge → quality moment → climax → warmth → return.
   - Age-appropriate vocabulary and sentence length.
   - Embedded teaching moment without moralizing.
   - Cultural neutrality (will be localized).
   - Safety filters (no violence, fear-triggering content, scary imagery, death themes for age 3–6).
   - Output: 8 pages of 2–4 sentences each, plus a scene description (image prompt) per page in English.
3. **Image generation for pages 2–8** — 7 images generated in parallel via Nano Banana, each prompt containing:
   - The Hero Anchor (visual reference)
   - The defining traits text (text reinforcement)
   - The scene description from the story writer
   - Style consistency instructions
4. **Story assembly** — text + 8 illustrations (page 1 = Hero Reveal, pages 2–8 = new) → structured "Story object" in Firestore.
5. **Voice generation (ElevenLabs Multilingual v2)** — narration generated per page using the chosen default voice.
6. **Local cache** — full story assets (images + audio + text) downloaded for offline playback.

**Pipeline (subsequent stories — no F-0 reuse)**:
- Same as above except all 8 images are newly generated. Page 1 is freshly created using the Hero Anchor as reference.
- Cost per subsequent story: 8 × $0.012 + GPT + TTS + infra ≈ $0.23.
- First story is slightly cheaper (~$0.21) due to page 1 reuse.

**Target generation time**: < 90 seconds end-to-end.

**Target per-story cost**: ~$0.23 average (see §9.4 unit economics).

**Fallback logic**: mirrors the Portraiz dual-provider pattern. Primary = Nano Banana, secondary = Flux Kontext. If primary fails or exceeds time budget, automatic retry on secondary. Per-page granular retry (not full-story restart) on individual page failures.

#### F-4: Illustration Pipeline

**Purpose**: Deliver premium, consistent illustrations that match the chosen art style and preserve hero identity.

**Art styles at launch**:
- **Pixar-style 3D**: warm, rendered, suitable for ages 3–6.
- **Watercolor Classic**: traditional picture-book feel, suitable for ages 4–8.
- **Flat Modern**: clean vector-like, suitable for ages 5–8, more contemporary.
- **Storybook Classic**: detailed, ink-and-wash, suitable for ages 6–8, premium perception.

**Each art style is defined by**:
- A Nano Banana style prompt template.
- 2–3 **reference anchor images curated from public-domain and licensed stock illustration sources** (no bespoke illustrator commissioned for MVP).
- Color palette constraints.
- Consistency rules (e.g., "faces are always rendered with soft, defined features; no off-putting 'AI face'").

**Reference image sourcing plan**:
- Free/public-domain references: Smithsonian Open Access, Library of Congress, Rawpixel public domain collections.
- Licensed stock: Shutterstock / Adobe Stock illustration packs (one-time purchase, ~$50–$100 total for 10–15 usable references across 4 styles).
- Own-generated style boards: use Nano Banana itself in a bootstrap phase to generate 20+ variants per style, curate the best 3 per style as references.
- **Total art-style budget: $100–200** (vs the $2000 illustrator commission originally scoped).

**Quality assurance pipeline**:
- Automatic face-detection on generated pages. If hero's face is absent, auto-retry.
- "Weird hands" detection (fingers, toes) using dedicated CV model — auto-retry on failure.
- Parent can tap-to-regenerate any page up to 3 times per story.

#### F-5: Narration — Professional TTS (MVP) → Parent Voice Cloning (V1.1)

**MVP scope**: Professional-quality TTS narration using **ElevenLabs Multilingual v2** (locked decision), with 2 curated voices per language (one female "mesélő", one male "mesélő").

**V1.1 scope**: Parent voice cloning on top of the same ElevenLabs infrastructure.

**MVP rationale — why ElevenLabs over OpenAI TTS**:
- Storytelling-grade naturalness: native tempo variation, emotional warmth, and calming endings — essential for bedtime experience.
- Native multilingual quality: Hungarian, German, Polish, Italian, and Spanish pronunciation are materially better than OpenAI TTS (especially for inflected names and grammatical cases).
- Cost acceptable: ~$0.09/story at Creator tier pricing. MVP still achieves 73% gross margin on Monthly subscription.
- Future-compatible: same vendor for V1.1 voice cloning means no infrastructure migration.

**MVP implementation**:
- ElevenLabs Multilingual v2 model.
- 2 pre-selected voices per launch language (female + male mesélő), chosen during Phase 0 Exp 3 blind tests.
- Voice selection surfaced during onboarding and switchable in Settings.
- Pre-render narration at story creation (parallel to image generation) and cache locally for offline playback.
- Narration can be toggled off entirely by the parent if they prefer reading themselves.
- Voice settings: stability 0.6, similarity_boost 0.7 (to be finalized in Phase 0).

**Cost optimization strategies (phased)**:
- MVP: straightforward per-story generation via ElevenLabs Creator tier.
- Month 3+: narration caching for common opening/closing phrases (10–15% cost reduction).
- Month 6+: evaluate ElevenLabs Turbo v2.5 for same-quality-at-lower-cost A/B (potentially 40–50% cost reduction at similar quality).
- Scale-time: negotiate ElevenLabs enterprise/custom pricing once volume exceeds 100K stories/month.

**V1.1 implementation** (spec for future):
- 60-second parent voice sample capture with phonetically varied script.
- Upload to ElevenLabs Voice Design (Creator tier).
- Voice model ID stored encrypted in Firestore.
- Original recording deleted within 24 hours.
- Per-story batch narration generated and cached offline.
- Safety: only account owner can use their voice model; never shared across accounts; adult voice verification required.

**Launch voice shortlist (to be confirmed in Phase 0 Exp 3)**:

| Language | Female voice candidate | Male voice candidate |
|---|---|---|
| English | Rachel, Matilda | Antoni, Daniel |
| Hungarian | Bella (multilingual), native HU voice | Native HU voice |
| German | Anna, Nicole (multilingual) | Antoni, native DE voice |

Final voice selections locked by end of Phase 0 Exp 3.

#### F-6: Page-Flip Book Reader

**Purpose**: The "book experience" on screen — what the child actually sees at bedtime.

**Core UX**:
- Full-screen, landscape-first on iPad/tablet, portrait-OK on phone.
- Pages flip with either tap (left/right edge) or swipe.
- Realistic page-curl animation (optional; togglable for accessibility).
- Auto-play mode: narration plays, page turns automatically at appropriate pauses.
- Manual mode: parent controls pacing.
- **"Sleep Mode"**: screen dims progressively over the reading; only bottom 20% of screen stays dim-lit to finish narration; phone/tablet turns off gently after story ends.

**Audio controls**:
- Play/pause.
- Voice select (MVP: default TTS voices per language; V1.1: parent cloned voice).
- Speed (0.75x, 1.0x, 1.25x).
- Background music volume (optional ambient track, very soft).

**Accessibility**:
- Font size toggle (for parent following along).
- Dyslexia-friendly font option.
- Captions / subtitles toggle.
- VoiceOver / TalkBack compatibility.

#### F-7: Story Library

**Purpose**: The collection of all stories the family has generated, organized and browsable.

**Structure**:
- Sorted by: most recent, favorite, by hero (if multiple children), by theme.
- Each story card shows: cover illustration, title, date created, duration, favorite-heart.
- Search by keyword, character, location.
- "Re-read" count visible (drives the "most read" / "our favorite" surfacing).

#### F-8: Offline Mode

**Purpose**: Reliability for travel, poor WiFi, airplane mode, and bedrooms with no signal.

**Behavior**:
- On story completion, full payload (text + all images + all narration audio) is downloaded locally.
- Local storage budget: ~50MB per story (estimate: 8 images × 2MB + 8 audio × 400KB).
- User-configurable: "Keep last N stories offline" (default: last 10; max: unlimited on Pro).
- Clear UI indicator: "📡 Offline" badge when connection is lost.

### 6.2 Retention Features (V1.1, 4–8 weeks post-launch)

#### F-9: Story Universe — Recurring Side Characters

Stories can reintroduce side characters from previous stories. Example: "Last week, [child] met Spark the dragon — want Spark to join tonight's adventure?"

Implementation: at story generation time, the GPT layer has access to a summary of prior stories (last ~20) and can reference returning characters.

#### F-10: Nightly Streak & "Bedtime Badges"

Soft gamification visible to parent:
- Streaks for consecutive nights (non-nagging; missing a night does not break it harshly — 2-night grace period).
- Badges for milestone counts (10 stories, 50 stories, "read on 3 continents", etc.).
- **Intentionally not shown to child** — this is parent motivation, not child pressure.

#### F-11: Hero Evolution

Over time, the child's hero "levels up" across stories — learns skills, gains a trusted animal companion, discovers a home base. This gives long-term users a narrative arc to come back to.

Implementation: Hero Profile accumulates "narrative traits" that influence future story prompts.

### 6.3 Growth Features (V2, 3–6 months post-launch)

#### F-12: Print-on-Demand (Gelato integration)

- Tap "Print this as a hardcover book" inside any story.
- Choose size (7×7, 8×10), cover style (soft/hard).
- Preview with Gelato's API.
- Dedication page (optional).
- Checkout via Stripe or in-app purchase routed to Gelato fulfilment.
- Shipping 7–12 days global.
- Price: $29 soft, $39 hard, $49 premium hardcover with dust jacket.

#### F-13: Gift Mode

- Grandparent-friendly flow optimized for first-time non-owner usage.
- Gift recipient email → one-story gift card → recipient generates with their own child's photo.
- Gift-wrapped printed book option.

#### F-14: Multi-Hero Family Library

Premium Family plan supports up to 4 heroes (siblings) with separate libraries but a shared family account.

#### F-15: Seasonal & Licensed Theme Packs

- Christmas, Halloween, Easter, Hanukkah, Lunar New Year, local holidays.
- Partner-licensed theme packs (Disney, Peppa, etc. — long-term aspiration, not v1).

---

## 7. User Flows

### 7.1 First-time Onboarding

1. **App launch** → splash with warm illustration + soft music.
2. **Language auto-detection** from device locale, confirmable.
3. **Pre-signup preview hook** (F-0): "See your child as the hero — no signup needed".
4. Parent uploads photo + name + picks 1 adventure tile → 1 "hero reveal" illustration generated in ~15 seconds.
5. Preview screen with emotional unveil animation + teaser text.
6. **Sign-up paywall** (email / Apple / Google) to unlock full story.
7. **Hero profile completion** (F-1): confirm name, add age, select art style, optionally add second photo for better quality.
8. **"Tonight's Adventure" setup** (F-2) — full 4-step card flow.
9. **Story generating** — animated loading screen with progress ("Drawing Sofia's castle… writing Sofia's adventure… almost ready…"). Target: under 90 seconds.
10. **First full story reader opens automatically** (F-6) with default TTS narration.
11. **Post-story**: "Keep reading another night?" → if yes, paywall (see §9.3).

**Voice cloning skipped in MVP onboarding** — introduced as V1.1 upsell moment.

### 7.2 Returning Nightly Ritual Flow

1. **Home screen** → large CTA: "Tonight's Adventure" (primary), and "Continue reading [yesterday's story title]" (secondary).
2. Tap "Tonight's Adventure" → setup (F-2) → story generation → reader (F-6).

Target: from app open to reader ≤ 90 seconds.

### 7.3 Setup with Kid (detailed)

See F-2 for the four-step card flow. Design principles:
- Every tap gives tactile/audio feedback.
- Cards are 4-up grid with illustrated icons, minimum 80×80 pt tap targets.
- Parent can override any choice before committing.
- Total duration target: 60–90 seconds.

### 7.4 Story Generation Pipeline (sequence)

```
[Client: submit setup]
   ↓
[Cloud Function: validate + sanitize]
   ↓
[Story Writer: GPT-4o call with system prompt + context]
   ↓
[Image prompts: derived from story pages + hero anchor]
   ↓
[Parallel Nano Banana generation: 8 images]
   ↓ (on failure per-image)
[Fallback: Flux Kontext retry]
   ↓
[Default TTS narration (MVP) / ElevenLabs cloned voice (V1.1)]
   ↓
[Store story in Firestore + upload assets to Firebase Storage]
   ↓
[Push notification: "Your story is ready"]
   ↓
[Client: download + local cache for offline]
   ↓
[Reader opens]
```

### 7.5 Reading Experience

- Tap story card → full-screen cover → auto-play narration + page-turn.
- Gestures: swipe/tap to flip, pinch to zoom illustration, long-press to re-read current page.
- End-of-story: "The End" page with hero's name.
- Post-story actions: "Read again", "Print as book", "Save to favorites", "Share with family".

### 7.6 Print Ordering (v2)

1. Inside any story → "Print this book".
2. Choose format + cover style.
3. Real-time 3D preview (Gelato API).
4. Optional dedication ("To Sofia, love from Grandma — Christmas 2026").
5. Shipping address.
6. Checkout.
7. Tracking + delivery notifications.

---

## 8. Technical Architecture

### 8.1 Client (Flutter)

- **Framework**: Flutter 3.24+ with Dart 3+, targeting iOS 15+, Android 8+ (API 26+).
- **State**: Riverpod 2 (matches your existing Portraiz pattern).
- **Architecture**: MVVM with clear separation of view/viewmodel/repository.
- **Key packages**:
  - `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging`.
  - `purchasely_flutter` for paywall + subscription.
  - `just_audio` for narration playback.
  - `flutter_animate` for delightful micro-animations.
  - `hive` or `isar` for local story cache.
  - `flutter_localizations` + ARB files for i18n.
  - `sentry_flutter` for crash reporting.

### 8.2 Backend (Firebase)

- **Auth**: Email/password + Sign in with Apple + Google Sign-In.
- **Firestore** collections (see §8.6 data model).
- **Cloud Functions** (Node.js or TypeScript):
  - `generateStory` — orchestrates the full pipeline.
  - `cloneVoice` — proxies ElevenLabs API.
  - `regeneratePage` — retries a single page.
  - `purchaseyWebhook` — subscription state sync.
  - `gelatoWebhook` — print order fulfillment updates.
  - Scheduled: daily cleanup of temporary assets.
- **Firebase Storage** — all generated images + audio, organized by user + story ID, with CORS configured for client streaming.
- **Remote Config** — feature flags, A/B variants for paywall copy, art style rotation.

### 8.3 AI Services

- **Image generation**: Nano Banana (Gemini 2.5 Flash Image) via Google AI Studio API at $0.012/image, primary. Flux Kontext via RunningHub or Replicate, secondary fallback. Reuse dual-provider orchestration pattern from Portraiz.
- **Story writing**: **OpenAI GPT-4o** (confirmed). Via OpenAI direct API. ~$0.02/story at current pricing.
- **TTS narration (MVP & V1.1)**: **ElevenLabs Multilingual v2** (confirmed). Creator tier. ~$0.09/story for MVP default voices. ~$0.24/story for cloned voices in V1.1.
- **Content safety moderation**: OpenAI Moderation API + custom regex filters on final output.

### 8.4 Voice Pipeline Details

- Recording captured at 44.1kHz / 16-bit PCM on device.
- Uploaded to Cloud Functions, validated for duration (55–65s) and quality (signal-to-noise ratio).
- Sent to ElevenLabs Voice Design endpoint.
- Returned voice ID stored in user profile.
- Generation: per-story, batch 8 audio files (one per page), downloaded and cached.

### 8.5 Print Integration (v2)

- Gelato REST API.
- On order: Cloud Function generates a print-ready PDF (A5 / 7×7 / 8×10 templates) via HTML-to-PDF (Puppeteer on Cloud Functions).
- PDF uploaded to Gelato; order placed with customer shipping address.
- Webhook receives status updates; user gets push notifications + email.

### 8.6 Data Model (simplified)

```
/users/{uid}
  email, displayName, locale, timezone
  createdAt, lastActiveAt
  subscriptionTier: 'free' | 'monthly' | 'yearly' | 'family'
  voiceModelId: string?           // ElevenLabs voice ID
  voiceModelCreatedAt: timestamp?
  totalStoriesCreated: int
  nightlyStreak: int
  language: string                // content language

/users/{uid}/heroes/{heroId}
  name, age, pronouns
  photoUrls: string[]             // Firebase Storage paths
  heroAnchorImageUrl: string      // Nano Banana character reference
  artStyle: 'pixar' | 'watercolor' | 'flatmodern' | 'storybook'
  traits: {hair, skinTone, freckles, glasses, specialTraits[]}
  narrativeTraits: string[]       // accumulated from stories (F-11)
  createdAt

/users/{uid}/stories/{storyId}
  heroId: ref
  title: string
  theme, setting, companion, goal       // from setup
  teachingMoment: string?
  pages: [
    {
      pageNumber: int
      text: string
      imageUrl: string
      audioUrl: string?
      imagePrompt: string
    }
  ]
  duration: int                   // seconds
  createdAt, lastReadAt
  readCount: int
  favorite: bool
  language: string
  generationMetadata: {
    primaryProvider: 'nanobanana' | 'fluxkontext'
    costUsd: float
    durationMs: int
  }

/users/{uid}/recurringCharacters/{charId}
  name, description, appearancePrompt
  firstStoryId: ref
  appearedInStories: ref[]

/users/{uid}/prints/{printOrderId}      // v2
  storyId: ref
  format, cover, size
  shippingAddress
  gelatoOrderId
  status, trackingUrl

/systemPrompts/{language}
  storyWriter: string
  safetyInstructions: string
  artStyleModifiers: {...}
```

### 8.7 Security & Privacy

- All photo uploads encrypted at rest in Firebase Storage.
- Photos used only for hero anchor generation; **original photos deleted within 24 hours** of hero creation (only the stylized anchor is kept).
- Voice samples deleted within 24 hours of voice model creation (only ElevenLabs voice ID is retained).
- Firestore Security Rules: strict per-user isolation; no cross-user reads.
- **Child data never leaves the user's account.** No analytics, no third-party sharing.
- Account deletion: full data wipe within 7 days, including voice model at ElevenLabs (via API).
- COPPA & GDPR-K compliance (see §11).

---

## 9. Monetization

### 9.1 Business model

Freemium + subscription + à la carte print sales.

### 9.2 Pricing tiers

**MVP launch pricing (Weekly + Yearly only — no monthly, no family)**:

| Tier | Price | Free trial | Daily cap | Heroes | Notes |
|---|---|---|---|---|---|
| **Free** | $0 | — | 1 story total (lifetime) | 1 | After signup, for evaluation |
| **Weekly** | **$7.99/week** | 3-day free trial | 3 stories/day | 1 | Auto-renews weekly |
| **Yearly** | **$99.99/year** | — | 1 story/day | 2 | $1.92/week equivalent, 76% savings vs Weekly |

**Caps framed as bedtime ritual, not limits**:
- Weekly: "Up to 3 fresh stories per day — for when one isn't enough"
- Yearly: "A new story every night, all year long"

Caps shown to user only when hit. Default experience: unlimited feel.

**V1.1 pricing (when voice cloning ships)**:

| Tier | Price | Includes |
|---|---|---|
| **Weekly Basic** | $7.99/week | Default TTS narration |
| **Weekly Plus** | **$9.99/week** | + Parent voice cloning |
| **Yearly Basic** | $99.99/year | 2 heroes, default TTS |
| **Yearly Plus** | **$139.99/year** | 2 heroes + voice cloning |
| **Printed book** (V2) | $29–$49 | Hardcover, 7–12 day shipping via Gelato |

**Why no Monthly tier**:
- Consumer AI apps (Remini, Photoleap, Facetune) universally drop Monthly in favor of Weekly + Yearly only.
- Three-tier paywalls reduce conversion by 15–25% vs two-tier.
- Monthly cannibalizes Yearly; Weekly trial + Yearly upgrade is a stronger two-option flow.

**Why no Family tier**:
- At $0.23/story cost, supporting 4 heroes at 1-2 stories/day is mathematically unprofitable below ~$350/year — which exceeds consumer willingness-to-pay.
- 2-hero Yearly covers ~80% of family use cases (EU/US average household has 1.5–1.9 children).
- 3+ child households can purchase multiple Yearly subscriptions (1 per child) — legitimate market segmentation.
- Simpler paywall, cleaner messaging, predictable unit economics.

### 9.3 Paywall Strategy

**Paywall architecture (two-option flow)**:

- **Pre-signup preview paywall** (F-0) — the first conversion moment. User sees their child as a hero → sign-up wall before getting the full story. Target 25–35% preview → signup.
- **Post-first-free-story paywall** — user generates their first full story free, then sees the main paywall. Target 12–18% conversion.
- **Default paywall layout**: two large cards side by side.
  - Left: Weekly $7.99 with "Try free for 3 days" badge.
  - Right: Yearly $99.99 with "Best value — save 76%" badge and subtle visual emphasis.
- No third option. No "maybe later" option visible in the primary CTA row (close-X in corner only).
- Testimonial carousel below the two cards.
- Cancellation policy stated clearly: "Cancel anytime in Settings."

**Weekly psychology**:
- 3-day free trial as the primary hook — consumer AI benchmarks show 30–60% higher conversion with trial vs direct subscribe.
- Apple manages trial → paid transition natively via StoreKit.
- Trial reminder notification day 2 (Apple sends automatically).

**Yearly psychology**:
- Framed as "savings" not "commitment" — "$1.92/week, 76% less than Weekly".
- Targeted at parents who have read one story and want ritual continuity.
- The "save 76%" math: $7.99 × 52 = $415.48 Weekly-equivalent vs $99.99 Yearly.

**V1.1 voice cloning upsell moment**:
- After 1 week of Weekly/Yearly Basic usage, in-app prompt: "Want [child's name] to hear the story in your voice?"
- One-tap upgrade to Plus tier ($7.99 → $9.99 Weekly, or $99.99 → $139.99 Yearly).
- Upgrade friction minimized via StoreKit's upgrade-subscription flow.

**Paywall A/B testing plan via Purchasely**:
- Week 1–4: Default layout as above, measure baseline.
- Week 5+: Test variations — trial length (3 vs 7 days), Yearly framing ("save 76%" vs "just $1.92/week"), cap messaging visibility.
- Same pattern as Portraiz implementation.

### 9.4 Unit Economics (MVP pricing, Apple Small Business 15% cut)

**Per story cost (MVP, ElevenLabs TTS, no voice cloning, no print)**:
- Story writing (GPT-4o, ~1500 in + 1500 out tokens): ~$0.02
- Image generation (Nano Banana × 8 at $0.012 each): ~$0.096
- TTS narration (ElevenLabs Multilingual v2, ~500 words / ~3000 chars): ~$0.09
- Infrastructure (Firebase Functions, Storage, bandwidth): ~$0.02
- **Total per story: ~$0.226, rounded to $0.23**

**Per pre-signup preview cost** (no narration on preview):
- 1 Nano Banana image: $0.012
- ~100 tokens GPT-4o: $0.002
- Infrastructure: $0.001
- **Total per preview: ~$0.015**

---

#### Weekly subscriber (with 3-day free trial, 3 story/day cap)

**Trial period (3 days, free)**:
- Expected usage: 1–3 stories during trial (parents testing)
- Variable cost exposure: $0.69–$2.07 per trial user
- Trial → paid conversion target: 40–55% (Apple benchmark for consumer apps)

**Paid weekly (3 story/day cap = 21/week max)**:
- Gross: $7.99/week
- Apple fee: $1.20
- Net: $6.79/week
- **Worst-case** (user hits cap every day): 21 × $0.23 = $4.83 variable
  - **Worst margin: $1.96/week = 29%**
- **Realistic** (avg 1–2 stories/day = ~10/week): 10 × $0.23 = $2.30
  - **Realistic margin: $4.49/week = 66%**

**Average paid user lifetime**: 10–14 weeks (consumer app benchmark at $7.99/week)
**Average revenue per paid user**: $68–$95

---

#### Yearly subscriber (1 story/day cap)

**Yearly cap math**:
- Hard cap: 1 story/day
- Annual maximum: 365 stories

**Paid yearly worst-case** (user hits cap every day):
- Gross: $99.99
- Apple fee: $15.00
- Net: $84.99
- Variable: 365 × $0.23 = $83.95
- **Worst margin: $1.04 = 1.2%**

**Paid yearly realistic** (avg 0.5–0.7 stories/day = 180–255/year):
- Variable: 180 × $0.23 = $41.40 to 255 × $0.23 = $58.65
- **Realistic margin: $26.34–$43.59 = 31–51%**

**Paid yearly power-user scenario** (1 story/night, every night — heavy but within cap):
- Variable: ~300 × $0.23 = $69
- **Margin: $15.99 = 19%** — still positive

**Yearly LTV (if user stays year 2+)**: Apple drops fee from 30% to 15% starting month 13 for the same subscription, improving margins further.

---

#### Preview funnel economics

- 10,000 previews/month × $0.015 = $150/month variable cost
- Target 30% preview → signup: 3,000 free signups
- Target 12% signup → paid (Weekly trial): 360 trial starts
- Target 50% trial → paid: 180 paying Weekly subscribers
- Per-paid-Weekly LTV: $80 avg → **$14,400 incremental monthly revenue at 10K preview volume**
- Month-1 LTV/CAC for preview-driven funnel: comfortably > 15x on variable cost alone

**Blended average revenue per paying user (RPU)**:
- 70% Weekly subscribers × $80 LTV = $56
- 30% Yearly subscribers × $85 LTV = $25.50
- **Blended: ~$81 per paying user**

---

#### Key implications

1. **Margins are mathematically guaranteed positive on both tiers** due to daily caps. No cost explosion risk.
2. **Weekly drives cash flow velocity**: users pay every 7 days, payback cycle on Apple Search Ads is 2–3 weeks.
3. **Yearly drives retention depth**: subscribers who choose Yearly stay 4–8× longer, and margins improve year 2 with reduced Apple fee.
4. **Worst-case scenarios are bounded**: the most abusive Weekly user costs $4.83/week to serve; the most abusive Yearly user costs $83.95/year. Both profitable.

#### Cost reduction levers (post-launch optimization)

- Narration caching for common opening/closing phrases: ~10–15% TTS cost reduction → per-story cost ~$0.20
- ElevenLabs Turbo v2.5 if quality testing confirms parity: ~40% TTS reduction → per-story cost ~$0.19
- Enterprise ElevenLabs pricing at scale (>100K stories/month): TBD negotiation, could drop to ~$0.18/story
- Nano Banana pricing likely to decrease over 12–24 months as model costs normalize — monitor quarterly.

#### V1.1 cost delta (when voice cloning ships)

- Voice generation via ElevenLabs cloned voice: +$0.15 per story over default TTS
- Voice cloning one-time setup per user: +$0.30
- Revised per-story cost on Plus tier: ~$0.38

**V1.1 Plus tier margins**:
- Weekly Plus $9.99 → net $8.49 → worst margin (21 stories × $0.38 = $7.98): 6%
- Yearly Plus $139.99 → net $118.99 → worst margin (365 × $0.38 = $138.70): -16.5% (!)

**Implication**: Yearly Plus may need higher pricing ($149.99 or $159.99) to protect worst-case margin on voice cloning, or tighter cap (e.g., voice cloning unlocked only on 0.8/day average — i.e., 300 stories/year cap). Finalized at V1.1 design time with real V1.0 usage data.

### 9.5 Print economics (v2)

- Gelato cost for 8×10 hardcover, 24 pages: ~$14 + $6 shipping = $20
- Retail: $39
- Gross margin: $19 / book (~48%)

---

## 10. Localization

### 10.1 Launch Languages

Shipping with 10 languages in public V1:

1. English (US) — baseline
2. English (UK)
3. German
4. French
5. Spanish (Spain)
6. Spanish (Mexico)
7. Italian
8. Polish
9. Hungarian
10. Portuguese (Brazil)

Phase-2 additions: Dutch, Czech, Swedish, Japanese, Korean.

### 10.2 What is localized

- All app UI (Flutter ARB files).
- Story generation system prompts per language (native-level cultural tuning).
- Setup card labels and voiceover.
- Paywall and onboarding copy.
- Story output — the entire story is generated in target language, not translated from English.
- Narration voices — default voices per language; voice cloning works in user's native language.
- ASO keywords, App Store subtitle, description, screenshots per store locale.

### 10.3 Localization architecture

- Firestore `systemPrompts/{language}` document stores language-specific prompts.
- Remote Config layers on top for per-locale feature flags.
- JSON patch files pattern (same as Portraiz) for rapid non-code-deploy updates to copy.

### 10.4 Cultural considerations

- Name handling: Eastern European names often have grammatical declension (Hungarian especially). Story prompts must instruct model to decline names correctly.
- Holidays and references: "Thanksgiving" doesn't land in France; replace with locale-appropriate concepts.
- Food, animals, and scenery examples should skew to culturally familiar (kangaroo for Australia, fox for northern Europe, etc.).
- Gender-neutral pronouns vary by language; handle per-locale.

---

## 11. Safety & Compliance

### 11.1 COPPA Compliance (US)

- The app collects personal information of children under 13 only with verifiable parental consent.
- Parent creates the account; child never creates one.
- No direct marketing to children.
- No behavioral advertising.
- Parental dashboard to view/delete child's data.
- Data minimization: we store only what's necessary for story generation.

### 11.2 GDPR & GDPR-K Compliance (EU)

- Explicit consent collection at onboarding.
- Data Processing Agreement with ElevenLabs, OpenAI, Google.
- Right to access, rectify, delete, port.
- Data Protection Impact Assessment (DPIA) to be completed pre-launch.
- EU data residency (Firebase EU region for EU users).
- Children under 16 (varies by country): heightened consent requirements.

### 11.3 Content Safety Guardrails

Hard rules enforced at the story-writer system-prompt level:

- No violence, no death, no scary imagery for ages 3–6. Mild peril OK for 7–8.
- No romantic or sexual content.
- No religious content unless explicitly selected (seasonal packs).
- No politically sensitive topics.
- No trademarked characters (Mickey, Elsa, etc.) — refuse even if child requests by name in setup.
- No real public figures.
- No scary monsters, ghosts, deep-water threats for ages 3–5.

Post-generation filtering:
- OpenAI Moderation API pass on every story text.
- Image moderation via built-in Nano Banana safety + custom CV model for sensitive content.
- Human review queue for first-100 users per language (manual QA before full release).

### 11.4 AI Safety — Refusal Behaviors

- If parent tries to input anything inappropriate in "teaching moment" field, story generation refuses and shows friendly error.
- Hero profile photo validation: face-detection confirms it's a child's photo before accepting.
- Voice cloning validates the sample isn't a child's voice (adult voice detection required for voice cloning).

### 11.5 Photo & Voice Data Handling

- **Original photos**: encrypted upload, used for hero anchor generation, **deleted within 24 hours**.
- **Hero anchor image**: stylized illustration, retained (no longer resembles real photo).
- **Voice sample**: encrypted upload, cloned to ElevenLabs, **deleted within 24 hours**.
- **ElevenLabs voice model**: retained, deletable on demand, auto-deleted 30 days after account cancellation.
- No training: explicit "do not use for training" clause with all AI vendors.

---

## 12. Metrics & Analytics

### 12.1 North Star Metric

**Weekly Active Story Generations per Family (WASGF)** — unique families who generate at least one story in a given calendar week.

Target progression:
- Week 1 (post-signup): 80% of users generate 1st story.
- Week 2: 40% generate 2nd story.
- Week 4: 25% generate 3+ stories.
- Month 3: 15% sustain 3+ stories/week (this is the ritual behavior).

### 12.2 Leading Indicators

- **Preview completion rate**: % who start preview and see the reveal. Target: 85%+.
- **Preview-to-signup conversion**: % of preview completers who sign up. Target: 25–35%.
- **Time-to-first-story**: target ≤ 3 minutes from signup.
- **Setup completion rate**: % who start "Tonight's Adventure" and complete it. Target: 90%+.
- **Voice cloning adoption** (V1.1+): % of Plus-tier users with a voice model. Target: 60%+.
- **Story completion rate**: % of started stories read to end. Target: 80%+.
- **Re-read rate**: avg re-reads per story. Target: 1.5.

### 12.3 Funnel Metrics

```
App install → Preview started: target 90%
Preview started → Preview completed (reveal seen): 85%
Preview completed → Sign-up: 25–35%
Sign-up → Hero profile completed: 90%
Hero created → First story generated: 95%
First story → Story completed (read to end): 80%
Story completed → 2nd story started: 50%
2nd story → 4th story (past paywall): 30%
Paywall shown → Subscribed: 8–12%
```

### 12.4 Retention Cohorts

Standard Day 1 / Day 7 / Day 30 / Day 90 retention.
Target: D1 60% / D7 35% / D30 20% / D90 12%.

Benchmarks from competitor data suggest current market D30 is ~8%; 20% would be strong.

### 12.5 Revenue Metrics

- ARPU, ARPPU (paying user).
- Free-to-paid conversion rate.
- LTV (lifetime value) by acquisition channel.
- LTV / CAC ratio — target: 3x within 18 months.
- Churn: target monthly < 6%, annual < 30%.

### 12.6 Tooling

- Firebase Analytics for event streaming.
- Mixpanel or Amplitude for funnel analysis.
- RevenueCat or Purchasely analytics for subscription lifecycle.
- Custom dashboard in Retool or Metabase for executive KPIs.

---

## 13. Development Roadmap

### Phase 0: Validation Spike (Weeks 1–2)

**Goal**: De-risk the highest-uncertainty technical assumptions before committing to a full MVP build.

**Deliverables**:
- **Nano Banana character-consistency test**: generate 20 scenes from a single child photo (single-anchor strategy) across 4 art styles. Measure perceived consistency with 10 test parents. Target: 8/10 rate "recognizably the same child" for each style.
- **Art style reference curation**: source 3 reference images per art style (4 styles × 3 = 12 refs) from stock + public-domain + Nano Banana bootstrap. Validate that each reference set reliably steers the AI output.
- **ElevenLabs voice selection**: blind-test 2–3 female + 2–3 male ElevenLabs Multilingual v2 voices per launch language (EN / HU / DE). Pick winners — one male and one female per language. Provider is locked (ElevenLabs); only specific voice IDs are decided here.
- **Cost model validation**: real per-story cost measured end-to-end. Confirm target of ~$0.23/story.
- **Trademark + domain clearance**: confirm "Lullabook" is clear for USPTO/EUIPO and lullabook.app domain is available.

**Exit criterion**: All AI components produce outputs of shippable quality at target cost. If Nano Banana consistency fails, consider Seedream or Imagen 4 as alternative before committing to MVP build.

### Phase 1: MVP Alpha (Weeks 3–9, ~7 weeks)

**Scope**: F-0 through F-4, F-6 through F-8 (all MVP core features, no voice cloning, no print). English only. iOS only.

**Team**: Solo build. Reference art style curation self-served from stock + Nano Banana bootstrap.

**Milestones**:
- Week 3: Flutter scaffolding, auth, Firestore schema, Purchasely integration, pre-signup preview endpoint (F-0 bootstrapped).
- Week 4: Hero profile flow + photo upload + Nano Banana anchor generation (F-1). Preview → Hero Card migration logic.
- Week 5: Setup flow (F-2) with card UI in portrait.
- Week 6: Story generation pipeline end-to-end (F-3) + art style templates (F-4) + default TTS narration (F-5 MVP scope).
- Week 7: Page-flip reader (F-6) + story library (F-7) + offline mode (F-8).
- Week 8: Paywall polish, onboarding refinements, analytics wiring, retry/fallback testing, QA bug bash.
- Week 9: Closed beta with 30 families.

**Exit criterion**: closed-beta D7 retention ≥ 30%, story completion rate ≥ 75%.

### Phase 2: Public Beta (Weeks 10–12)

- Apple App Store submission.
- Public TestFlight beta expansion to 500 users via waitlist.
- Android parallel build.
- Critical-path bug fixes.
- **Second language added**: start with German or Hungarian (depending on easiest win for initial marketing).

### Phase 3: V1 Launch (Weeks 13–14)

**Scope**: Public release iOS + Android, 3 languages (EN, DE, HU).

**Readiness checklist**:
- COPPA compliance reviewed by legal.
- GDPR DPIA complete.
- App Store metadata + ASO optimized per locale.
- Marketing assets (landing page, TikTok/Reel demo videos, press kit).
- Monitoring & alerting set up (Sentry, Firebase Crashlytics, uptime monitoring).

**Launch channels**:
- ProductHunt launch week 14.
- Instagram Reels & TikTok seeding (20 parent-niche creators).
- Reddit: r/parenting, r/toddlers, r/Mommit, r/daddit (soft-launch story posts, not ads).
- App Store featuring pitch submitted 4 weeks ahead of launch.

### Phase 4: V1.1 — Voice Cloning + Retention Features (Weeks 15–22, ~6–8 weeks)

**Primary feature**: F-5 Parent Voice Cloning — the flagship V1.1 launch.

**Secondary features**:
- F-9: Recurring side characters.
- F-10: Streak & badges (parent-facing only).
- F-11: Hero evolution.
- Language expansion to 10 total.
- Retention cohort analysis and paywall optimization.
- Price-tier restructuring: introduce $9.99/month "Plus" tier with voice cloning.

**Exit criterion**: D30 retention ≥ 18%, voice cloning adopted by 40%+ of Plus subscribers.

### Phase 5: Growth & Print (Weeks 23–29, ~4–6 weeks)

- F-12: Gelato print integration.
- F-13: Gift mode.
- Referral program ("give a story, get a story").
- Creator affiliate program (influencer affiliate links with revenue share).

### Phase 6+: Post-V1

Deferred features for consideration based on data:
- F-14: Multi-hero family library.
- F-15: Seasonal theme packs.
- iPad-first reader rewrite (if usage data shows tablet dominance).
- Apple TV / Chromecast support.
- Alexa / Google Home integration ("Alexa, tell Sofia's bedtime story").
- School / educator tier.

---

## 14. Technical Risks & Mitigations

### 14.1 AI provider pricing changes

- **Risk**: Nano Banana or ElevenLabs significantly raises prices post-launch.
- **Mitigation**: Dual-provider architecture from day 1 (already a strength from Portraiz). Quarterly cost audits. Maintain contingency budget for model migration.

### 14.2 AI model quality regression

- **Risk**: A model update breaks hero consistency or generates unsafe content.
- **Mitigation**: Pinned model versions in API calls. Regression test suite of 50 reference generations run nightly. Instant fallback toggle via Remote Config.

### 14.3 Google Gemini Storybook competitive pressure

- **Risk**: Google dramatically improves Gemini Storybook and makes it the default for parents.
- **Mitigation**: Moat is not the underlying model; moat is the ritual (kid-participation + voice + recurring hero). Google is unlikely to invest in that specialized UX. Monitor quarterly. If Gemini adds voice cloning + family library, reconsider positioning.

### 14.4 Child safety incident

- **Risk**: A user's child is exposed to inappropriate generated content, going public.
- **Mitigation**: Multi-layer safety stack (§11.3). Human review of first 100 stories per new language. Immediate-response protocol. Media-ready crisis statement pre-drafted.

### 14.5 Retention plateau

- **Risk**: Users create 3–5 stories and stop, like StoryMe users did.
- **Mitigation**: Phase 4 retention features specifically address this. If D30 < 12% at month 3, escalate retention work over growth work.

### 14.6 Voice cloning abuse / deepfake concerns

- **Risk**: Someone uses voice cloning to impersonate their partner or a celebrity.
- **Mitigation**: ElevenLabs watermarking; require voice-auth recording script that proves live voice; limit to 1 voice model per account; cannot export raw audio from app.

### 14.7 Print supply chain

- **Risk**: Gelato delays or quality issues damage brand.
- **Mitigation**: Print only launches in v2 when baseline app is stable. Secondary supplier (Lulu Direct) qualified. Clear customer-service SLA for refunds.

### 14.8 Regulatory shifts

- **Risk**: EU AI Act or US state-level regulation changes child-AI rules mid-2026.
- **Mitigation**: Monitor AI regulation news monthly. Budget for legal review quarterly. Architecture already conservative on data retention.

---

## 15. Go-to-Market Plan

### 15.1 Pre-launch (Weeks 10–16)

- Waitlist landing page (Carrd or Framer) → collect emails with 50% discount offer at launch.
- 20 parent micro-influencers (10K–50K followers) seeded with free Pro accounts + content brief.
- Build library of 30 pre-generated demo stories for marketing reels.
- Press embargo pitch to 10 parenting publications + 3 tech publications.

### 15.2 Launch week (Week 17)

- ProductHunt launch Tuesday.
- Coordinated Instagram Reels + TikTok drop with creators.
- Reddit AMA in r/parenting.
- Email blast to waitlist.
- Apple featuring pitch submitted.

### 15.3 Post-launch (Weeks 17–24)

- Weekly organic content: 3 Reels, 2 TikToks, 1 Twitter thread.
- Apple Search Ads: $1000/month starting, bid on "bedtime stories", "kids books", "story for kids", competitor brand names.
- Referral program launch (month 2).
- First user story collection / testimonial video (month 2).

### 15.4 Ongoing growth

- SEO content: parenting blog under the brand ("Best bedtime stories for 5-year-olds", "How to make bedtime stress-free"), driving to the web landing page.
- Affiliate / creator program.
- Seasonal campaigns (Christmas gift push, back-to-school, Mother's/Father's Day).
- Localized launches per country: hire a native-speaking parent influencer per major market.

---

## 16. Success Criteria

### 16.1 3-month targets (post-V1 launch)

- 10,000 installs.
- 8% free-to-paid conversion.
- D30 retention: 15%.
- Monthly churn: < 10%.
- Net MRR: $5,000–$8,000.

### 16.2 6-month targets

- 50,000 installs.
- 10% conversion rate.
- D30 retention: 20%.
- Monthly churn: < 7%.
- Net MRR: $25,000–$40,000.
- Printed-book orders: 500 total (v2 launched).
- 10 languages live.

### 16.3 12-month targets

- 250,000 installs.
- D30 retention: 22%+.
- D90 retention: 12%+.
- Net MRR: $80,000–$150,000.
- Positive LTV/CAC (≥ 3:1).
- Brand established in at least 3 non-English markets.

### 16.4 Failure criteria (stop-or-pivot thresholds)

- At month 3: if D30 retention < 8%, escalate to retention rework before further growth spend.
- At month 6: if LTV / CAC < 1.5, pause paid acquisition and focus on organic + referral.
- At month 9: if MRR < $15,000, reassess whether app should continue as primary focus vs re-prioritize Portraiz.

---

## Appendix A. Story Structure Template

Every generated story follows this 8-page arc, which GPT-4o is instructed to match:

| Page | Function | Example (5-year-old astronaut story) |
|---|---|---|
| 1 | Cover / Hero introduction in familiar context | Sofia in her backyard at night, looking at stars |
| 2 | Inciting incident / adventure begins | A shooting star lands in the garden, reveals a tiny spaceship |
| 3 | Setting changes / stakes introduced | Sofia flies to a moon where a baby moon-fox is lost |
| 4 | First challenge | The moon is freezing; Sofia must find a way to help |
| 5 | Deepening — hero uses a defining trait | Sofia remembers her cozy red scarf (because she always brings it) and wraps the fox |
| 6 | Climax / resolution of the challenge | They find the fox's family with Sofia's bravery + scarf |
| 7 | Return / warmth / teaching moment | The moon-fox family gives Sofia a star to remember them |
| 8 | Coming home / affirmation / sleep cue | Sofia is back in her bed, the star on her bedside table glowing softly |

## Appendix B. System Prompt Template (Story Writer, Excerpt)

```
You are a tender, warm, expert children's book writer specializing in
personalized bedtime stories for a child named {HERO_NAME}, age {AGE}.
Language: {LANGUAGE}.

You MUST:
- Write exactly 8 pages, 2-4 sentences each.
- Use age-appropriate vocabulary (reading level: {GRADE_LEVEL}).
- Follow the 8-page arc template provided.
- Make {HERO_NAME} the active protagonist who solves the challenge
  through their own qualities (never rescued by an adult).
- Embed the teaching moment "{TEACHING_MOMENT}" through action, never
  through a character's monologue.
- Include {COMPANION} as a supporting character if specified.
- End on a calm, sleep-inducing note in the final page.

You MUST NOT:
- Depict violence, injury, death, scary monsters, or abandonment.
- Use religious content unless "religious_pack" is true.
- Reference real people, brands, trademarked characters.
- Use negative self-talk about the hero's appearance or abilities.
- Write stories longer than 120 words per page.

Output format: valid JSON matching the schema in Appendix C.
```

## Appendix C. Glossary

- **Hero**: the child-as-protagonist, the persistent character.
- **Hero Card**: internal data object representing the Hero.
- **Hero Anchor Image**: the stylized reference image used for Nano Banana consistency.
- **Tonight's Adventure**: the setup flow name.
- **Story Universe**: the evolving body of a family's stories.
- **Ritual flow**: the nightly repeat experience targeting D30+ retention.
- **Recurring side character**: auto-tracked characters who return across stories.
- **WASGF**: Weekly Active Story Generations per Family (north star metric).

---

## Open Questions Summary

**Closed decisions (v1.4)**:
1. ✅ Hero Anchor strategy: **single-image approach** confirmed. Revisit text-description augmentation only if Phase 0 testing reveals consistency lapses.
2. ✅ Initial art style reference anchors: **no illustrator commission**. Reference images sourced from public-domain + licensed stock ($100–200 total budget).
3. ✅ Story writer model: **GPT-4o** confirmed for MVP.
4. ✅ Voice cloning: **deferred to V1.1**, not in MVP. Professional TTS used at launch.
5. ✅ Print-on-demand: **V2 only**, not in MVP.
6. ✅ Product name: **Lullabook**.
7. ✅ TTS provider: **ElevenLabs Multilingual v2** locked for MVP.
8. ✅ Pricing structure: **Weekly $7.99 + Yearly $99.99 only**. No Monthly, no Family tier in MVP.
9. ✅ Daily caps: **3/day on Weekly, 1/day on Yearly**. Mathematically guarantees positive margin worst-case.
10. ✅ Yearly hero allowance: **2 heroes included** (covers 80% of families, 3+ child families buy multiple Yearly).

**Still open**:
11. **[OPEN]** Specific ElevenLabs voices per language (2 per language, male + female mesélő). Finalized in Phase 0 Exp 3.
12. **[OPEN]** Pre-signup preview abuse thresholds: 1/device/24h vs 1/IP/24h vs phone-verification gate. Tune based on actual abuse seen in first 2 weeks of public launch.
13. **[OPEN]** Legal review of COPPA + GDPR-K strategy pre-launch. (Decision deadline: Week 11.)
14. **[OPEN]** V1.1 Yearly Plus pricing ($139.99 vs $149.99 vs $159.99) depending on real voice cloning usage patterns from V1.0.
15. **[OPEN]** Gelato API integration feasibility testing for V2 print. (Decision deadline: Week 20.)

---

*End of document. Please treat this as a living specification. Version-control changes and note the rationale for major edits.*
