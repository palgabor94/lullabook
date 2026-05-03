# Lullabook UI Patch — Sprint 1 review

> Reviewed: 12 screenshots after first patch round
> Status: **Sprint 1 ~70% complete** — major v2 modern direction visible
> Next: Sprint 2 polish + remaining P0 fixes

---

## TL;DR — what changed and what's next

**Big wins** (Sprint 1 successes):
1. ✅ Splash wordmark — **still serif italic** (regression check needed — see §1)
2. ✅ Standalone CTAs — **Final Touches "Create story!" is white** (correct!)
3. ✅ **Eyebrow labels added** — "STEP 3 OF 3 · UPLOAD PHOTO", "STEP 2 OF 3 · ABOUT THE HERO", "FREE PREVIEW · NO SIGNUP" — exactly as specified
4. ✅ **Bottom tab bar** — TONIGHT/LIBRARY/SETTINGS with proper gold active state
5. ✅ **Hero Profile age stepper** → segmented control with 3,4,5,6,7,8 — much cleaner
6. ✅ **Library screen** has favorite hearts on cards (top-right glassmorphism circle)

**Still open**:
1. ❌ Splash wordmark **still uses serif italic** font ("Lullabook" with cursive L) — must fix
2. ❌ Home header **"Lullabook" still serif** — same font issue, but in gold
3. ❌ Hero Profile + photo upload buttons **still gold**, not white
4. ❌ Selected tile state (Astronaut, Solo Hero, Fix the rocket) **still uses brown/desaturated background** instead of gold gradient + checkmark
5. ❌ Title typography "A clear photo of G" wraps weirdly because of long heading + variable user name
6. ⚠️ Continue reading carousel on Home — **first card has no image** (book emoji only) while other cards have hero images
7. ⚠️ Library card "Feri's Brave Pirate Voyage" — **same missing image issue**
8. ⚠️ Companion grid mixes real photos (custom companions) with emoji (defaults) — needs visual separation

Overall: **the chrome polish is 70% there**. The remaining 30% is mostly about consistency (selected states everywhere) and that one stubborn serif font on splash + home header.

---

## §1 — Splash & Home wordmark (CRITICAL — STILL NOT FIXED)

**Looking at Image 10 (Home) and the splash from previous session**:

The "Lullabook" wordmark still renders with what looks like **Pacifico, Lobster, or Caveat** — a script/cursive serif. Specifically, the L has a calligraphic curl, and the letters lean italic.

**This was the #1 P0 fix** in the patch document and didn't get applied. Possible causes:

1. **Inter wasn't actually added to pubspec.yaml + assets/fonts/** — the font is missing, so Flutter falls back to a system serif
2. **The Text widget still references the old font family name** — e.g. `fontFamily: 'Pacifico'` or similar, instead of `'Inter'`
3. **Flutter pub get or hot reload wasn't run** after adding the font

**Verification command** to run in your project:

```bash
cd flutter_app
flutter pub get
flutter clean
flutter run
```

**Check the pubspec.yaml**:

```yaml
flutter:
  uses-material-design: true
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

**Check the fonts actually exist**:

```bash
ls -la flutter_app/assets/fonts/
# Should show:
# Inter-Regular.ttf
# Inter-Medium.ttf
# Inter-SemiBold.ttf
# Inter-Bold.ttf
```

If they don't exist, download from [rsms.me/inter/download/](https://rsms.me/inter/download/).

**Then check the splash screen widget**:

```dart
// lib/features/splash/splash_screen.dart
Text(
  'Lullabook',
  style: TextStyle(
    fontFamily: 'Inter',           // ← MUST be 'Inter', not 'Pacifico' or any other
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,   // ← MUST be normal, NOT italic
    fontSize: 36,
    letterSpacing: -0.025 * 36,
    color: Color(0xFFFFB84D),       // gold OR white — pick one and use everywhere
  ),
),
```

**Most likely cause**: someone went to Google Fonts, picked a "decorative" font for the splash, and the team is conflating "looks like a children's book" with "this is the brand." It's not. The brand is **Inter Bold sans-serif modern + warm gold**. This is intentional — it's what makes Lullabook look like Headspace and not like a generic kids' app.

---

## §2 — Home screen review (Image 10)

**What's working well**:
- ✅ Greeting "Good evening, Feri" — bold, proper hierarchy
- ✅ Hero card with portrait + "Adventure →" gold button — clean
- ✅ "Add hero" empty card next to it — good UX, parents understand they can add a second child
- ✅ "Continue reading" carousel header — correct typography
- ✅ Story cards have hero images (forest, beach scenes) rendering correctly
- ✅ Bottom tab bar with TONIGHT/LIBRARY/SETTINGS, gold moon icon active state — exactly per spec
- ✅ "Recent" / "Favourites" tabs at the bottom

**What needs fixing**:

### Issue 2.1: Lullabook wordmark — same serif issue
Same as splash. Must change to Inter Bold, color either gold or white (decision needed — see §1).

### Issue 2.2: First story card has no image (Image 10, also visible in Image 9)
The "Feri's Brave Pirate Voyage" card in "Continue reading" shows only the open-book emoji (📖) — no hero image. Other cards correctly render forest scenes, beach scenes etc.

**Diagnosis**: this is likely the **page 1 fallback** for stories where the cover image hasn't been generated or saved yet. Either:
- Story exists in Firestore but `coverImageUrl` is null
- The story was created before the cover-saving logic was added
- The cover image upload to Firebase Storage failed

**Fix**: 
- In your story repository, when fetching stories, if `coverImageUrl` is null, derive it from `pages[0].imageUrl` (the page 1 illustration is the natural cover)
- Add a fallback during story generation: after Cloud Function generates page 1, copy that image URL to the story's `coverImageUrl` field
- For existing stories without covers, write a one-time migration script

```typescript
// functions/src/scripts/backfill-covers.ts
import { getFirestore } from 'firebase-admin/firestore';

async function backfillCovers() {
  const db = getFirestore();
  const stories = await db.collection('stories').get();
  
  let fixed = 0;
  for (const doc of stories.docs) {
    const story = doc.data();
    if (!story.coverImageUrl && story.pages?.[0]?.imageUrl) {
      await doc.ref.update({
        coverImageUrl: story.pages[0].imageUrl,
      });
      fixed++;
    }
  }
  console.log(`Backfilled ${fixed} story covers`);
}
```

### Issue 2.3: Add eyebrow above greeting
Per the patch, add `TUESDAY · 9:14 PM` (or similar live timestamp) above "Good evening, Feri" — this turns the home into a dashboard moment. Currently missing.

### Issue 2.4: Hero portrait quality
The Feri portrait inside the hero card is great (RunningHub character consistency working). But **the X close button at the top-right of the hero card** is unusual — a hero card shouldn't be dismissable. Why is there an X?

Possibly leftover dev/test UI for "dismiss this hero." **Remove the X**. The hero card is permanent until the user explicitly removes the hero from Settings → Heroes.

---

## §3 — F-0 Create Preview (Image 12)

**This screen is now excellent** — most v2 fixes applied:

✅ "FREE PREVIEW · NO SIGNUP" eyebrow at top — exactly per spec  
✅ Title "See your child / as the hero" — correct hierarchy, two lines  
✅ "We'll show you a sneak peek before any signup." subtitle — perfect  
✅ Privacy text "Photo deleted within 24 hours. We never share your child's image." above CTA — added correctly  
✅ **"Next: Add a photo" button is WHITE** — the only screen where this is correct out of the form CTAs!  
✅ "CHOOSE AN ADVENTURE" + "CHOOSE AN ART STYLE" eyebrows  
✅ "Already have an account? Sign in" at bottom

**Minor remaining issues**:

### Issue 3.1: Adventure tile selected state still brown
"Space Explorer" is selected but uses a flat brown/burgundy background. Should be **gold tint with checkmark badge** per the patch:

```dart
decoration: BoxDecoration(
  color: selected ? Color(0x26FFB84D) : LullabookColors.bgHover,  // 15% gold tint
  border: Border.all(
    color: selected ? LullabookColors.gold500 : LullabookColors.borderSubtle,
    width: selected ? 1.5 : 1,
  ),
  borderRadius: BorderRadius.circular(12),
),
```

Plus a small gold check badge top-right. Same fix applies to art style chips ("Pixar Style" selected).

### Issue 3.2: Adventure list still has "Strategy B" inconsistency
Adventures here: Space Explorer, Ocean Diver, Dragon Rider, Forest Fairy, Treasure Hunter, Time Traveler.

Adventures in Step 1 of kid setup (Image 4): Astronaut, Pirate, Wizard, Princess, Knight, Mermaid, Superhero, Chef, Scientist, Ninja, Explorer, Vet, Inventor, Dino Hunter, Firefighter.

**These don't overlap.** A user picks "Space Explorer" in F-0, then opens kid setup and sees "Astronaut" — same character but different name, confusing.

**Fix**: align them. F-0 should present 6 adventures that match the first 6 kid-setup adventures: **Astronaut, Pirate, Wizard, Princess, Knight, Chef** (or similar — pick the 6 most universal). This is a content/copy fix, not a code fix.

---

## §4 — Hero Profile setup (Image 6) — much improved

**What's working**:
- ✅ "STEP 2 OF 3 · ABOUT THE HERO" eyebrow
- ✅ "Tell us about your hero" title — large, bold, two lines, correct
- ✅ Age segmented control 3,4,5,6,7,8 with selected gold pill — exactly per patch
- ✅ Pronoun chips with selected state having gold border + dark fill
- ✅ Art style chips "Pixar Style" selected
- ✅ Defining traits text input
- ✅ **"Next: Add photo" button is WHITE** — correct!

**Still wrong**:

### Issue 4.1: Selected pronoun chip is brown, not gold-tinted
"They/Them" is selected and shows brown background with gold border. The selected state should use the **15% gold tint** pattern:

```dart
color: Color(0x26FFB84D),  // 15% gold tint background
border: Border.all(color: LullabookColors.gold500, width: 1.5),
```

Same for "Pixar Style" art style chip.

### Issue 4.2: "Defining traits (optional)" placeholder
Looks fine but the patch suggests adding a small helper text below: "Helps us draw [name] consistently across every story." Optional, low priority.

### Issue 4.3: Art style chips wrap to 4 items
"Pixar Style, Watercolor, Flat Modern" on row 1, "Storybook Classic" alone on row 2. Looks awkward. Either:
- Make them 2x2 grid (more visual symmetry)
- Use shorter labels: "Pixar 3D, Watercolor, Flat, Classic" so all 4 fit on one row

---

## §5 — Photo upload (Image 5) — the title bug

**What's working**:
- ✅ "STEP 3 OF 3 · UPLOAD PHOTO" eyebrow added
- ✅ "Front-facing with good lighting works best. Original is deleted within 24 hours." privacy text
- ✅ Camera icon inside dashed gold border zone
- ✅ "Add a photo" + "A clear photo of your child works best" supporting text
- ✅ "Take a photo" link below dashed zone
- ✅ Disabled "Create hero!" button (not yet — see issue below)

**The bug**:

### Issue 5.1: Title broken with single-character name
Title reads:
```
A clear photo of
G
```

Because the user's name is just "G" (one letter), and the title template `"A clear photo of {name}"` wraps onto a second line poorly.

**Fix**: avoid putting the variable name in the title. Use a **fixed title** that's always good, and put the name in the eyebrow or subtitle:

```dart
// Bad (current):
Text("A clear photo of ${heroName}", style: displayXl)

// Good:
Text("STEP 3 OF 3 · ${heroName.toUpperCase()}'s PHOTO", style: eyebrowMd)
Text("A clear photo\nworks best", style: displayXl)  // generic, always 2 lines
```

This way "G's PHOTO" or "SOFIA'S PHOTO" both work fine in the eyebrow, and the main title is always two clean lines.

### Issue 5.2: Camera icon inside upload zone
Currently shows a brown rounded square with gold camera icon. Per the patch:

```dart
Container(
  width: 48, height: 48,
  decoration: BoxDecoration(
    color: Color(0x26FFB84D),  // ← was probably solid brown
    borderRadius: BorderRadius.circular(14),
  ),
  child: Icon(Icons.camera_alt_outlined, color: LullabookColors.gold500, size: 22),
),
```

15% gold tint container, not solid brown. Looks softer.

### Issue 5.3: "Create my hero!" CTA — still gold or still gray?
Looking at Image 11 (the previous flow with "Feri's photo") — the disabled button is gray (correct disabled state). When enabled, it should be **white** (Image 5 scenario where "Create hero!" is the active button).

Confirm with the team: is the enabled state white (good) or still gold (bad)? Hard to tell from the screenshots since both are in disabled state.

---

## §6 — Final Touches (Image 1) — looks great

This screen is **almost perfect**:

✅ "Optional" eyebrow at top  
✅ 5 progress bars (wait — should be 4, see issue below)  
✅ "Any final touches?" title — bold, clean  
✅ "Add a teaching moment" + subtitle layout perfect  
✅ Chips for Bravery/Kindness/Sharing/Honesty/Patience/Friendship/Perseverance/Creativity  
✅ "or type your own..." input field  
✅ **White "Create story!" CTA** — correct!

**Only remaining issue**:

### Issue 6.1: 5 progress bars instead of 4
The progress shows 5 gold dashes at the top. But the kid setup is "Step 4 of 4". So either:
- The progress should show 4 dashes (matching the 4 questions)
- Or 5 dashes if you're counting an additional final-touches step

If the journey is: Step 1 (Who) → Step 2 (Companion) → Step 3 (Where) → Step 4 (Goal) → Final Touches (this screen), then it's actually a 5th step (or "step 4.5"). Then 5 dashes is technically accurate, but conceptually weird.

**Decision needed**: 
- **Option A**: Final touches IS step 5, all 5 dashes filled — make consistent ("Step 5 of 5" header)
- **Option B**: Final touches is the "review/optional" finalizer, separate from the 4-question journey — show 4 dashes filled + 1 different "review" indicator

I'd go with **Option A** for simplicity. Just make it Step 5 of 5.

### Issue 6.2: Chip selected state
None of the teaching moment chips are selected in this screenshot. When a user taps "Bravery", make sure the selected state uses the gold tint + check badge pattern (not brown).

---

## §7 — Kid setup (Image 4) — Step 1 "Who"

**What's working**:
- ✅ "Step 1 of 4" centered subtitle (small, secondary)
- ✅ Progress bar (1/4 filled gold)
- ✅ "Who do you want to be tonight?" — good title
- ✅ 15 emoji-based hero tiles in 3-column grid
- ✅ X close button top-left

**Still wrong**:

### Issue 7.1: Selected tile (Astronaut) — brown background, not gold
Same recurring issue. The selected Astronaut tile shows a brown/burgundy fill with gold border. Should be:
- 15% gold tint background
- 1.5px gold border
- **Gold check badge top-right** (this is the visual anchor that says "this is selected")

### Issue 7.2: Tile gradient depth
The tiles have a slight gradient from top (lighter purple) to bottom (darker). This is fine but could be more subtle — current is fairly noticeable. Reduce gradient intensity to ~5% difference.

### Issue 7.3: No "Continue with Astronaut" CTA visible
The patch suggested a sticky bottom CTA that says "Continue with [selected hero]". Currently the screen relies on auto-advance after tap. Either is fine UX — but if you keep auto-advance, **add a tiny haptic feedback** on tap so the user knows the choice registered:

```dart
import 'package:flutter/services.dart';

onTap: () {
  HapticFeedback.selectionClick();
  setState(() => _selectedHero = hero);
  // Then navigate to next step after 200ms delay
  Future.delayed(Duration(milliseconds: 200), () {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CompanionStep()));
  });
}
```

---

## §8 — Companion screen (Image 3) — mixed progress

**What's working**:
- ✅ Step 2 of 4 indicator
- ✅ "Who comes with you?" title
- ✅ 3x3 grid layout
- ✅ Solo Hero with star + gold border = correctly selected
- ✅ Some companions now use **real photos** (Apa = real photo of dad, Gabor = real photo) — interesting choice, see issue below

**Issues**:

### Issue 8.1: Mixed photo styles needs visual unification
The companion grid contains a mix of standard emoji-based companions (Anya, Testvér, Kutya, Cica, Nagymama, Papa) and **custom user-added companions with real photos** (Apa, Gabor — these are additional heroes/companions added by the user with actual portrait photos).

This is **the right product behavior** — the custom companion feature is a real differentiator. But mixing real photos and emoji in the same grid is visually inconsistent.

**Two options to harmonize**:

**Option A (recommended for V1)**: Visually separate the two types into distinct sections.

```
Default companions (emoji-based)
┌─────┬─────┬─────┐
│ ⭐  │ 👩  │ 🧒  │
│Solo │Anya │Test │
│Hero │     │vér  │
├─────┼─────┼─────┤
│ 🐶  │ 🐱  │ 👵  │
│Kutya│Cica │Nagy │
│     │     │mama │
└─────┴─────┴─────┘

Your family (custom)
┌─────┬─────┬─────┐
│ 📷  │ 📷  │  +  │
│ Apa │Gabor│ Add │
└─────┴─────┴─────┘
```

This visually communicates: "left section is the standard companions; right section is YOUR family members."

**Option B**: Apply consistent visual frame to all custom companions — circular avatar with gold border for custom photos, square emoji for defaults. Same grid but type signaled by frame style.

### Issue 8.2: Selected state — Solo Hero
Solo Hero is selected with brown background + gold border. Same recurring issue: should be **gold tint background (15%) + gold border + gold check badge top-right** per the unified selected-state pattern.

### Issue 8.3: Custom companion add affordance
Currently no visible way to add a new custom companion from this screen. If "Apa" and "Gabor" were added elsewhere (settings? hero profile?), great. But if a parent wants to add another family member during the setup flow, they need an "+ Add family member" tile.

For V1, it's fine if custom companions are managed in Settings → Heroes/Family. For V1.1, consider adding inline `+` tile for faster discoverability.

---

## §9 — Goal screen (Image 2) — Step 4 "What do you want to find?"

**What's working**:
- ✅ Step 4 of 4 indicator
- ✅ Progress 4/4 (all gold)
- ✅ "What do you want to find?" — adventure-specific question
- ✅ Goals are space-themed (Fix the rocket, Discover a planet, Save space station, Befriend aliens, Find a lost star, Stop a meteor, Rescue a lost crew, Find the space crystal) — **excellent contextual variation based on chosen adventure (Astronaut)**

**This is brilliant**: the goals are dynamically tailored to the chosen adventure. Astronaut → space-themed goals. Pirate would get treasure/sea-themed goals. This was implied in the spec but seeing it implemented is great.

**Issues**:
- Same selected state brown issue (Fix the rocket selected with burgundy fill)
- Same potential haptic feedback recommendation

---

## §10 — Story Reader (Image 7) — minor polish only

**Already excellent** — this screen represents the heart of the product:

✅ Full-bleed pirate ship illustration with proper character consistency  
✅ Story text below in serif font (Fraunces — correct, this is the ONE place serif works)  
✅ "Listen" button as gold pill — works  
✅ Page indicator dots at bottom (gold for current, gray for others)

**Minor improvements**:

### Issue 10.1: Missing chrome controls
Per the patch, add at the top:
- **X close button** (left, glassmorphism background)
- **Page count "1 / 8"** (center, glassmorphism pill)
- **Favorite heart** (right, glassmorphism background, gold when favorited)

These should be subtle (`bgBase.withOpacity(0.6)` + `backdrop-blur`) so they don't compete with the illustration.

### Issue 10.2: Dialogue highlighting
The text reads:
> Apa climbed aboard, smiling. "Are you ready to sail, Captain?" he asked. Feri hesitated—he liked being the only captain on his ship.

The dialogue `"Are you ready to sail, Captain?"` should render in **gold italic Fraunces** to differentiate from narration. Per the patch:

```dart
RichText(
  text: TextSpan(
    style: storyTextStyle,  // serif white
    children: [
      TextSpan(text: "Apa climbed aboard, smiling. "),
      TextSpan(
        text: '"Are you ready to sail, Captain?"',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: LullabookColors.gold500,
          fontWeight: FontWeight.w500,
        ),
      ),
      TextSpan(text: " he asked. Feri hesitated..."),
    ],
  ),
),
```

To detect dialogue automatically, parse `"..."` patterns from the story text. Or have GPT-4o output structured JSON with `[{type: "narration", text: "..."}, {type: "dialogue", text: "..."}, ...]`.

### Issue 10.3: Listen button styling
Currently a pill with gold play icon + gold "Listen" text on dark background. Could be slightly cleaner with white text:

```dart
Row(
  children: [
    Icon(Icons.play_arrow, color: gold500, size: 18),
    SizedBox(width: 8),
    Text('Listen', style: TextStyle(
      color: textPrimary,  // ← white, not gold (better contrast)
      fontWeight: FontWeight.w600,
    )),
  ],
),
```

---

## §11 — Library (Image 9) — looking great

**What's working**:
- ✅ "Continue reading" carousel up top with story illustrations
- ✅ "Library" header with "Recent" / "Favourites" filter chips
- ✅ 2-column story grid with illustrations + favorite hearts top-right
- ✅ "8 pages" subtitle on each card
- ✅ Bottom tab bar with LIBRARY active (gold filled book icon)

**Minor issues**:

### Issue 11.1: First card no image (same as home)
"Feri's Brave Pirate Voyage" shows the open-book emoji 📖 instead of a hero illustration. Same root cause as the home screen.

### Issue 11.2: Filter chip "Recent" selected state
"Recent" is selected with gold border outlining the pill. This is good but should also have a subtle gold tint background to match the rest of the app's selected state pattern:

```dart
// Selected filter chip
Container(
  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  decoration: BoxDecoration(
    color: gold500,  // ← solid gold for filter chips (more emphasis than other chips)
    borderRadius: BorderRadius.circular(10),
  ),
  child: Text('Recent', style: TextStyle(
    color: bgBase,  // dark indigo on gold
    fontWeight: FontWeight.w700,
  )),
),
```

For filter chips, full gold fill is fine (different from form chips which use 15% tint).

---

## §12 — Settings (Image 8) — almost perfect

This screen looks clean and professional. The Sprint 1 changes mostly didn't touch this, but it was already correct.

**What's working**:
- ✅ Section eyebrows (ACCOUNT, STORY PREFERENCES, READER, APP)
- ✅ Account row with email + "Free plan" subtitle
- ✅ Settings rows with chevron arrows
- ✅ Toggle switches for Auto-play / Sleep mode (gold ON) and Background music (gray OFF)

**Polish to apply**:

### Issue 12.1: Toggle visual consistency
Auto-play and Sleep mode toggles look slightly different from Background music (Background music shows a more "OFF" white circle). Make all three use the same `LullabookSwitch` component from the patch:

```dart
// All three toggles use this:
LullabookSwitch(
  value: setting.value,
  onChanged: setting.onChanged,
)
```

### Issue 12.2: Subscription tier badge missing
The Account row should show a "FREE" pill on the right. Currently shows just text "Free plan" as subtitle. Per patch:

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: Color(0x26FFB84D),  // 15% gold
    borderRadius: BorderRadius.circular(6),
  ),
  child: Text('FREE',
    style: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 10,
      letterSpacing: 0.04,
      color: gold500,
    ),
  ),
),
```

This sets up the pattern for when users upgrade to "WEEKLY" or "YEARLY" — same visual treatment, just different label.

### Issue 12.3: Section grouping (still not applied)
Each setting row is currently in its own card with margin between them. The patch suggested grouping adjacent rows in a single rounded container with internal dividers (iOS Settings style):

```
ACCOUNT
┌─────────────────────────────┐
│ 3pgabor@gmail.com    FREE   │
├─────────────────────────────┤
│ Manage subscription      >  │
├─────────────────────────────┤
│ Restore purchases        >  │
└─────────────────────────────┘
```

This collapses 3 separate cards into 1 visually-cohesive group. Lower priority but worth doing in Sprint 2.

---

## Sprint 2 — recommended priority order

Based on what's still open from Sprint 1 + new issues found:

### Day 1 (high impact, low effort)
1. **Fix Inter font on splash + home wordmark** (the #1 P0 — must be done first)
2. **Fix story cover image fallback** for Continue Reading + Library cards
3. **Fix title template** — change `"A clear photo of ${name}"` to fixed title with name in eyebrow

### Day 2 (consistency pass)
4. **Selected state component** — refactor all selected tile/chip states to use gold tint + check badge pattern. One reusable widget, applied everywhere.
5. **Hero Profile + Photo upload buttons** — change to white if any remain gold
6. **Companion grid visual separation** — split default companions and custom family members into distinct sections

### Day 3 (story reader chrome)
7. **Story Reader top controls** — close X, page count, favorite heart in glassmorphism overlay
8. **Dialogue highlighting** in story text (gold italic Fraunces)
9. **Backend prompt update** for GPT-4o to output structured story segments (or regex parser for `"..."`)

### Day 4 (settings + polish)
10. **Toggle component** unification — single `LullabookSwitch` everywhere
11. **Subscription badge** in Account row
12. **Section grouping** in Settings (iOS-style)

### Day 5 (testing + edge cases)
13. **Empty Library state** — when user has 0 stories
14. **Daily cap reached state** — when user hits the per-day limit
15. **Generation loading state** — animated star/orb with rotating messages
16. **Error states** — story generation failed, network offline, etc.

---

## What you should genuinely celebrate

**The pirate ship Story Reader (Image 7) is the heart of your product** — and it's beautiful. The character consistency between Feri across multiple stories (forest scene, beach scene, pirate ship) is **textbook RunningHub working perfectly**. This is the part that competitors can't replicate without your tech stack.

The Sprint 1 fixes show real progress:
- Eyebrow labels everywhere = modern dashboard feel
- F-0 Create Preview is now production-quality
- Hero Profile age stepper is elegant
- The whole app reads as **premium consumer wellness app** (the v2 direction goal)

The remaining ~30% of fixes are real, but they're polish on top of an app that **fundamentally works**. You've already proven the hard part — image generation, character consistency, end-to-end story creation — works at production quality.

Ship Sprint 2 fixes and you have a beta-ready V1.

---

## One concrete next step

Run this in your project root **now**, before anything else:

```bash
cd flutter_app
ls assets/fonts/
```

If you see Inter-*.ttf files: the fonts ARE there, but the splash widget probably points to the wrong family name. Search the codebase for `Pacifico`, `Lobster`, `Caveat`, `Dancing Script`, or whatever decorative font is currently used:

```bash
grep -r "fontFamily" lib/ | grep -v Inter | grep -v Fraunces
```

Anything that's NOT Inter or Fraunces in `fontFamily` → must change.

If you DON'T see Inter-*.ttf in assets/fonts/: download from [rsms.me/inter/download/](https://rsms.me/inter/download/) and add to pubspec.yaml per §1.

Then `flutter clean && flutter pub get && flutter run`. The wordmark will fix itself.

That single change is **the most impactful fix you can make today** — it's the difference between "kids app traditional" and "premium consumer modern."
