import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryOrange = Color(0xFFFF6A00);
  static const Color darkOrange = Color(0xFFE84300);
  static const Color darkerOrange = Color(0xFF8A2E00);
  static const Color lightOrange = Color(0xFFFFB300);
  static const Color lightOrangeBackground = Color(0xFFFFF6ED);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color textColorDark = Color(0xFF1A1A1A);
  static const Color textColorSecondary = Color(0xFF666666);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color errorColor = Color(0xFFFF3B30);
  static const Color successColor = Color(0xFF00C950);

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
}
