import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_colors_extension.dart';

// Exporting to not break existing imports
export 'app_colors.dart';
export 'app_typography.dart';
export 'app_colors_extension.dart';

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
  static const Color errorColor = AppColors.errorColor;
  static const Color black = AppColors.black;
  static const Color dividerColor = AppColors.dividerColor;
  static const Color successColor = AppColors.successColor;
  static const LinearGradient primaryGradient = AppColors.primaryGradient;
  static const LinearGradient secondaryGradient = AppColors.secondaryGradient;
  static const LinearGradient tertiaryGradient = AppColors.tertiaryGradient;

  // ThemeData configuration
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: AppColors.primaryOrange,
        primary: AppColors.primaryOrange,
        surface: AppColors.white,
        onSurface: AppColors.textColorDark,
        onSurfaceVariant: AppColors.textColorSecondary,
        error: AppColors.errorColor,
      ),
      scaffoldBackgroundColor: AppColors.white,
      textTheme: AppTypography.textTheme,
      extensions: const <ThemeExtension<dynamic>>[
        AppColorsExtension(
          dividerColor: AppColors.dividerColor,
          successColor: AppColors.successColor,
          errorColor: AppColors.errorColor,
          lightOrangeBackground: AppColors.lightOrangeBackground,
          textColorSecondary: AppColors.textColorSecondary,
          inputBackground: Color(0xFFF5F5F5),
        ),
      ],
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

  static ThemeData get darkThemeData {
    const darkSurface = Color(0xFF1E1E1E);
    const darkBackground = Color(0xFF121212);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: AppColors.primaryOrange,
        primary: AppColors.primaryOrange,
        surface: darkSurface,
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white70,
        error: AppColors.errorColor,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppColorsExtension(
          dividerColor: Color(0xFF333333),
          successColor: AppColors.successColor,
          errorColor: AppColors.errorColor,
          lightOrangeBackground: Color(0xFF3E2713),
          textColorSecondary: Colors.white70,
          inputBackground: Color(0xFF2C2C2C),
        ),
      ],
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
