import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Inter — all UI chrome
/// Fraunces — story reader text only
class AppTextStyles {
  AppTextStyles._();

  // ── Display (Inter 700, tight letter-spacing) ─────────────────────────────
  static TextStyle display2xl({Color? color}) => GoogleFonts.inter(
        fontSize: 36, height: 40 / 36, fontWeight: FontWeight.w700,
        letterSpacing: -0.03 * 36, color: color,
      );
  static TextStyle displayXl({Color? color}) => GoogleFonts.inter(
        fontSize: 32, height: 36 / 32, fontWeight: FontWeight.w700,
        letterSpacing: -0.025 * 32, color: color,
      );
  static TextStyle displayLg({Color? color}) => GoogleFonts.inter(
        fontSize: 28, height: 32 / 28, fontWeight: FontWeight.w700,
        letterSpacing: -0.025 * 28, color: color,
      );
  static TextStyle displayMd({Color? color}) => GoogleFonts.inter(
        fontSize: 22, height: 28 / 22, fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 22, color: color,
      );
  static TextStyle displaySm({Color? color}) => GoogleFonts.inter(
        fontSize: 18, height: 24 / 18, fontWeight: FontWeight.w600,
        letterSpacing: -0.01 * 18, color: color,
      );

  // ── Body (Inter) ─────────────────────────────────────────────────────────
  static TextStyle bodyLg({Color? color}) => GoogleFonts.inter(
        fontSize: 15, height: 22 / 15, fontWeight: FontWeight.w500, color: color,
      );
  static TextStyle bodyMd({Color? color}) => GoogleFonts.inter(
        fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400, color: color,
      );
  static TextStyle bodySm({Color? color}) => GoogleFonts.inter(
        fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w500, color: color,
      );
  static TextStyle bodyXs({Color? color}) => GoogleFonts.inter(
        fontSize: 11, height: 16 / 11, fontWeight: FontWeight.w400, color: color,
      );

  // ── Eyebrow (Inter uppercase) ─────────────────────────────────────────────
  static TextStyle eyebrowMd({Color? color}) => GoogleFonts.inter(
        fontSize: 11, height: 14 / 11, fontWeight: FontWeight.w700,
        letterSpacing: 0.12 * 11, color: color,
      );
  static TextStyle eyebrowSm({Color? color}) => GoogleFonts.inter(
        fontSize: 10, height: 13 / 10, fontWeight: FontWeight.w600,
        letterSpacing: 0.08 * 10, color: color,
      );
  static TextStyle eyebrowXs({Color? color}) => GoogleFonts.inter(
        fontSize: 9, height: 12 / 9, fontWeight: FontWeight.w700,
        letterSpacing: 0.06 * 9, color: color,
      );

  // ── Story Reader (Fraunces — bedtime mood) ────────────────────────────────
  static TextStyle storyText({Color? color}) => GoogleFonts.fraunces(
        fontSize: 17, height: 27 / 17, fontWeight: FontWeight.w400,
        letterSpacing: -0.005 * 17, color: color,
      );
  static TextStyle storyDialog({Color? color}) => GoogleFonts.fraunces(
        fontSize: 17, height: 27 / 17, fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic, color: color,
      );

  // ── MaterialTheme text theme (Inter) ─────────────────────────────────────
  static TextTheme get textTheme => GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge:  TextStyle(fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: -1.08),
          displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.8),
          displaySmall:  TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.7),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.44),
          headlineMedium:TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.18),
          headlineSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          bodyLarge:     TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.47),
          bodyMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.43),
          bodySmall:     TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.38),
          labelLarge:    TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          labelMedium:   TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.32),
        ),
      );
}
