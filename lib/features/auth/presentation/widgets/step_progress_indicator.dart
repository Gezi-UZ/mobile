import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final String label;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCircle(
          context,
          '1',
          isActive: currentStep == 1,
          isCompleted: currentStep > 1,
        ),
        _buildLine(isActive: currentStep >= 2),
        _buildCircle(
          context,
          '2',
          isActive: currentStep == 2,
          isCompleted: currentStep > 2,
        ),
        _buildLine(isActive: currentStep >= 3),
        _buildCircle(
          context,
          '3',
          isActive: currentStep == 3,
          isCompleted: currentStep > 3,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppTheme.primaryOrange,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(
    BuildContext context,
    String step, {
    required bool isActive,
    required bool isCompleted,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: isActive || isCompleted
            ? AppTheme.primaryOrange
            : const Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                step,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isActive ? Colors.white : AppTheme.textColorSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 32,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isActive ? AppTheme.primaryOrange : const Color(0xFFF5F5F5),
    );
  }
}
