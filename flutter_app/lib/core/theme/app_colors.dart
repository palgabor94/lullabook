import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Surfaces ─────────────────────────────────────────────────────────────
  static const bgBase     = Color(0xFF0F0B1F); // primary background
  static const bgElevated = Color(0xFF1A1335); // cards / modals
  static const bgCard     = Color(0xFF1F1A3D); // secondary card surface
  static const bgHover    = Color(0x0AFFFFFF); // 4% white

  // ── Accent — Lullabook Gold ───────────────────────────────────────────────
  static const gold300 = Color(0xFFFFE5A8);
  static const gold500 = Color(0xFFFFB84D); // primary accent
  static const gold700 = Color(0xFFD89020);
  static const gold900 = Color(0xFF9C7224);

  // ── Text (on dark) ────────────────────────────────────────────────────────
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xB3FFFFFF); // 70%
  static const textTertiary  = Color(0x80FFFFFF); // 50%
  static const textDisabled  = Color(0x66FFFFFF); // 40%
  static const textFaint     = Color(0x4DFFFFFF); // 30%

  // ── Borders / Dividers ────────────────────────────────────────────────────
  static const borderSubtle  = Color(0x0FFFFFFF); // 6%
  static const borderDefault = Color(0x1AFFFFFF); // 10%
  static const borderStrong  = Color(0x26FFFFFF); // 15%

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const success = Color(0xFF5A8F6B);
  static const warning = Color(0xFFFFB84D);
  static const error   = Color(0xFFE07B6E);
  static const info    = Color(0xFF6B7DA8);

  // ── Light mode (secondary) ────────────────────────────────────────────────
  static const bgBaseLight     = Color(0xFFFAF8F4);
  static const bgElevatedLight = Color(0xFFFFFFFF);
  static const textPrimaryLight   = Color(0xFF0F0B1F);
  static const textSecondaryLight = Color(0x990F0B1F); // 60%

  // ── Convenience aliases used in existing code ─────────────────────────────
  static const primary   = gold500;
  static const secondary = gold300;

  // Shadows
  static const shadowColor = Color(0xFF1F1A3D);
}
