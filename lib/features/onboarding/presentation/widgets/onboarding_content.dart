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
                width: step.imageWidth,
                height: step.imageHeight,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: step.customImageWidget ??
                    (step.imageUrl != null
                        ? (step.imageUrl!.endsWith('.svg')
                            ? SvgPicture.asset(
                                step.imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                step.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(color: Colors.grey);
                                },
                              ))
                        : const SizedBox()),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: step.isLargeTitle
                ? Theme.of(context).textTheme.displayLarge
                : Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Text(
              step.subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
