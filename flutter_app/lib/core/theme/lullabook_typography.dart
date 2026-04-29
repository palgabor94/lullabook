import 'package:flutter/material.dart';

/// Compile-time const TextStyles using bundled Inter font.
/// Requires Inter .ttf files in assets/fonts/ and the fonts: block in pubspec.yaml.
class LullabookTypography {
  LullabookTypography._();

  // Display — Inter 700, tight letter-spacing
  static const displayXl = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.125, // 36/32
    letterSpacing: -0.8, // -0.025em
    color: Color(0xFFFFFFFF),
  );

  static const displayLg = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.143, // 32/28
    letterSpacing: -0.7, // -0.025em
    color: Color(0xFFFFFFFF),
  );

  static const displayMd = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 22,
    height: 1.273, // 28/22
    letterSpacing: -0.44, // -0.02em
    color: Color(0xFFFFFFFF),
  );

  // Eyebrow — uppercase, letter-spaced
  static const eyebrowMd = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 11,
    height: 1.273, // 14/11
    letterSpacing: 1.32, // 0.12em
    color: Color(0xFFFFB84D), // gold500
  );

  static const eyebrowSm = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 10,
    height: 1.3, // 13/10
    letterSpacing: 0.8, // 0.08em
    color: Color(0x80FFFFFF), // textTertiary
  );

  // Button label
  static const labelButton = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    letterSpacing: -0.15, // -0.01em
  );

  // Body
  static const bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    color: Color(0x80FFFFFF), // textTertiary
  );

  static const bodySm = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 1.5,
    color: Color(0x66FFFFFF), // textDisabled
  );
}
