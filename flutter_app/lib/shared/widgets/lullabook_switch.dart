import 'package:flutter/material.dart';

import '../../core/theme/lullabook_colors.dart';

/// Custom toggle that replaces the inconsistent platform Switch widget.
/// Animates over 200 ms; gold track when ON, semi-transparent when OFF.
class LullabookSwitch extends StatelessWidget {
  const LullabookSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? LullabookColors.gold500 : const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? LullabookColors.textPrimary   // white circle on gold
                  : const Color(0x66FFFFFF),      // 40% white on gray
            ),
          ),
        ),
      ),
    );
  }
}
