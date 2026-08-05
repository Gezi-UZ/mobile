import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class TextActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;

  const TextActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.primaryOrange,
        textStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      child: Text(text),
    );
  }
}
