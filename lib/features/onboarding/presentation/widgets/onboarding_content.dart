import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_step_entity.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingContent extends StatelessWidget {
  final OnboardingStepEntity step;

  const OnboardingContent({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64, left: 32, right: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Center(
              child: Container(
                width: 96,
                height: 96,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: step.imageUrl.endsWith('.svg')
                    ? SvgPicture.asset(
                        step.imageUrl,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        step.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey);
                        },
                      ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -1.20,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              step.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.80),
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.63,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
