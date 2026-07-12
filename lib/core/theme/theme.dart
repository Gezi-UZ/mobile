import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryOrange = Color(0xFFFF6A00);
  static const Color darkOrange = Color(0xFFE84300);
  static const Color darkerOrange = Color(0xFF8A2E00);
  static const Color lightOrange = Color(0xFFFFB300);
  static const Color lightOrangeBackground = Color(0xFFFFF6ED);
  static const Color white = Colors.white;
  static const Color textColorDark = Color(0xFF1A1A1A);
  static const Color textColorSecondary = Color(0xFF666666);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(0.32, 0.00),
    end: Alignment(0.68, 1.00),
    colors: [primaryOrange, darkOrange],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment(0.32, 0.00),
    end: Alignment(0.68, 1.00),
    colors: [darkOrange, darkerOrange],
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    begin: Alignment(0.32, 0.00),
    end: Alignment(0.68, 1.00),
    colors: [primaryOrange, lightOrange],
  );

  // Typography - Titles (Inter)
  static TextStyle displayLarge = GoogleFonts.inter(
    color: white,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -1.20,
  );

  static TextStyle displayMedium = GoogleFonts.inter(
    color: white,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.75,
  );

  // Typography - Body (Poppins)
  static TextStyle bodyLarge = GoogleFonts.poppins(
    color: white.withValues(alpha: 0.80),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.63,
  );

  // Typography - Buttons & Labels (Inter)
  static TextStyle labelLarge = GoogleFonts.inter(
    color: white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.50,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    color: white.withValues(alpha: 0.70),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelSmall = GoogleFonts.poppins(
    color: white.withValues(alpha: 0.40),
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.50,
  );

  // ThemeData configuration
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryOrange,
        primary: primaryOrange,
      ),
      textTheme: TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        bodyLarge: bodyLarge,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
    );
  }
}
