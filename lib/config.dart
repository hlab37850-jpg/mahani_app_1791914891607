import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'مصروفاتي';
  static const Locale defaultLocale = Locale('ar');
  static const bool rtl = true;

  // Theme colors
  static const Color incomeColor = Color(0xFF4CAF50); // green
  static const Color expenseColor = Color(0xFFF44336); // red
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;

  // Material 3 color scheme (light)
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
    primary: incomeColor,
    secondary: expenseColor,
  );

  // Material 3 color scheme (dark)
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.dark,
    primary: incomeColor,
    secondary: expenseColor,
  );
}
