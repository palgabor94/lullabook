# Lullabook — Story Reader Patch Fix

> Scope: Story Reader screen only
> Effort: ~2 hours total
> Status: targeted fix

---

## What's already working

The Sprint 1+2 changes landed correctly on this screen:
- Top chrome (close X, page count pill, favorite heart) — perfect
- Page count "5 / 8" in glassmorphism pill — correct
- Page indicator dots at bottom with gold for current page — correct
- Full-bleed illustration with proper storybook proportions — beautiful
- Story text in serif (Fraunces) — correct
- Listen pill at bottom-left — correct

---

## Two issues to fix

### Issue 1: Redundant play button (P0)

There's a large circular dark button with a gold play icon centered below the story text, AND a "Listen" pill at the bottom-left. **Both control audio playback.** Two buttons = confused UX.

**Fix**: remove the centered circular button. Keep only the "Listen" pill.

```dart
// lib/features/story_reader/presentation/widgets/story_page_view.dart

// REMOVE this entire widget from the build method:
//
// Container(
//   width: 56, height: 56,
//   decoration: BoxDecoration(
//     shape: BoxShape.circle,
//     color: LullabookColors.bgCard,
//   ),
//   child: IconButton(
//     icon: Icon(Icons.play_arrow, color: LullabookColors.gold500),
//     onPressed: ...,
//   ),
// ),
```

The bottom section becomes just: story text → Listen pill (left) + page dots (right or center).

### Issue 2: Dialogue not highlighted (P1)

Current text:
> Feri thought for a moment. Then, he nodded. "Pull the sail tight!" he shouted. Together, they worked as the storm roared around them.

The dialogue `"Pull the sail tight!"` should be in **gold italic Fraunces** to set it apart from narration. This adds tension and rhythm during read-aloud.

**Fix**: parse `"..."` patterns and split the text into narration + dialogue spans.

```dart
// lib/features/story_reader/presentation/widgets/story_text.dart

class StoryText extends StatelessWidget {
  final String text;

  const StoryText({required this.text, super.key});

  /// Parse text into segments separated by quoted dialogue.
  /// Example: 'He said "hello" loudly.' → 
  ///   [narration: 'He said ', dialogue: '"hello"', narration: ' loudly.']
  List<_Segment> _parseSegments(String input) {
    final segments = <_Segment>[];
    final regex = RegExp(r'"[^"]+"|"[^"]+"');  // matches "..." or "..."
    int lastEnd = 0;

    for (final match in regex.allMatches(input)) {
      if (match.start > lastEnd) {
        segments.add(_Segment(
          text: input.substring(lastEnd, match.start),
          isDialogue: false,
        ));
      }
      segments.add(_Segment(text: match.group(0)!, isDialogue: true));
      lastEnd = match.end;
    }
    if (lastEnd < input.length) {
      segments.add(_Segment(
        text: input.substring(lastEnd),
        isDialogue: false,
      ));
    }
    return segments;
  }

  @override
  Widget build(BuildContext context) {
    final segments = _parseSegments(text);

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Fraunces',
          fontWeight: FontWeight.w400,
          fontSize: 17,
          height: 1.6,
          letterSpacing: -0.005 * 17,
          color: LullabookColors.textPrimary,
        ),
        children: segments.map((seg) => TextSpan(
          text: seg.text,
          style: seg.isDialogue
            ? TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: LullabookColors.gold500,
              )
            : null,
        )).toList(),
      ),
    );
  }
}

class _Segment {
  final String text;
  final bool isDialogue;
  const _Segment({required this.text, required this.isDialogue});
}
```

Replace the existing story text rendering with `StoryText(text: page.text)`.

**Why regex over GPT structured output**: GPT-4o reliably wraps dialogue in `"..."` already. Parsing client-side is simpler than coordinating a structured JSON response format. Only consider structured output if you find dialogue without quotes (rare).

---

## Done criteria

- [ ] Only ONE play control visible (the Listen pill)
- [ ] Dialogue text renders in gold italic Fraunces
- [ ] Narration text renders in white regular Fraunces
- [ ] No regression: page dots still show, illustration full-bleed, top chrome intact

---

## Hand-off prompt

```
Read docs/story-reader-patch.md. Apply both fixes:
1. Remove the circular play button from story_page_view.dart
2. Build StoryText widget with dialogue parser and use it in story page rendering

Show me the diff before applying.
```
