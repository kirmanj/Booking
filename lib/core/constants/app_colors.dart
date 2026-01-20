import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF3D5A6C);
  static const Color secondary = Color(0xFFFFB800);
  static const Color background = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFFBDBDBD);
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF757575);

  static const List<Color> primaryGradient = [
    Color(0xFF3D5A6C),
    Color(0xFFBDBDBD),
  ];

  // Background & Surface
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentRed = Color(0xFFF44336);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentOrange = Color(0xFFFF9800);

  // State Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Border & Divider
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  static const List<Color> accentGradient = [
    Color(0xFFFF9800),
    Color(0xFFFF5722),
  ];

  static const List<Color> successGradient = [
    Color(0xFF4CAF50),
    Color(0xFF2E7D32),
  ];

  // Shadow
  static const Color shadow = Color(0x1A000000);

  static Color shadowLight = Colors.black.withOpacity(0.05);
}
