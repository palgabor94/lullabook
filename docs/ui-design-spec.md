# Lullabook — UI Design Specification

> Companion document to: `lullabook-prd.md` v1.6 + `lullabook-tech-spec.md` v1.0
> Purpose: Complete handoff document for Google Stitch (or human designer) to generate the full app UI
> Version: 2.0 — Modern direction (replaces v1 "warm storybook")
> Last updated: April 2026

> **Direction change v1 → v2**: The original v1 direction was "warm storybook" (Fraunces serif + watercolor + soft pillows). After visual prototyping, this read too "kids' app traditional" and not premium enough. The v2 modern direction trades the serif for confident sans-serif (Inter), tightens letter-spacing, simplifies dark backgrounds to near-black indigo (#0F0B1F), brightens the gold accent (#FFB84D), and adopts the modern consumer-AI app aesthetic seen in Headspace 2024, Cash App, and Linear — while preserving warm gold accent and bedtime context. **Serif (Fraunces) is retained only inside the Story Reader** where the bedtime mood matters most. All sections below reflect the v2 direction.

---

## 0. How to use this document with Google Stitch

Google Stitch generates UI from natural language prompts and reference images. To get the best output:

1. **Start with §1 (brand essence + mood)** — paste it into Stitch as the global system prompt for the project.
2. **Then §2 (design tokens)** — colors, typography, spacing. Set these as the design system.
3. **Then §3 (component library)** — generate base components first.
4. **Finally §4 (screens, in order)** — generate screen by screen, in the order listed.

If using a human designer instead, this document is a complete brief — they can produce Figma files directly from sections §2–§4.

---

## 1. Brand essence & mood

### 1.1 The single sentence

**Lullabook is the warm, magical, slightly sleepy moment between "story time" and "goodnight."**

Every design decision serves that single moment.

### 1.2 Mood references (v2 modern)

The visual tone sits at the intersection of:

- **Headspace (2024 redesign)** — confident dark mode, generous whitespace, premium consumer wellness
- **Cash App** — magazine-bold typography, bright accent colors against near-black, modern dashboard aesthetic
- **Linear / Cron / Spark** — restrained chrome, tight letter-spacing, "professional but warm"
- **Apple Music dark mode** — large bold display type, hero cards with gradient images

Plus warmth references for illustration content:

- **Tonies / Yoto** — friendly hero illustrations inside the dark UI chrome
- **Classic European children's book illustration** — Beatrix Potter, Maurice Sendak — for the actual story page art (NOT for UI chrome)

The visual tone is **NOT**:
- Disney-saturated (overly cute, primary colors, cartoonish)
- TikTok-bright (neon, gradients, busy)
- Generic SaaS (flat blues, geometric, sterile)
- AI-techy (dark purple/cyan gradients, neural network visualization)
- **Old-school storybook** (this was the v1 direction — Fraunces everywhere, watercolor chrome, very pillowy — read as "traditional kids app", not premium)

### 1.3 Emotional adjectives (v2 modern)

When in doubt, ask: does this feel...
- **Confident** (not timid)
- **Premium** (not cute)
- **Warm** (not cold) — preserved from v1
- **Quiet** (not loud) — preserved from v1
- **Modern** (not nostalgic)
- **Trustworthy** (not gimmicky)
- **Calm** (not energetic)

The two preserved-from-v1 adjectives (warm + quiet) are what keep the app from drifting toward cold/techy. Everything else has shifted toward magazine-modern.

### 1.4 Anti-patterns to avoid

- Never use pure white (#FFFFFF) backgrounds — always tinted off-white
- Never use pure black (#000000) text — always softened
- No gradients on UI elements (only on illustrations)
- No drop shadows that look "Material 2017"
- No emoji in UI chrome (only in user-generated content like reactions)
- No bouncy/spring animations longer than 200ms
- No rainbow color palettes
- No "AI sparkles" iconography

---

## 2. Design tokens

### 2.1 Color palette — Modern Dark

**Updated direction (v2 modern)**: deeper, more confident dark mode. Inspired by premium consumer AI apps — Headspace, Cash App, Linear — but with the warm gold accent that keeps it bedtime-appropriate, not cold or techy.

#### Surface colors

```
bg-base:        #0F0B1F   — primary app background, near-black indigo
bg-elevated:    #1A1335   — elevated surface (cards, modals)
bg-card:        #1F1A3D   — secondary card surface
bg-hover:       rgba(255, 255, 255, 0.04)   — subtle interactive hover
bg-glass:       rgba(15, 11, 31, 0.6)        — glassmorphism over images (with backdrop-blur)
```

#### Accent — "Lullabook Gold"

```
gold-300:  #FFE5A8   — highlights, sparkles
gold-500:  #FFB84D   — primary accent (CTA backgrounds, badges, magic moments)
gold-700:  #D89020   — darker shade for text-on-gold
gold-900:  #9C7224   — deepest shade
```

#### Text colors (on dark)

```
text-primary:    #FFFFFF                          — pure white for headlines
text-secondary:  rgba(255, 255, 255, 0.7)         — body text
text-tertiary:   rgba(255, 255, 255, 0.5)         — muted, descriptions
text-disabled:   rgba(255, 255, 255, 0.4)         — captions, fine print
text-faint:      rgba(255, 255, 255, 0.3)         — placeholders
```

#### Border & divider

```
border-subtle:   rgba(255, 255, 255, 0.06)        — card borders
border-default:  rgba(255, 255, 255, 0.1)         — input borders
border-strong:   rgba(255, 255, 255, 0.15)        — separators
```

#### Semantic colors

```
success:  #5A8F6B
warning:  #FFB84D
error:    #E07B6E
info:     #6B7DA8
```

#### Light mode — secondary support

Light mode is **NOT a priority for MVP**. Bedtime context = dark mode-first. If implemented as a system-following secondary mode:

```
bg-base-light:        #FAF8F4   — warm off-white
bg-elevated-light:    #FFFFFF
text-primary-light:   #0F0B1F
text-secondary-light: rgba(15, 11, 31, 0.6)
```

Story Reader is **always dark**, regardless of system mode.

### 2.2 Typography — Modern Sans-Serif

**Updated direction (v2 modern)**: Inter for everything in UI chrome. The previous direction used Fraunces serif for warmth — the modern direction trades that for confidence, clarity, and contemporary credibility. The serif aesthetic is preserved only inside the Story Reader (where the bedtime mood matters most).

#### Primary font — "Inter"

Used for: app name, screen titles, all UI text, body, navigation, buttons.

- Why: highly legible, neutral, universally trusted, modern. Free via Google Fonts. Variable font supports the full weight range.
- Weights used: 400 (regular), 500 (medium), 600 (semibold), 700 (bold)

```
display-2xl:  36/40px,  Inter 700, letter-spacing -0.03em    — splash wordmark
display-xl:   32/36px,  Inter 700, letter-spacing -0.025em   — primary screen titles ("Tonight's adventure")
display-lg:   28/32px,  Inter 700, letter-spacing -0.025em   — secondary screen titles
display-md:   22/28px,  Inter 700, letter-spacing -0.02em    — emphasis text in cards
display-sm:   18/24px,  Inter 600, letter-spacing -0.01em    — section headers, button labels
```

```
body-lg:      15/22px,  Inter 500                              — primary body, button labels
body-md:      14/20px,  Inter 400                              — secondary body, descriptions
body-sm:      13/18px,  Inter 500                              — captions, metadata
body-xs:      11/16px,  Inter 400                              — tertiary captions
```

```
eyebrow-md:   11/14px,  Inter 700, letter-spacing 0.12em       — primary eyebrows ("LULLABOOK PREMIUM")
eyebrow-sm:    10/13px,  Inter 600, letter-spacing 0.08em       — secondary eyebrows ("12 STORIES")
eyebrow-xs:     9/12px,  Inter 700, letter-spacing 0.06em       — tab bar labels ("TONIGHT")
```

#### Story Reader font — "Fraunces"

Used **only** inside the Story Reader's text area, where bedtime mood is paramount.

- Why: the warm, slightly old-fashioned feel anchors the actual reading experience as something special and book-like, even though the rest of the app is modern.
- Weights used: 400 (regular), 500 (medium for dialogue)

```
story-text:    17/27px,  Fraunces 400, letter-spacing -0.005em   — story page narration
story-dialog:  17/27px,  Fraunces 500 italic, color: gold-500    — character dialogue
```

#### Typography rules

- **Bold (600-700) for all titles and CTAs** — confidence over softness in UI chrome
- **Tight letter-spacing on display sizes** (-0.025em) — modern, magazine-like
- **No italic anywhere except story dialogue** — italic in chrome reads dated
- **All eyebrows uppercase with 0.06–0.12em letter-spacing** — categorical, modern dashboard feel
- **No serif in UI chrome** — that battle is over; modern apps win on Inter

### 2.3 Spacing

Use a 4px base grid. Always multiples of 4.

```
space-1:   4px
space-2:   8px
space-3:   12px
space-4:   16px   — most common gap
space-5:   20px
space-6:   24px
space-8:   32px
space-10:  40px
space-12:  48px
space-16:  64px
space-20:  80px
```

**Standard screen padding**: 24px horizontal, 32px top, 24px bottom (with safe area).

**Standard card internal padding**: 20px.

### 2.4 Border radius — Modern

Slightly smaller radii than the previous "soft pillows" direction. Modern apps use 12–16px corners on cards, not 24px+.

```
radius-sm:    8px    — small chips, tags, eyebrow badges
radius-md:    12px   — buttons, inputs (formerly 16)
radius-lg:    14px   — primary CTA buttons
radius-card:  18px   — small cards, tile components
radius-xl:    20px   — large cards, paywall pricing cards
radius-2xl:   24px   — hero cards, story covers, container surfaces
radius-full:  9999px — circular avatars only
```

The modern direction uses **less rounding** than the original — sharper corners read more confident, less cuddly. The exception is the device frame (36px) and circular avatars.

### 2.5 Shadows

Soft, never harsh. Used sparingly — most elevation comes from background tinting.

```
shadow-sm:  0 2px 8px  rgba(31, 26, 61, 0.06)   — subtle lift
shadow-md:  0 8px 24px rgba(31, 26, 61, 0.10)   — cards floating
shadow-lg:  0 16px 48px rgba(31, 26, 61, 0.16)  — modals
shadow-glow: 0 0 32px rgba(219, 168, 75, 0.30)  — magic moments only (gold accent halo)
```

### 2.6 Animation

Bedtime-paced. Never bouncy, never instant.

```
duration-fast:   150ms  — small UI feedback (button press)
duration-base:   250ms  — most transitions
duration-slow:   400ms  — screen transitions
duration-magic:  800ms  — Hero Reveal moment, dream sequences

easing-default:  cubic-bezier(0.4, 0.0, 0.2, 1)        — material standard
easing-soft:     cubic-bezier(0.25, 0.1, 0.25, 1)      — gentle ease
easing-magic:    cubic-bezier(0.34, 1.56, 0.64, 1)     — ONLY for magic reveals
```

**No spring physics for UI chrome.** Reserved for delight moments only (Hero Reveal animation, sleep mode wake-up).

### 2.7 Iconography

Use the **Phosphor Icons** library (free, open source) at the **"duotone"** weight.

- Why duotone: warm, soft, less geometric than Heroicons or Material
- Default size: 24px in nav/buttons, 20px in inline labels, 32px in hero positions
- Color: matches text color of containing element by default; gold-500 for "magic" actions only

Icon list per feature is in §4.

### 2.8 Mode

The app is **dark-mode first**. The bedtime context is dim. Light mode is supported but secondary.

- **Default**: dark mode (indigo-900 background)
- **Light mode**: triggered by user setting OR system preference; cream-50 background
- **Story Reader**: always dark, regardless of system mode (the experience demands it)

---

## 3. Component library

Components to generate first in Stitch (in order). Each is described as a Stitch prompt + visual notes.

### 3.1 Button — Modern

**Variants**:
- `primary` — **white fill (#FFFFFF), bg-base text (#0F0B1F)**, body-lg label, 54px height, 14px radius. The white-on-dark CTA is the modern app signature (Cash App, Headspace, Linear all use this pattern).
- `secondary` — bg-card fill, text-primary, 54px, 14px radius
- `ghost` — transparent fill, text-tertiary, 44px, no border
- `accent-gold` — gold-500 fill, bg-base text — used for hero CTAs only (the orange/gold "Start tonight's adventure" hero card on home)
- `destructive` — error color fill, white text — for "Delete account" only

**Sizes**:
- `lg` (default) — 54px height
- `md` — 44px height
- `sm` — 36px height (chips, filter pills)

**States**: 
- default
- pressed: scale to 97% briefly + 90% opacity
- disabled: 30% opacity

**Stitch prompt**:
> "A pill-shaped button with 14px corner radius, 54px tall, with text 'Continue' centered. Use Inter 600, 15px, letter-spacing -0.01em. Background is pure white (#FFFFFF), text is deep dark indigo (#0F0B1F). On a dark background (#0F0B1F). On press, scale to 97% with 250ms ease. No shadow, no border. Pure white fill."

### 3.2 Text input

- Background: indigo-800 (dark) or indigo-50 (light)
- Border: 1.5px indigo-200 (default), gold-500 (focus), error (error state)
- Border radius: 16px
- Padding: 16px horizontal, 18px vertical
- Label above: body-xs eyebrow style, text-secondary
- Placeholder: text-tertiary, body-md
- Helper text below: body-sm, text-tertiary or error
- Height: 56px

### 3.3 Card

**Variants**:
- `flat` — surface tint background, no shadow (default for grouping)
- `floating` — surface tint + shadow-sm (interactive cards)
- `hero` — gradient background, shadow-md, 32px radius (Hero Reveal, story covers)

**Internal padding**: 20px (default), 24px (large)

### 3.4 Adventure tile (custom component)

A square, tappable tile used in the F-2 setup flow. Each adventure has:
- Illustrated icon (~80×80 area), warm, hand-drawn feel
- Label below (body-md, text-primary)
- Background: subtle cream/indigo tint matching theme
- Border: 1.5px transparent default; gold-500 when selected
- Tile size: 156×156 (mobile portrait), 4 per row → 2 rows
- Tap: scale to 95% + glow-sm shadow

**Stitch prompt for one tile**:
> "A square tile, 156x156px, with rounded 24px corners. Background is a warm cream tint (#F8F2E4). Centered in the upper portion is an 80x80 illustrated icon of an astronaut helmet, drawn in a soft watercolor style with warm tones. Below the icon, in Inter Medium 15px, the label 'Astronaut'. When selected, the tile has a 1.5px gold border (#DBA84B) and a soft glow."

### 3.5 Hero anchor avatar

A circular framed image showing the child's stylized hero portrait.

- Sizes: 48px (nav), 96px (cards), 160px (hero card), 240px (Hero Reveal preview)
- Frame: 2px gold-500 border with shadow-glow on hero positions
- Background: cream-100
- Fallback (no anchor yet): placeholder illustrated cloud with sleeping moon

### 3.6 Story page card

Used in the library grid. Shows:
- Square cover illustration (page 1 image)
- Title (display-sm, 2 lines max)
- Date created (body-sm, text-tertiary)
- Optional favorite heart (gold-500 if favorited)

**Dimensions**: 168×220 (mobile, 2 columns), 200×260 (tablet, 3 columns)

### 3.7 Loading states

#### Skeleton loader
- Background: indigo-800 with subtle animated shimmer in indigo-700
- Used for: library grid while stories load, card placeholders

#### Generation loading screen
- Full-screen, indigo-900 background
- Centered animated illustration: a glowing star slowly orbiting a moon, drawn in watercolor style
- Loading text below: "Drawing Sofia's adventure...", "Writing tonight's story...", "Almost ready..."
- Progress: implied via text rotation every 8-10 seconds, no progress bar
- Total duration: 60–90 seconds (matches backend)

### 3.8 Bottom sheet / modal

- Background: indigo-800 (dark) or cream-50 (light)
- Border radius: 32px top corners only
- Drag handle: 4px wide, 40px long, indigo-200, centered top
- Internal padding: 24px horizontal, 32px top, 32px bottom + safe area
- Backdrop: rgba(20, 16, 42, 0.6) with 16px backdrop blur

### 3.9 Toast / Snackbar

- Position: top, below safe area
- Background: indigo-800 (dark) or indigo-700 (light)
- Border radius: 16px
- Padding: 12px 16px
- Icon: 20px, semantic color (success/warning/error/info)
- Text: body-md, text-primary on dark
- Auto-dismiss: 3.5 seconds
- Animation: slide down + fade in 250ms

### 3.10 Tab bar (bottom navigation)

- Height: 56px + safe area
- Background: indigo-900 with 16px backdrop blur (translucent over content)
- Top border: 0.5px indigo-800
- 3 tabs only (resist adding more):
  - **Tonight** (home) — moon icon
  - **Library** — book-stack icon
  - **Settings** — gear icon
- Active tab: gold-500 icon + label, body-xs eyebrow
- Inactive tab: text-tertiary

---

## 4. Screen specifications

Order matches the user journey. Generate in order.

### 4.1 Splash screen

**Purpose**: branded boot screen while app initializes.

**Layout**:
- Full-screen indigo-900 background
- Centered: Lullabook wordmark in Fraunces 500, gold-500, display-xl
- Below wordmark (32px gap): tagline "Bedtime stories starring your child" in body-md, text-secondary on dark
- Subtle animated star illustration above the wordmark, slowly twinkling

**Stitch prompt**:
> "A mobile splash screen, full screen 390x844, deep indigo background (#14102A). Centered vertically, the word 'Lullabook' in Fraunces 500 italic, 56px, warm gold color (#DBA84B). Above the word, 80px gap, a small glowing 5-pointed star illustration in soft watercolor style, slowly twinkling. Below the word, 24px gap, the tagline 'Bedtime stories starring your child' in Inter Regular 15px, color #C9C2DE. Subtle starry texture in the far background, very low opacity."

### 4.2 Onboarding teaser → F-0 entry

**Purpose**: explain the value in 3 swipeable cards, lead into Hero Reveal.

**Layout**:
- 3 carousel pages, each:
  - Hero illustration (top 60% of screen)
  - Headline (display-lg, text-primary on dark)
  - Description (body-md, text-secondary on dark)
- Page indicator dots (bottom, gold-500 active)
- "Get Started" primary button at bottom (sticky)

**Page 1**: 
- Illustration: a sleeping child with a small glowing book floating above
- Headline: "Stories starring your child"
- Description: "Upload one photo. We turn your child into the hero of a brand new bedtime story."

**Page 2**:
- Illustration: the child as an astronaut, watercolor style
- Headline: "A new adventure every night"
- Description: "Astronaut tonight, pirate tomorrow, wizard the next. The hero is always your child."

**Page 3**:
- Illustration: parent holding phone next to a sleeping child with a soft glow
- Headline: "Bedtime, made magical"
- Description: "Read together. Listen to gentle narration. Watch the stars come out."
- CTA: "See your child as the hero" (gold primary button)

### 4.3 F-0: Hero Reveal — photo upload

**Purpose**: collect 1 photo + name + adventure choice without requiring signup.

**Layout (single screen, scrollable)**:
- Top: small back arrow (left) + small skip text-button (right, "Skip for now")
- Display-lg: "See your child in the story"
- Body-md: "No account needed. We'll show you a sneak peek."
- 32px gap
- Photo upload area:
  - 200×200 dashed cream-100 border, radius-xl
  - Centered camera icon + "Tap to add photo"
  - On tap: native photo picker
  - On photo selected: preview shown, with "Change photo" link below
- 24px gap
- Name input field, label "Their name"
- 32px gap
- Eyebrow label: "Tonight's adventure"
- Grid of 6 adventure tiles (3 columns, 2 rows on mobile):
  - Astronaut, Pirate, Chef, Wizard, Explorer, Princess
- Sticky bottom CTA: primary button "Create the magic" (disabled until photo + name + adventure all set)

**Privacy reassurance** (above the CTA, body-sm, text-tertiary):
> "We use this photo only to draw your child as the hero. Original photo deleted within 24 hours."

### 4.4 F-0: Hero Reveal — generation loading

**Purpose**: 15-second wait while RunningHub generates the Hero Reveal.

**Layout**:
- Full-screen indigo-900
- Centered: animated illustration of a closed book glowing with magical light, with stars slowly orbiting
- Below illustration (48px gap): rotating loading messages in Fraunces 500 display-sm:
  - "Imagining your child as a hero..."
  - "Mixing the colors..."
  - "Almost ready..."
- Each message holds for 4-5 seconds, fades to next

### 4.5 F-0: Hero Reveal — the reveal moment

**Purpose**: the emotional peak. Show parent their child as a hero. THIS IS THE CRITICAL CONVERSION SCREEN.

**Layout**:
- Full-screen indigo-900
- Hero image takes 70% of screen (centered), with 32px radius and shadow-glow (gold)
- The image animates in: starts at 0.6 scale + 0 opacity, scales to 1.0 + full opacity over 800ms with easing-magic
- A subtle particle effect of gold dots drifts across the image during reveal
- Below image (24px gap), display-lg: "[Sofia] is ready."
- Body-md: "This is just page 1 of [her] adventure. Sign up free to see the whole story."
- Sticky bottom: 
  - Primary CTA: "Continue [Sofia]'s story — sign up free"
  - Below CTA, ghost button: "Maybe later"

### 4.6 Sign-up screen

**Purpose**: convert the reveal into an account.

**Layout**:
- Top: small back arrow (left)
- Display-md: "Save your magic"
- Body-md: "Continue Sofia's adventure and create unlimited bedtime stories."
- 32px gap
- Stack of auth buttons (each 56px tall, 16px gap between):
  - "Continue with Apple" — black button with Apple logo + text (Apple required style)
  - "Continue with Google" — white button with Google logo + text (Google required style)
  - "Continue with email" — secondary button style
- Below auth buttons (32px gap), body-sm text-tertiary:
  - "By continuing you agree to our [Terms] and [Privacy Policy]."
- Links underlined, gold-500

### 4.7 F-1: Hero Profile setup

**Purpose**: confirm or complete the Hero Card after signup.

**Layout (single screen, scrollable)**:
- Top: progress indicator (3 dots, first is gold)
- Display-md: "About [Sofia]"
- 32px gap
- Hero Reveal image (large circular avatar, 160px, with gold border + glow) centered
- Below image, ghost button: "Regenerate"
- 32px gap
- Form fields (vertical stack, 16px gaps):
  - "Their name" (pre-filled from F-0)
  - "Their age" (segmented control: 3, 4, 5, 6, 7, 8)
  - "Pronouns" (segmented control: he/him, she/her, they/them)
  - "Defining traits" (multi-line text, body-sm placeholder: "e.g. brown wavy hair, blue glasses, freckles")
  - "Story style" (4 art style cards, 2x2 grid, illustrated)
- Sticky bottom: primary button "Continue"

### 4.8 F-1: Anchor validation

**Purpose**: parent confirms the Hero Card matches their child.

**Layout**:
- Top: progress indicator (2nd dot is gold)
- Display-md: "Does this look like Sofia?"
- 32px gap
- Hero anchor image, large hero card style (240px tall, 32px radius)
- 24px gap
- Two side-by-side buttons:
  - Left (50%): secondary "Try again" (ghost, with regen icon)
  - Right (50%): primary "Yes, that's Sofia"
- Below buttons (24px gap), body-sm text-tertiary:
  - "[2 free regenerations remaining]"

### 4.9 Home / "Tonight's Adventure"

**Purpose**: the daily entry point. Big "create tonight's story" CTA.

**Layout**:
- Top bar: small Lullabook wordmark (left) + settings icon (right)
- 32px gap
- Greeting (display-md): "Good evening, [Sofia]" (parent reads it; child cannot read)
- Body-md text-secondary: "Ready for tonight's adventure?"
- 32px gap
- **Hero CTA card** (large, 280px tall, hero card variant):
  - Hero anchor image embedded (left 30%)
  - Right side text: "Tonight's Adventure" (display-sm) + "Create a brand new story" (body-md)
  - Bottom right: arrow icon
- 24px gap
- Section header (display-xs): "Continue reading"
- Horizontal scrolling list of recent stories (story page cards, 168×220)
- 32px gap
- Section header: "Library"
- Vertical grid of all stories (2 columns mobile, 3 tablet)

**Bottom**: Tab bar (Tonight selected)

### 4.10 F-2: Tonight's Adventure setup — kid mode

**Purpose**: the playful, child-driven setup. THE CRITICAL DIFFERENTIATOR.

**Layout**:
- Top bar: "Hand me the phone — for [Sofia]" (body-sm text-tertiary, parent hint) + small back arrow
- Progress indicator (4 dots, first gold)
- Display-lg (Fraunces): the question for this step:
  - Step 1: "Who do you want to be tonight?"
  - Step 2: "Who comes with you?"
  - Step 3: "Where does the adventure happen?"
  - Step 4: "What do you want to find?"
- 24px gap
- Grid of 4 adventure tiles per step (2x2 mobile, 4x1 tablet)
- Each tile: 156×156, illustrated icon, label below
- On tap: scale to 95% + audio chime + auto-advances to next question
- "Next" button only appears if no auto-advance

**Adventure tile illustrations (Step 1 examples)**:
- Astronaut, Pirate, Chef, Wizard, Princess, Vet, Firefighter, Ninja, Mermaid, Robot pilot, Inventor, Paleontologist
- Each ~80×80, watercolor style, warm earth tones

**Optional Step 5 (parent-only, hidden from child)**:
- "Add a teaching moment? (Optional, for grown-ups)"
- Small chips: Bravery, Kindness, Sharing, Honesty, Patience, None

### 4.11 F-3: Story generation loading

**Purpose**: the 60-90 second wait between setup completion and reader. Must feel magical, not boring.

**Layout**:
- Full-screen indigo-900
- Centered: animated scene of a constellation slowly forming, dots connecting into the shape of a hero (changes per story type — astronaut becomes a rocket constellation, etc.)
- Below the constellation (48px gap), Fraunces display-sm rotating messages every 8-10s:
  - "Drawing [Sofia]'s adventure..."
  - "Writing tonight's story..."
  - "Painting the moon..." (or context-specific based on adventure)
  - "Almost ready..."
- Subtle particle effect (slow drifting gold dots)
- Bottom: small "Cancel" ghost button (90% opacity, gives child option to back out if they get impatient)

### 4.12 F-6: Story Reader

**Purpose**: the bedtime experience itself. Premium, immersive, distraction-free.

**Layout (full-screen, no chrome by default)**:
- Page-flip metaphor: pages turn left/right with swipe or tap on edge
- Each page:
  - Top 65%: full-bleed illustration with subtle 32px radius softening at top corners
  - Bottom 35%: indigo-900 background with story text
  - Story text in Fraunces display-xs, text-primary on dark, line-height generous (1.6)
- Bottom-most strip (40px tall):
  - Page indicator dots (gold for current, indigo-200 for others)
  - Tap to reveal full controls (auto-hide after 3 seconds)

**Controls overlay (when revealed)**:
- Top: small X close (left) + favorite heart (right)
- Bottom: audio controls (play/pause, voice selector, speed), centered

**Sleep Mode** (toggle in controls):
- Screen dims gradually over story (each page 5% darker)
- Final page: only bottom 20% lit
- After 60s of last page narration, screen fades fully

**Audio**:
- Auto-play default ON
- Page auto-turns at end of narration with 1.5s pause
- Background ambient (very soft, optional, off by default)

### 4.13 F-7: Library

**Purpose**: browse all of Sofia's adventures.

**Layout**:
- Top bar: "Sofia's Library" (display-md) + filter icon (right)
- Below title: hero counter with avatar — "12 stories" (body-md text-secondary)
- 24px gap
- Filter chips horizontal scroll: "All", "Recent", "Favorites", "By theme"
- 16px gap
- Grid of story page cards (168×220, 2 columns mobile)
- Each card on tap → opens reader at page 1
- Long press → action sheet: Read, Favorite, Share, Delete

**Empty state** (0 stories beyond first):
- Centered illustration: a small empty bookshelf with a glowing star
- Display-sm: "Your adventures begin tonight"
- Body-md: "Tap 'Tonight's Adventure' to create your first story."
- Primary CTA: "Start now"

### 4.14 Paywall — main subscription screen

**Purpose**: convert free users to Weekly or Yearly. Two clear options, one obvious winner.

**Layout (full-screen modal)**:
- Top: small X close (right corner)
- 32px top padding
- Display-lg: "Unlimited bedtime stories"
- Body-md: "for [Sofia], every night"
- 32px gap
- Hero illustration: stack of glowing storybooks
- 32px gap
- Two pricing cards stacked:
  
  **Yearly card** (visually emphasized, gold border):
  - Top right corner: gold pill "Best value — Save 76%"
  - Title: "Yearly" (display-sm)
  - Price: "$99.99/year" (display-md)
  - Subtitle: "$1.92/week"
  - Bullet list (Phosphor checkmarks, gold):
    - "Unlimited stories, every night"
    - "Up to 2 children"
    - "Priority generation"
  
  **Weekly card** (secondary):
  - Title: "Weekly" (display-sm)
  - Price: "$7.99/week" (display-md)
  - Subtitle: "Try free for 3 days"
  - Bullet list:
    - "Up to 3 stories per day"
    - "1 child"
    - "Cancel anytime"

- 24px gap
- Sticky bottom primary button: "Start free trial" (when user taps a card, button text matches card)
- Below button (16px gap): row of 3 small testimonial avatars + body-sm "Loved by 10,000+ parents"
- Body-xs text-tertiary: "Subscriptions auto-renew. Cancel anytime in Settings."
- Two ghost links at bottom: "Restore purchases" | "Terms & Privacy"

### 4.15 Daily cap reached

**Purpose**: gentle, on-brand handling when user hits cap.

**Layout (modal, fills 70% of screen height)**:
- Centered illustration: a sleeping moon character peacefully resting
- Display-sm: "Sofia's adventures rest now"
- Body-md text-secondary: "New stories unlock at midnight 🌙"
- 24px gap
- Primary button: "OK, see you tomorrow"
- Below: ghost link "Want more? Upgrade to Yearly →"

**Tone is critical**: never punitive. Always gentle. The cap is a feature, not a limit.

### 4.16 Settings

**Layout**:
- Top: "Settings" (display-md)
- Sections (each with body-xs eyebrow header):
  
  **Account**:
  - Email (read-only display)
  - "Manage subscription" → opens RevenueCat customer center
  - "Restore purchases"
  
  **Heroes** (if multiple):
  - List of hero avatars + names
  - "Add another hero" (Yearly+ only)
  
  **Story preferences**:
  - "Story language" → modal with language picker
  - "Default art style" → modal with 4 art style cards
  - "Narration voice" → modal with female/male toggle per language
  
  **Reader**:
  - "Auto-play narration" toggle
  - "Sleep mode" toggle
  - "Background music" toggle (default off)
  - "Reading speed" slider (0.75x – 1.25x)
  
  **App**:
  - "Theme" (Auto / Dark / Light)
  - "Notifications" (single bedtime reminder, opt-in)
  
  **Support**:
  - "Help center" → web view
  - "Contact us" → email
  - "Rate Lullabook" → App Store
  
  **Legal**:
  - Terms of Service
  - Privacy Policy
  - "Delete my account" (destructive, opens confirmation flow)

---

## 5. Asset checklist

### 5.1 Illustrations needed (commission or AI-generate)

**Brand illustrations** (2-3 needed):
- Onboarding hero scene 1 (sleeping child + floating book)
- Onboarding hero scene 2 (child as astronaut)
- Onboarding hero scene 3 (parent + child bedtime)
- Empty library state (empty bookshelf with star)
- Daily cap state (sleeping moon character)
- Loading screen — base constellation animation

**Adventure tile icons** (12 for Step 1 of setup):
- Astronaut helmet
- Pirate hat
- Chef hat
- Wizard hat
- Princess crown
- Vet stethoscope
- Firefighter helmet
- Ninja mask
- Mermaid tail
- Robot pilot
- Inventor goggles
- Paleontologist brush

**Companion icons** (6 for Step 2):
- Mom
- Dad
- Dog
- Cat
- Best friend
- Mystery creature

**Location icons** (8 for Step 3):
- Space (planet)
- Jungle (palm)
- Underwater (wave)
- Castle (tower)
- Volcano
- Forest (tree)
- Backyard (house)
- Moon

**Goal icons** (5 for Step 4):
- Treasure chest
- Heart (lost friend)
- Magic crystal (magic thing)
- Gift box (surprise)
- Home

All illustrations: **watercolor + warm earth tones**, transparent PNG @ 3x resolution, ~512×512 source.

### 5.2 Lottie animations (3-4 needed)

- Splash screen star twinkle
- Generation loading constellation forming
- Hero Reveal magical reveal (gold particles)
- Sleep mode wake-up gentle fade

### 5.3 App icon

- 1024×1024 master file
- Concept: a stylized open book with a glowing star above it, deep indigo background, warm gold accent
- Must work at 60×60 (iOS minimum) — keep silhouette simple
- iOS variants: full color, dark mode (iOS 18 spec), tinted

### 5.4 Sounds (very few needed)

- Adventure tile tap chime (~150ms, soft chime, gold-bell quality)
- Hero Reveal magical "shimmer" (~600ms)
- Story page turn rustle (~200ms, paper sound, very subtle)
- Story end "goodnight" cue (~800ms, descending soft tone)
- Background ambient track for Sleep Mode (looping, 60s, very low)

All audio: -18dB normalized, never wakes a sleeping child.

---

## 6. Stitch generation order (recommended)

If using Google Stitch, generate in this order. Each can reference prior outputs.

1. **Set up design system**: paste §2 (tokens) as project styles
2. **Generate splash screen** (4.1) — establishes brand
3. **Generate primary button + text input** (3.1, 3.2) — base interactive components
4. **Generate hero anchor avatar component** (3.5)
5. **Generate adventure tile component** (3.4)
6. **Generate loading screen** (3.7) — establishes magic mood
7. **Generate F-0 photo upload screen** (4.3)
8. **Generate F-0 Hero Reveal** (4.5) — most important screen visually
9. **Generate paywall** (4.14) — most important conversion screen
10. **Generate home screen** (4.9)
11. **Generate setup flow screens** (4.10) — 4 variants for 4 questions
12. **Generate story reader** (4.12) — most complex layout
13. **Generate library** (4.13)
14. **Generate settings + secondary screens** (4.16, 4.15, 4.8, etc.)

For each screen generated, provide Stitch with:
- The full §1 brand essence as context
- The relevant §4.X spec
- 2-3 reference images from `/assets/references/` (mood references like Calm app screenshots)

---

## 7. Visual examples to feed Stitch as references

When prompting Stitch, attach 3-4 of these as reference images:

- **Calm app screenshot** (sleep stories home screen) — for dark mode warmth
- **Lovevery website hero** — for warm parent-friendly tone
- **A Beatrix Potter book scan** — for illustration style
- **Tonies/Yoto product photo** — for soft gentle UI
- **Headspace nighttime mode** — for indigo + gold palette

These should NOT be copied — they're mood guidance only.

---

## 8. What to NOT generate

For clarity, these should be explicitly avoided:

- Avatars of real children (use stylized hero illustrations only)
- Stock photography
- Cartoon characters resembling Disney/Pixar/Nintendo IP
- Bright primary color combinations (Material default)
- Glassmorphism / frosted card effects
- 3D rendered icons (keep flat watercolor for icons)
- Animated illustrations longer than 2 seconds
- Any UI element with sharp corners (radius-md minimum on everything)

---

## 9. Accessibility requirements

The design must support:

- **WCAG AA contrast**: text-primary on background ≥ 4.5:1, large text ≥ 3:1
- **Dynamic type**: all body text scales with iOS Dynamic Type / Android font size settings
- **VoiceOver / TalkBack labels**: every interactive element labeled
- **Focus states**: keyboard / external switch users see clear focus rings (2px gold-500)
- **Reduce motion**: when user has reduce-motion enabled, replace all animations with simple fades
- **Tap targets**: minimum 44×44px (Apple) / 48×48dp (Google) — no exceptions

The story reader specifically:
- Caption track for narration available
- Dyslexia-friendly font option (OpenDyslexic) toggleable in settings
- High contrast mode override

---

## 10. Handoff package contents

When you give this to Stitch or a designer, include:

```
lullabook-design-handoff/
├── ui-design-spec.md             (this document)
├── brand-essence.md              (§1 extracted, for repeat reference)
├── design-tokens.json            (§2 tokens in JSON for Style Dictionary import)
├── references/
│   ├── 01-calm-app-dark.png
│   ├── 02-lovevery-warmth.jpg
│   ├── 03-beatrix-potter-illustration.jpg
│   ├── 04-tonies-product.jpg
│   └── 05-headspace-night.png
├── inspiration-board.pdf         (optional Pinterest-style assembly)
└── prd.md + tech-spec.md         (for additional context)
```

---

*End of design specification. Iterate as Stitch outputs arrive — keep this doc updated with locked screen variants once approved.*
