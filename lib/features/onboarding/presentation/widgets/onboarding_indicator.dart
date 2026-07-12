import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class OnboardingIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const OnboardingIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(totalSteps, (index) {
        final isActive = index == currentStep;
        return Container(
          width: isActive ? 24.0 : 6.0,
          height: 6.0,
          margin: EdgeInsets.only(right: index < totalSteps - 1 ? 8.0 : 0.0),
          decoration: ShapeDecoration(
            color: isActive ? AppTheme.white : AppTheme.white.withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        );
      }),
    );
  }
}
