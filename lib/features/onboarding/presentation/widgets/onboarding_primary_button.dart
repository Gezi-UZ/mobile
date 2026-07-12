import 'package:flutter/material.dart';

class OnboardingPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OnboardingPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: ShapeDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.11,
              color: Colors.white.withValues(alpha: 0.25),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}
