import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static const textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
    displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.3),
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.3),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, height: 1.6),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, height: 1.6),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, height: 1.5),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5),
  );
}
