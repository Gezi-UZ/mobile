import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

// Exporting to not break existing imports
export 'app_colors.dart';
export 'app_typography.dart';

class AppTheme {
  // Aliases to AppColors to not break existing references that use AppTheme.primaryOrange etc.
  static const Color primaryOrange = AppColors.primaryOrange;
  static const Color darkOrange = AppColors.darkOrange;
  static const Color darkerOrange = AppColors.darkerOrange;
  static const Color lightOrange = AppColors.lightOrange;
  static const Color lightOrangeBackground = AppColors.lightOrangeBackground;
  static const Color white = AppColors.white;
  static const Color textColorDark = AppColors.textColorDark;
  static const Color textColorSecondary = AppColors.textColorSecondary;

  static const LinearGradient primaryGradient = AppColors.primaryGradient;
  static const LinearGradient secondaryGradient = AppColors.secondaryGradient;
  static const LinearGradient tertiaryGradient = AppColors.tertiaryGradient;

  // ThemeData configuration
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryOrange,
        primary: AppColors.primaryOrange,
      ),
      scaffoldBackgroundColor: AppColors.white,
      textTheme: AppTypography.textTheme,
      // Default Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          textStyle: AppTypography.labelLarge,
        ),
      ),
    );
  }
}
