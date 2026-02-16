// File: lib/core/themes/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===== New Brand Color Palette =====
  // Primary Colors (main theme)
  static const Color primary = Color(0xFF00A5BD); // Main teal blue
  static const Color primaryDark = Color(0xFF008799); // Darker teal blue
  static const Color primaryLight = Color(0xFF33B8CC); // Lighter teal blue
  static const Color primaryExtraLight = Color(
    0xFFE6F7F9,
  ); // Very light teal tint

  // Accent Colors (secondary theme)
  static const Color secondary = Color(0xFF080C52); // Main dark blue
  static const Color secondaryDark = Color(0xFF05083D); // Darker blue
  static const Color secondaryLight = Color(0xFF2A2E75); // Lighter blue

  // Status Colors (adjusted to complement new palette)
  static const Color success = Color(0xFF2E7D32); // Green
  static const Color warning = Color(0xFFFF9800); // Orange for warnings
  static const Color error = Color(0xFFF44336); // Red for errors
  static const Color info = Color(0xFF2196F3); // Blue for info

  // Neutral Palette - Light Mode
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceVariant = Color(
    0xFFE6F7F9,
  ); // Matches primaryExtraLight
  static const Color card = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(
    0xFF333333,
  ); // Dark gray, not pure black
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  static const Color textDisabled = Color(0xFFBDBDBD);

  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFC8C8C8);

  // Neutral Palette - Dark Mode
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(
    0xFF1A2238,
  ); // Blue-tinted dark surface
  static const Color darkCard = Color(0xFF252525);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextHint = Color(0xFF757575);
  static const Color darkTextDisabled = Color(0xFF555555);

  static const Color darkOutline = Color(0xFF424242);
  static const Color darkOutlineVariant = Color(0xFF616161);
}
