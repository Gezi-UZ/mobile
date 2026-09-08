import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color dividerColor;
  final Color successColor;
  final Color errorColor;
  final Color lightOrangeBackground;
  final Color textColorSecondary;  final Color inputBackground;

  const AppColorsExtension({
    required this.dividerColor,
    required this.successColor,
    required this.errorColor,
    required this.lightOrangeBackground,
    required this.textColorSecondary,
    required this.inputBackground,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? dividerColor,
    Color? successColor,
    Color? errorColor,
    Color? lightOrangeBackground,
    Color? textColorSecondary,
    Color? inputBackground,
  }) {
    return AppColorsExtension(
      dividerColor: dividerColor ?? this.dividerColor,
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      lightOrangeBackground: lightOrangeBackground ?? this.lightOrangeBackground,
      textColorSecondary: textColorSecondary ?? this.textColorSecondary,
      inputBackground: inputBackground ?? this.inputBackground,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      successColor: Color.lerp(successColor, other.successColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      lightOrangeBackground: Color.lerp(lightOrangeBackground, other.lightOrangeBackground, t)!,
      textColorSecondary: Color.lerp(textColorSecondary, other.textColorSecondary, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
    );
  }
}
