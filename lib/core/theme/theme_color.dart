// File: lib/core/themes/app_theme.dart
// Architecture: Core Layer - App Theme
// Purpose: Define the app theme for the application
// ignore_for_file: deprecated_member_use

import 'package:boimteric_app_getx/core/theme/app_colors.dart';
import 'package:boimteric_app_getx/core/theme/app_text_styles.dart'
    show AppTextStyles;
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primaryDark,

        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryLight,
        onSecondaryContainer: AppColors.secondaryDark,

        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.textSecondary,

        background: AppColors.background,
        onBackground: AppColors.textPrimary,

        error: AppColors.error,
        onError: Colors.white,

        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,

        shadow: Colors.black.withOpacity(0.1),
        scrim: Colors.black.withOpacity(0.4),

        inverseSurface: AppColors.darkSurface,
        onInverseSurface: AppColors.darkTextPrimary,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.card,
      dialogBackgroundColor: AppColors.surface,
      indicatorColor: AppColors.primary,
      dividerColor: AppColors.outline,
      canvasColor: AppColors.background,
      shadowColor: Colors.black.withOpacity(0.1),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      bottomAppBarTheme: BottomAppBarThemeData(
        color: AppColors.surface,
        elevation: 4,
      ),

      cardTheme: CardThemeData(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primary.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      textTheme:
          TextTheme(
            displayLarge: AppTextStyles.displayLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            displayMedium: AppTextStyles.displayMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            displaySmall: AppTextStyles.displaySmall.copyWith(
              color: AppColors.textPrimary,
            ),
            headlineLarge: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            headlineMedium: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            headlineSmall: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            titleLarge: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            titleMedium: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            titleSmall: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textPrimary,
            ),
            bodyLarge: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            bodyMedium: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            bodySmall: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
            labelLarge: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            labelMedium: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            labelSmall: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ).apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryDark,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight.withOpacity(0.2),
        onPrimaryContainer: AppColors.primaryDark,

        secondary: AppColors.secondaryDark,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondary.withOpacity(0.2),
        onSecondaryContainer: AppColors.secondaryLight,

        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceVariant: AppColors.darkSurfaceVariant,
        onSurfaceVariant: AppColors.darkTextSecondary,

        background: AppColors.darkBackground,
        onBackground: AppColors.darkTextPrimary,

        error: AppColors.error,
        onError: Colors.white,

        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,

        shadow: Colors.black.withOpacity(0.3),
        scrim: Colors.black.withOpacity(0.6),

        inverseSurface: AppColors.surface,
        onInverseSurface: AppColors.textPrimary,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      dialogBackgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.primaryDark,
      dividerColor: AppColors.darkOutline,
      canvasColor: AppColors.darkBackground,
      shadowColor: Colors.black.withOpacity(0.3),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      bottomAppBarTheme: BottomAppBarThemeData(
        color: AppColors.darkSurface,
        elevation: 4,
      ),

      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: BorderSide(color: AppColors.primaryDark),
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkOutline),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),

      textTheme:
          TextTheme(
            displayLarge: AppTextStyles.displayLarge.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            displayMedium: AppTextStyles.displayMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            displaySmall: AppTextStyles.displaySmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            headlineLarge: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            headlineMedium: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            headlineSmall: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            titleLarge: AppTextStyles.titleLarge.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            titleMedium: AppTextStyles.titleMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            titleSmall: AppTextStyles.titleSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            bodyLarge: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            bodyMedium: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            bodySmall: AppTextStyles.bodySmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            labelLarge: AppTextStyles.labelLarge.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            labelMedium: AppTextStyles.labelMedium.copyWith(
              color: AppColors.darkTextPrimary,
            ),
            labelSmall: AppTextStyles.labelSmall.copyWith(
              color: AppColors.darkTextPrimary,
            ),
          ).apply(
            bodyColor: AppColors.darkTextPrimary,
            displayColor: AppColors.darkTextPrimary,
          ),
    );
  }
}
