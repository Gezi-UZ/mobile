import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class OnboardingStepEntity extends Equatable {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final Widget? customImageWidget;
  final double imageWidth;
  final double imageHeight;
  final List<Color> backgroundColors;
  final String? footerText;
  final bool isLargeTitle;

  const OnboardingStepEntity({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.customImageWidget,
    this.imageWidth = 96.0,
    this.imageHeight = 96.0,
    this.backgroundColors = const [AppTheme.primaryOrange, AppTheme.darkOrange],
    this.footerText,
    this.isLargeTitle = false,
  });

  @override
  List<Object?> get props => [
        title,
        subtitle,
        imageUrl,
        customImageWidget,
        imageWidth,
        imageHeight,
        backgroundColors,
        footerText,
        isLargeTitle,
      ];
}
