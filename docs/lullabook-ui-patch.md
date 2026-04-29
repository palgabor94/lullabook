# Lullabook UI Patch — v1 → v2 Modern Direction

> Companion to `lullabook-ui-design-spec.md` v2.0
> Purpose: Concrete fixes to bring current Flutter implementation in line with v2 modern direction
> Scope: 10 screens reviewed in current state
> Priority: P0 (critical, fix this week) → P1 (important, fix this sprint) → P2 (polish, fix when time)

---

## TL;DR — top 5 fixes

If you only do 5 things, do these. They give you 80% of the visual upgrade for 20% of the effort:

1. **P0: Splash wordmark** — change italic serif to Inter Bold sans-serif
2. **P0: Standalone form CTAs** — change gold buttons to white buttons (Cash App pattern)
3. **P0: Replace emoji-tiles with custom SVG icons** OR commit to emoji and improve their presentation
4. **P1: Add eyebrow labels** to all major screens ("STEP 1 OF 4", "FREE PREVIEW", "SOFIA · 12 STORIES")
5. **P1: Tighten title typography** — letter-spacing -0.025em, weight 700 on all display sizes

---

## Design tokens — single source of truth

Before patching, lock these as constants in your Flutter theme. The current implementation looks like it's using mostly correct values but probably scattered across files:

```dart
// lib/core/theme/lullabook_colors.dart
class LullabookColors {
  // Surface
  static const bgBase = Color(0xFF0F0B1F);
  static const bgElevated = Color(0xFF1A1335);
  static const bgCard = Color(0xFF1F1A3D);
  static const bgHover = Color(0x0AFFFFFF);  // 4% white

  // Accent
  static const gold300 = Color(0xFFFFE5A8);
  static const gold500 = Color(0xFFFFB84D);
  static const gold700 = Color(0xFFD89020);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xB3FFFFFF);  // 70% white
  static const textTertiary = Color(0x80FFFFFF);   // 50% white
  static const textDisabled = Color(0x66FFFFFF);   // 40% white
  static const textFaint = Color(0x4DFFFFFF);      // 30% white

  // Border
  static const borderSubtle = Color(0x0FFFFFFF);   // 6% white
  static const borderDefault = Color(0x1AFFFFFF);  // 10% white
  static const borderStrong = Color(0x26FFFFFF);   // 15% white
}

// lib/core/theme/lullabook_typography.dart
class LullabookTypography {
  // Display sizes — Inter Bold
  static const displayXl = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 36 / 32,
    letterSpacing: -0.025 * 32,  // -0.025em → pixels
    color: Color(0xFFFFFFFF),
  );

  static const displayLg = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 32 / 28,
    letterSpacing: -0.025 * 28,
    color: Color(0xFFFFFFFF),
  );

  // Eyebrow — uppercase, letter-spaced
  static const eyebrowMd = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 14 / 11,
    letterSpacing: 0.12 * 11,
    color: Color(0xFFFFB84D),
  );

  static const eyebrowSm = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 11,
    height: 14 / 11,
    letterSpacing: 0.08 * 11,
    color: Color(0x80FFFFFF),
  );
}
```

Use `Theme.of(context).extension<LullabookTheme>()` everywhere instead of hardcoding values.

---

## Screen-by-screen patches

### Screen 1: Splash (Image 10) — P0

**Current state**: Star icon + italic serif "Lullabook" + tagline.

**What's wrong**:
- ❌ Font is **italic serif** (looks like Fraunces or Pacifico) — this is the v1 direction
- ❌ Wordmark "looks dated" — too storybook, not modern enough
- ✅ Background color correct (#0F0B1F)
- ✅ Star icon color correct (#FFB84D)
- ✅ Tagline correct
- ✅ Star + wordmark composition correct

**Fix**:

```dart
// Splash screen wordmark
Text(
  'Lullabook',
  style: TextStyle(
    fontFamily: 'Inter',           // ← was: 'Fraunces' or similar
    fontWeight: FontWeight.w700,   // ← was: probably w400 italic
    fontStyle: FontStyle.normal,   // ← was: italic
    fontSize: 36,
    letterSpacing: -0.025 * 36,    // tight modern spacing
    color: LullabookColors.gold500,  // keep gold or move to white
  ),
),
```

**Decision point**: The wordmark color. Currently gold. The v2 spec recommends **white wordmark with gold star icon** for splash, because:
- White = more modern, more confident
- Gold star already provides the warmth
- Reading "Lullabook" in white against dark = premium consumer app feeling

But **gold wordmark also works** if you want stronger brand recognition. Either is acceptable. **Pick one and stick with it across all screens** (splash + home header).

**Add bundled font**: ensure Inter is included in `pubspec.yaml`:

```yaml
flutter:
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
    - family: Fraunces
      fonts:
        - asset: assets/fonts/Fraunces-Regular.ttf
          weight: 400
        - asset: assets/fonts/Fraunces-Medium.ttf
          weight: 500
```

Download Inter from [rsms.me/inter](https://rsms.me/inter/) and Fraunces from [Google Fonts](https://fonts.google.com/specimen/Fraunces).

---

### Screen 2: F-0 Create Preview (Image 9) — P0

**Current state**: Title + name field + adventure tiles + art style chips + gold "Next: Add a photo" button.

**What's wrong**:
- ❌ Adventure set is wrong (Space Explorer, Ocean Diver, Dragon Rider, Forest Fairy, Treasure Hunter, Time Traveler) — should match the kid setup tiles for consistency (Astronaut, Pirate, Wizard, Princess, etc.)
- ❌ "Next: Add a photo" CTA is **gold** — should be **white** per v2 spec
- ❌ Missing eyebrow label "FREE PREVIEW · NO SIGNUP"
- ❌ Title is plain "Create your preview" — should be "See your child as the hero" or similar emotional copy
- ❌ Missing privacy reassurance text above CTA
- ✅ Background, layout, color tokens otherwise correct
- ✅ "Already have an account? Sign in" placement correct

**Fix**:

```dart
// At the top, above the name field:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'FREE PREVIEW · NO SIGNUP',
      style: LullabookTypography.eyebrowMd,  // gold, 0.12em letter-spacing
    ),
    SizedBox(height: 8),
    Text(
      'See your child\nas the hero',
      style: LullabookTypography.displayXl,  // 32px Inter 700, -0.025em
    ),
    SizedBox(height: 8),
    Text(
      'We\'ll show you a sneak peek before any signup.',
      style: TextStyle(
        fontSize: 14,
        color: LullabookColors.textTertiary,
        height: 1.5,
      ),
    ),
    SizedBox(height: 28),
    // ... existing form fields
  ],
),
```

**Adventure tile alignment** — pick ONE of these strategies:

**Strategy A (recommended)**: Make F-0 adventures match kid setup adventures.

Reasoning: cognitive load. If the user sees "Space Explorer" in the preview but "Astronaut" in the kid setup, they wonder if these are different things. Use the same vocabulary.

Update F-0 adventure tiles to: **Astronaut, Pirate, Wizard, Princess, Knight, Mermaid** (top 6 most universal).

**Strategy B**: Keep them different but rename.

Reasoning: F-0 is targeted at parents (more sophisticated names allowed), kid setup is targeted at kids (simpler names). 

Then F-0: "Space Explorer, Ocean Diver, Dragon Rider, Forest Fairy, Treasure Hunter, Time Traveler" stays.
Kid setup: simpler emoji-based "Astronaut, Pirate, Wizard, Princess..."

**Pick Strategy A for v1.** Less complexity to ship, less localization to maintain.

**Primary CTA fix**:

```dart
// "Next: Add a photo" button
Container(
  width: double.infinity,
  height: 54,
  child: ElevatedButton(
    onPressed: ...,
    style: ElevatedButton.styleFrom(
      backgroundColor: LullabookColors.textPrimary,  // ← WHITE, not gold
      foregroundColor: LullabookColors.bgBase,        // ← dark indigo text
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),  // ← was probably 16 or 20
      ),
      elevation: 0,
    ),
    child: Text(
      'Next: Add a photo',
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 15,
        letterSpacing: -0.01 * 15,
      ),
    ),
  ),
),
```

**Add privacy text above CTA**:

```dart
SizedBox(height: 14),
Text(
  'Photo deleted within 24 hours.\nWe never share your child\'s image.',
  style: TextStyle(
    fontSize: 11,
    color: LullabookColors.textDisabled,
    height: 1.5,
  ),
  textAlign: TextAlign.center,
),
SizedBox(height: 14),
// Then the white CTA button
```

---

### Screen 3: Hero Profile Setup (Image 7) — P0

**Current state**: Name field + age stepper + pronouns + traits + art style + gold "Next: Add photo" button.

**What's wrong**:
- ❌ Title "Your child's hero" is good but **missing eyebrow label** "STEP 2 OF 3 · ABOUT THE HERO"
- ❌ No progress dots/bars at top
- ❌ Age stepper uses -/+ controls instead of segmented control (cleaner, harder to mis-tap)
- ❌ Selected pronoun "They/Them" uses **brown background** — should be **gold #FFB84D** with dark text
- ❌ Selected art style "Pixar Style" same brown selection issue
- ❌ "Next: Add photo" CTA is **gold** — should be **white**
- ✅ Layout, spacing, fields otherwise correct
- ✅ Background, colors mostly correct

**Fix — add progress indicator + eyebrow**:

```dart
// At the very top, replace just the simple back button row with:
Padding(
  padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(),
          Row(
            children: List.generate(3, (i) => Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              width: 24,
              height: 3,
              decoration: BoxDecoration(
                color: i == 1 ? LullabookColors.gold500 : LullabookColors.borderStrong,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
          ),
          SizedBox(width: 36),  // visual balance
        ],
      ),
      SizedBox(height: 24),
      Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('STEP 2 OF 3 · ABOUT THE HERO',
              style: LullabookTypography.eyebrowMd),
            SizedBox(height: 8),
            Text('Tell us about\nEh',  // dynamic name
              style: LullabookTypography.displayXl),
          ],
        ),
      ),
    ],
  ),
),
```

**Fix — age stepper to segmented control**:

The current `- 5 +` stepper UI is fine functionally but feels old-school. Convert to a segmented row of age buttons:

```dart
// Age section
Text('AGE', style: LullabookTypography.eyebrowSm),
SizedBox(height: 8),
Row(
  children: [3, 4, 5, 6, 7, 8].map((age) {
    final selected = _selectedAge == age;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: GestureDetector(
          onTap: () => setState(() => _selectedAge = age),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? LullabookColors.gold500 : LullabookColors.bgHover,
              border: Border.all(
                color: selected ? LullabookColors.gold500 : LullabookColors.borderSubtle,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              age.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13,
                color: selected ? LullabookColors.bgBase : LullabookColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }).toList(),
),
```

**Fix — selected chip color**:

The selected state uses a desaturated brown (looks like ~#3D2A20 or similar). This is wrong. The selected state must be **either**:
- Gold #FFB84D background with dark indigo text (strong selection emphasis)
- OR semi-transparent gold tint `Color(0x26FFB84D)` (15% gold) with gold border + white text

For pronouns and art style, use the second variant (it's lighter, less aggressive):

```dart
Container(
  decoration: BoxDecoration(
    color: selected
      ? Color(0x26FFB84D)  // 15% gold tint
      : LullabookColors.bgHover,
    border: Border.all(
      color: selected ? LullabookColors.gold500 : LullabookColors.borderSubtle,
      width: selected ? 1.5 : 1,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  // ... text inside, white when selected, secondary when not
),
```

**Fix — Next CTA**: same as Screen 2, change to white background with dark text.

---

### Screen 4: Photo Upload (Image 6) — P0

**Current state**: "Eh's photo" title + dashed border upload zone + "Take a photo" link + disabled gray "Create hero!" button.

**What's wrong**:
- ❌ Title "Eh's photo" is plain — needs eyebrow "STEP 3 OF 3 · UPLOAD PHOTO" + better title
- ❌ Disabled CTA is gray — when enabled, must be **white**, not gold
- ❌ Upload zone border is **gold dashed** — could be lighter, less attention-grabbing
- ❌ Camera icon inside upload zone is **gold** — fine but could be smaller
- ❌ Missing AI / privacy reassurance below CTA
- ✅ Layout, spacing otherwise correct

**Fix**:

```dart
// Header section
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        BackButton(),
        Spacer(),
        // progress indicator (3 of 3, all filled)
        Row(children: List.generate(3, (i) => /* gold dot */)),
        Spacer(),
      ],
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STEP 3 OF 3 · UPLOAD PHOTO',
            style: LullabookTypography.eyebrowMd),
          SizedBox(height: 8),
          Text('A clear photo of\n${heroName}',
            style: LullabookTypography.displayXl),
          SizedBox(height: 8),
          Text(
            'A front-facing photo with good lighting works best. We use this only as visual reference — original is deleted within 24 hours.',
            style: TextStyle(
              fontSize: 14,
              color: LullabookColors.textTertiary,
              height: 1.5,
            ),
          ),
        ],
      ),
    ),
  ],
),
```

**Fix — upload zone**:

```dart
DottedBorder(  // pub.dev/packages/dotted_border
  color: LullabookColors.gold500.withOpacity(0.4),  // ← was probably solid gold
  strokeWidth: 1.5,
  dashPattern: [6, 4],
  borderType: BorderType.RRect,
  radius: Radius.circular(18),
  child: Container(
    width: double.infinity,
    aspectRatio: 1.4,  // ← was probably square; 1.4 is more pleasant
    color: Color(0x0AFFFFFF),  // 4% white tint inside
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0x26FFB84D),  // 15% gold
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.camera_alt_outlined,
              color: LullabookColors.gold500,
              size: 22,
            ),
          ),
          SizedBox(height: 10),
          Text('Add a photo', style: ...),
          SizedBox(height: 4),
          Text('A clear photo of your child works best',
            style: ..., color: textTertiary),
        ],
      ),
    ),
  ),
),
```

**Fix — CTA**:

```dart
ElevatedButton(
  onPressed: photoSelected ? _onCreateHero : null,
  style: ElevatedButton.styleFrom(
    backgroundColor: photoSelected
      ? LullabookColors.textPrimary  // ← white when enabled
      : Color(0x1AFFFFFF),           // ← 10% white when disabled
    disabledBackgroundColor: Color(0x1AFFFFFF),
    foregroundColor: LullabookColors.bgBase,
    disabledForegroundColor: LullabookColors.textDisabled,
    // ...
  ),
  child: Text('Create hero!', ...),
),
```

---

### Screen 5: Home / Tonight (Image 8) — P1

**Current state**: "Lullabook" header in gold italic serif + "Good evening, Feri" + Hero card + "Add hero" empty card + Continue reading horizontal carousel + Recent/Favourites tabs + bottom tab bar.

**What's wrong**:
- ❌ "Lullabook" header is **italic serif gold** — should match splash, so Inter Bold (white or gold based on splash decision)
- ❌ Settings icon top-right could be slightly larger and inside a rounded container for better tap target
- ❌ "Good evening, Feri" title weight and letter-spacing could be tighter
- ❌ Hero card "Adventure →" button is gold — fine, but layout could be cleaner
- ❌ Bottom tab bar text "TONIGHT/LIBRARY/SETTINGS" — labels are correct, but icons are very small (20px) — should be 22-24px for better hit targets
- ❌ "Library" + "Recent/Favourites" filter chips at the bottom feel disconnected from the main carousel above
- ✅ Color palette mostly correct
- ✅ Layout structure works
- ✅ Story carousel covers look great

**Fix — header**:

```dart
// Top app bar
Padding(
  padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Lullabook',
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: -0.02 * 18,
          color: LullabookColors.textPrimary,  // OR gold500, match splash
        ),
      ),
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: LullabookColors.bgHover,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.settings_outlined,
          color: LullabookColors.textPrimary, size: 18),
      ),
    ],
  ),
),
```

**Fix — greeting**:

```dart
Padding(
  padding: EdgeInsets.symmetric(horizontal: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('TUESDAY · 9:14 PM', style: LullabookTypography.eyebrowSm),
      SizedBox(height: 6),
      Text('Good evening,\nFeri',
        style: LullabookTypography.displayXl.copyWith(
          height: 1.1,  // tighter line height for 2-line greeting
        ),
      ),
    ],
  ),
),
```

The eyebrow `TUESDAY · 9:14 PM` is a small but powerful add — turns the home screen into a "dashboard moment" instead of a generic landing.

**Fix — hero CTA card**:

The current implementation has the hero card split into two columns (Feri's portrait left, Add hero right). Per v2 spec, the **primary action should be one wide gold-gradient card** with hero portrait inline:

```dart
// Hero CTA — one wide card with internal layout
Container(
  margin: EdgeInsets.symmetric(horizontal: 20),
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        LullabookColors.gold500,
        Color(0xFFE89730),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
  ),
  child: Row(
    children: [
      // Hero portrait (left)
      Container(
        width: 64, height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: LullabookColors.bgBase, width: 2),
          image: DecorationImage(
            image: NetworkImage(heroPortraitUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(width: 16),
      // Text (middle, expanded)
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TONIGHT',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 0.08 * 11,
                color: LullabookColors.bgBase.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 4),
            Text('Start tonight\'s\nadventure',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 22,
                height: 1.1,
                letterSpacing: -0.02 * 22,
                color: LullabookColors.bgBase,
              ),
            ),
            SizedBox(height: 4),
            Text('~90 seconds',
              style: TextStyle(
                fontSize: 13,
                color: LullabookColors.bgBase.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
      // Arrow circle (right)
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: LullabookColors.bgBase,
        ),
        child: Icon(Icons.arrow_forward,
          color: LullabookColors.gold500, size: 16),
      ),
    ],
  ),
),
```

The "Add hero" empty slot moves to a smaller secondary card below or to a "+ Add" button in the hero portrait area.

**Fix — bottom tab bar**:

```dart
// Increase icon size from ~20 to 22, and improve spacing
BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: LullabookColors.bgBase.withOpacity(0.95),
  selectedItemColor: LullabookColors.gold500,
  unselectedItemColor: LullabookColors.textDisabled,
  selectedLabelStyle: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 9,
    letterSpacing: 0.06 * 9,
  ),
  unselectedLabelStyle: TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 9,
    letterSpacing: 0.06 * 9,
  ),
  iconSize: 22,
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.bedtime_outlined), label: 'TONIGHT'),
    BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'LIBRARY'),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
  ],
),
```

**Note**: I changed "SETTINGS" to "PROFILE" to match the v2 spec. Settings can still live inside the Profile screen as a section — but the tab label "PROFILE" is friendlier.

---

### Screen 6: Story Reader (Image 5) — P1

**Current state**: Pirate ship illustration top + serif story text bottom + gold "Listen" button + page dots.

**What's mostly right**:
- ✅ Illustration takes correct proportion (~60-65%)
- ✅ Story text below in serif font (Fraunces should be the choice — this is the ONE place serif is correct in v2)
- ✅ Page dots at bottom centered
- ✅ Status bar / chrome correctly hidden style

**What's wrong**:
- ❌ "Listen" button is in a **rounded pill** with gold play icon and gold text — should be more subtle, perhaps just a play icon or smaller pill
- ❌ Quote dialogue isn't differentiated visually (should be **gold italic** per spec)
- ❌ Missing close X button top-left
- ❌ Missing favorite heart top-right
- ❌ Missing page count "4 / 8" at top-center

**Fix — controls overlay (top)**:

```dart
// Stack on top of the image
Positioned(
  top: 16,
  left: 16,
  right: 16,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Close X
      _glassButton(
        icon: Icons.close,
        onTap: () => Navigator.pop(context),
      ),
      // Page count
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: LullabookColors.bgBase.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${currentPage} / ${totalPages}',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.08 * 10,
            color: Colors.white,
          ),
        ),
      ),
      // Favorite heart
      _glassButton(
        icon: isFavorite ? Icons.favorite : Icons.favorite_border,
        iconColor: LullabookColors.gold500,
        onTap: _toggleFavorite,
      ),
    ],
  ),
),
```

**Fix — story text with dialogue highlighting**:

The current implementation likely uses a single Text widget. To highlight dialogue in gold italic, use RichText or split the story into segments:

```dart
// In your StoryPage data model, segment the text:
class StoryPageText {
  final List<StorySegment> segments;
}

class StorySegment {
  final String text;
  final bool isDialogue;
}

// In the rendering:
Padding(
  padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
  child: RichText(
    text: TextSpan(
      style: TextStyle(
        fontFamily: 'Fraunces',  // ← serif HERE only
        fontWeight: FontWeight.w400,
        fontSize: 17,
        height: 1.6,
        letterSpacing: -0.005 * 17,
        color: LullabookColors.textPrimary,
      ),
      children: page.segments.map((seg) => TextSpan(
        text: seg.text,
        style: seg.isDialogue
          ? TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: LullabookColors.gold500,  // ← dialogue gold italic
            )
          : null,
      )).toList(),
    ),
  ),
),
```

Have GPT-4o output the dialogue wrapped in `"quotes"` and your story page parser detects quotes to flag dialogue segments. Or have GPT output structured JSON with `[{type: "narration"}, {type: "dialogue"}, ...]`.

**Fix — Listen button**:

The current rounded pill gold button is fine but feels like it competes with the story. Make it smaller and less prominent, or convert to a circular icon button:

```dart
// Bottom-left corner, smaller button
Padding(
  padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: LullabookColors.bgCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.play_arrow, color: LullabookColors.gold500, size: 18),
            SizedBox(width: 8),
            Text('Listen', style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: LullabookColors.textPrimary,  // ← was gold; now white reads better
            )),
          ],
        ),
      ),
    ],
  ),
),
```

Or hide the Listen button entirely until the user taps the screen — like a video player. Tap once to reveal controls.

---

### Screen 7: Kid Setup — Step 1 (Image 3) — P0

**Current state**: 15 emoji-based hero tiles in a 3-column grid (Astronaut selected with gold border).

**Critical decision point**: **Emojis or custom SVG icons?**

**Pros of keeping emojis (current)**:
- Zero asset work — ship faster
- Universally recognizable
- Auto-adapts to platform conventions (Apple emoji on iOS, Google emoji on Android)
- No localization issues

**Cons of emojis**:
- Looks like a placeholder, not a polished consumer app
- Doesn't match the v2 modern direction (which calls for custom watercolor illustrations)
- Visual style inconsistent across platforms (Apple's astronaut vs Google's are different)
- Premium apps don't use emojis as primary visual content

**My recommendation**: **Ship v1 with emojis, plan custom icons for v1.1 (Week 11-12)**. The emojis are honestly fine for MVP launch. They'll save you 2 weeks of icon design + production. But they ARE a quality ceiling — you cannot compete with Tonies or Yoto on premium-feel without them.

**For v1, polish what you have**:

```dart
// Tile component
GestureDetector(
  onTap: () => setState(() => selected = hero.id),
  child: AnimatedContainer(
    duration: Duration(milliseconds: 150),
    decoration: BoxDecoration(
      gradient: isSelected ? LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x26FFB84D),  // 15% gold
          Color(0x0DFFB84D),  // 5% gold
        ],
      ) : null,
      color: isSelected ? null : LullabookColors.bgHover,
      border: Border.all(
        color: isSelected ? LullabookColors.gold500 : LullabookColors.borderSubtle,
        width: isSelected ? 1.5 : 1,
      ),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Stack(
      children: [
        // Selected check icon top-right
        if (isSelected) Positioned(
          top: 8, right: 8,
          child: Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LullabookColors.gold500,
            ),
            child: Icon(Icons.check, color: LullabookColors.bgBase, size: 12),
          ),
        ),
        // Emoji + label centered
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(hero.emoji, style: TextStyle(fontSize: 36)),
              SizedBox(height: 8),
              Text(
                hero.name,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: -0.01 * 13,
                  color: isSelected
                    ? LullabookColors.textPrimary
                    : LullabookColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),
```

The key changes:
- Selected state has a **checkmark badge** top-right (instead of just a border) — crystal clear feedback
- Selected state uses **gold gradient tint** instead of solid color
- Border width changes from 1px (unselected) to 1.5px (selected)
- 150ms transition animates the change

**v1.1 plan for custom icons** (note this for the roadmap):

```
Phase 1.1 (weeks 11-12): Custom watercolor SVG icons
- Commission designer to create 15 hero icons + 9 companion icons + 8 location icons
- Style: warm watercolor, ~80×80 source, transparent PNG @ 3x
- Cost: ~$300-500 from a Fiverr / 99designs designer, or ~$1500-2500 from a dedicated children's illustrator
- Outcome: visual quality matches Lovevery / Tonies polish level
```

---

### Screen 8: Companion Setup — Step 2 (Image 4) — P0

**Current state**: 9 companion tiles (Solo Hero selected, Apa, Anya, Testvér, Kutya, Cica, Papa, Nagymama, Gabor).

**Critical issue**: **The companion list mixes localized Hungarian terms (Apa, Anya, Testvér, Kutya, Cica, Papa, Nagymama) with a person name (Gabor) in a way that suggests test data leaked into production**.

**What's wrong**:
- ❌ "Gabor" is a name, not a relationship — looks like a debugging entry
- ❌ Hungarian terms ARE good if your i18n is working, but they should be auto-translated based on user locale
- ❌ Some tiles (Apa, Solo Hero text) have no emoji visible — must check assets
- ❌ Same selected state issue as kid setup (use gold gradient + check badge)

**Fix — companion list**:

The companion list should be **dynamic based on locale**. Define it as data in your repository:

```dart
// lib/features/setup/data/companion_repository.dart
class CompanionRepository {
  List<Companion> getCompanions(Locale locale, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      Companion(id: 'solo', emoji: '🌟', name: l10n.companionSolo, isLocked: false),
      Companion(id: 'mom', emoji: '👩', name: l10n.companionMom),
      Companion(id: 'dad', emoji: '👨', name: l10n.companionDad),
      Companion(id: 'sibling', emoji: '🧒', name: l10n.companionSibling),
      Companion(id: 'dog', emoji: '🐶', name: l10n.companionDog),
      Companion(id: 'cat', emoji: '🐱', name: l10n.companionCat),
      Companion(id: 'grandpa', emoji: '👴', name: l10n.companionGrandpa),
      Companion(id: 'grandma', emoji: '👵', name: l10n.companionGrandma),
      Companion(id: 'best_friend', emoji: '🧑', name: l10n.companionBestFriend),
    ];
  }
}
```

In `lib/l10n/app_en.arb`:
```json
{
  "companionSolo": "Solo Hero",
  "companionMom": "Mom",
  "companionDad": "Dad",
  "companionSibling": "Sibling",
  "companionDog": "Dog",
  "companionCat": "Cat",
  "companionGrandpa": "Grandpa",
  "companionGrandma": "Grandma",
  "companionBestFriend": "Best Friend"
}
```

In `lib/l10n/app_hu.arb`:
```json
{
  "companionSolo": "Egyedüli hős",
  "companionMom": "Anya",
  "companionDad": "Apa",
  "companionSibling": "Testvér",
  "companionDog": "Kutya",
  "companionCat": "Cica",
  "companionGrandpa": "Papa",
  "companionGrandma": "Nagymama",
  "companionBestFriend": "Barát"
}
```

**Remove "Gabor"** — that's clearly leaked test data. If you want a "custom companion name" feature, make it a separate "+ Add custom" tile that opens a text input modal.

Apply the same selection-state polish (gradient + checkmark) as kid setup.

---

### Screen 9: Final Touches (Image 2) — P0

**Current state**: 4 progress dashes filled gold + "Any final touches?" + 8 teaching moment chips + "or type your own..." input + white "Create story!" CTA.

**What's mostly right**:
- ✅ Title typography looks correct (large bold sans-serif white)
- ✅ "Optional" header label correct
- ✅ Chip layout works
- ✅ White "Create story!" CTA is **correct per v2 spec**
- ✅ Progress indicator (4 dashes) at top is good

**What's wrong**:
- ❌ Progress is "5 of 4" visually (5 yellow dashes shown but title says step 4) — likely a bug, you have 4 steps, so should show 4 dashes
- ❌ "Optional" label as the screen title is unclear — should be eyebrow + clearer title
- ❌ Chips are unselected (no selection state visible) — make sure the selected state uses the same v2 selected style (gold tint + gold border)
- ❌ "or type your own..." input field looks raw — needs better visual treatment
- ✅ "Create story!" CTA is white per v2 — keep this

**Fix — progress + title**:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Top bar with back, "OPTIONAL" eyebrow, progress
    Row(
      children: [
        BackButton(),
        Spacer(),
        Text('OPTIONAL', style: LullabookTypography.eyebrowSm),
        Spacer(),
        SizedBox(width: 36),
      ],
    ),
    SizedBox(height: 16),
    // Progress: 4 dashes, all gold (final step)
    Row(
      children: List.generate(4, (i) => Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: LullabookColors.gold500,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      )),
    ),
    SizedBox(height: 24),
    Text('Any final touches?', style: LullabookTypography.displayXl),
    SizedBox(height: 16),
    Text('Add a teaching moment', style: TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: LullabookColors.textPrimary,
    )),
    SizedBox(height: 6),
    Text(
      'Optional, for grown-ups. The story will weave it in gently.',
      style: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.5,
        color: LullabookColors.textTertiary,
      ),
    ),
  ],
),
```

**Fix — chip selected state** (apply to all chip components in the app):

```dart
class LullabookChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const LullabookChip({...});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Color(0x26FFB84D) : LullabookColors.bgHover,
          border: Border.all(
            color: selected ? LullabookColors.gold500 : LullabookColors.borderSubtle,
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 13,
            letterSpacing: -0.01 * 13,
            color: selected
              ? LullabookColors.textPrimary
              : LullabookColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
```

This is the standard chip across the entire app — extract it into `lib/shared/widgets/lullabook_chip.dart` and use it for pronouns, art styles, teaching moments, and library filters.

---

### Screen 10: Settings (Image 1) — P1

**Current state**: Settings header + Account section (email + Free plan) + Manage subscription / Restore purchases + Story preferences + Reader (Auto-play, Sleep mode, Background music toggles) + App section (Theme).

**What's mostly right**:
- ✅ Section headers use eyebrow style (ACCOUNT, STORY PREFERENCES, READER, APP) — correct
- ✅ List items use bg-card surface — correct
- ✅ Toggle styling for Auto-play and Sleep mode (gold ON) — mostly correct
- ✅ Disclosure arrows on the right — correct

**What's wrong**:
- ❌ The 3 toggles look slightly different — Auto-play and Sleep mode have **gold ON** (correct), but Background music toggle has a **white circle on dark background** (different style). Inconsistency.
- ❌ Account email card doesn't show subscription tier badge — should have a "FREE" or "YEARLY" pill on the right
- ❌ Settings title "Settings" lacks eyebrow ("ACCOUNT" or similar) — the eyebrow at the top is missing
- ❌ List items would look cleaner if grouped under their section header in a single rounded container with internal dividers (iOS Settings pattern)

**Fix — toggle consistency**:

All toggles should use the same component:

```dart
class LullabookSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const LullabookSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 40,
        height: 24,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? LullabookColors.gold500 : Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                ? LullabookColors.textPrimary  // white circle on gold
                : Color(0x66FFFFFF),            // semi-transparent on gray
            ),
          ),
        ),
      ),
    );
  }
}
```

Use this everywhere: Auto-play, Sleep mode, Background music. They'll all look identical.

**Fix — section grouping (iOS-style)**:

Group adjacent list items in a single rounded container instead of having each as a separate card:

```dart
// Section grouping
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Text('STORY PREFERENCES', style: LullabookTypography.eyebrowSm),
    ),
    Container(
      decoration: BoxDecoration(
        color: LullabookColors.bgHover,
        border: Border.all(color: LullabookColors.borderSubtle, width: 1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _settingsRow(
            label: 'Story language',
            value: 'English',
            showDivider: true,
          ),
          _settingsRow(
            label: 'Default art style',
            value: 'Pixar 3D',
            showDivider: true,
          ),
          _settingsRow(
            label: 'Narration voice',
            value: 'Rachel · Female',
            showDivider: false,  // last item, no divider
          ),
        ],
      ),
    ),
  ],
)

// Helper
Widget _settingsRow({
  required String label,
  String? value,
  Widget? trailing,
  bool showDivider = true,
}) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: LullabookColors.textPrimary,
                ),
              ),
            ),
            if (value != null) Padding(
              padding: EdgeInsets.only(right: 6),
              child: Text(value,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: LullabookColors.textTertiary,
                ),
              ),
            ),
            trailing ?? Icon(Icons.chevron_right,
              color: LullabookColors.textDisabled, size: 14),
          ],
        ),
      ),
      if (showDivider) Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: 0.5,
        color: LullabookColors.borderSubtle,
      ),
    ],
  );
}
```

This collapses 3 separate cards into 1 grouped card with internal dividers — much cleaner, matches iOS Settings style, less visual clutter.

**Fix — account row with subscription badge**:

```dart
Container(
  padding: EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: LullabookColors.bgHover,
    border: Border.all(color: LullabookColors.borderSubtle),
    borderRadius: BorderRadius.circular(14),
  ),
  child: Row(
    children: [
      // Avatar
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Color(0x26FFB84D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            userName[0].toUpperCase(),  // first letter of name
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: LullabookColors.gold500,
            ),
          ),
        ),
      ),
      SizedBox(width: 12),
      // Name + email
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: LullabookColors.textPrimary,
            )),
            SizedBox(height: 2),
            Text(userEmail, style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontSize: 11,
              color: LullabookColors.textTertiary,
            ), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
      // Subscription tier pill
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0x26FFB84D),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          subscriptionTier.toUpperCase(),  // "FREE", "WEEKLY", "YEARLY"
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.04 * 10,
            color: LullabookColors.gold500,
          ),
        ),
      ),
    ],
  ),
),
```

---

## Implementation order — recommended sprint plan

### Sprint 1 (this week) — P0 fixes

1. **Day 1**: Add Inter font, update theme constants (LullabookColors, LullabookTypography)
2. **Day 1-2**: Splash + Home wordmark — change italic serif to Inter Bold
3. **Day 2**: All standalone form CTAs — change gold to white
4. **Day 3**: Add eyebrow labels to F-0, Hero Profile, Photo Upload, Final Touches, Settings
5. **Day 3-4**: Build reusable `LullabookChip` and `LullabookSwitch` components, use everywhere
6. **Day 4-5**: Fix companion list — remove "Gabor", add proper i18n
7. **Day 5**: Selection state polish (gold gradient + checkmark badge) on all tiles + chips

### Sprint 2 (next week) — P1 fixes

1. **Day 1**: Home screen — TUESDAY · 9:14 PM eyebrow + tighter typography
2. **Day 1-2**: Hero CTA card — single wide gold gradient card
3. **Day 2**: Story Reader — close X, page count, favorite heart in glassmorphism overlay
4. **Day 3**: Story Reader — gold italic dialogue highlighting (requires backend change to GPT prompt)
5. **Day 4**: Settings — group sections in single rounded containers with internal dividers
6. **Day 5**: Photo upload — softer dashed border, better empty state styling

### Sprint 3 (week after) — P2 polish + V1.1 prep

1. Animations: 150ms transitions on all selected state changes
2. Haptic feedback on tile selection (HapticFeedback.selectionClick())
3. Plan custom watercolor SVG icons for V1.1
4. Empty states for Library, error states, network failure states

---

## What's already great — don't change

- Bedtime Indigo background (#0F0B1F) — stays
- Lamplight Gold accent (#FFB84D) — stays
- Layout proportions — splash centered, story reader 60/40 split
- Page indicator dots in story reader
- Bottom tab bar concept (3 tabs only)
- Hungarian localization works (just clean up the data leak)
- The pirate ship illustration in story reader is **gorgeous** — RunningHub character consistency working exactly as planned

You're 80% there. The patches above push it the last 20%.

---

## One thing to celebrate

Your story reader screen with the pirate captain + Feri is exactly what we designed for. The illustration quality, the character consistency, the reader layout — that's the entire product working. Everything else is chrome. You've already proven the hard part works.

Ship the chrome fixes, then ship the app.
