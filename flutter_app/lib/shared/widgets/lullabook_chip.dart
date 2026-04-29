import 'package:flutter/material.dart';

import '../../core/theme/lullabook_colors.dart';

/// Standard selectable chip used for pronouns, art styles, adventure choices,
/// teaching moments, and library filters throughout the app.
class LullabookChip extends StatelessWidget {
  const LullabookChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? LullabookColors.goldTint15 : LullabookColors.bgHover,
          border: Border.all(
            color: selected ? LullabookColors.gold500 : LullabookColors.borderSubtle,
            width: selected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            fontSize: 13,
            letterSpacing: -0.13, // -0.01em
            color: selected ? LullabookColors.textPrimary : LullabookColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
