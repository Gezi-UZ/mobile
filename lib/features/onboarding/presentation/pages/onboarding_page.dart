import 'package:flutter/material.dart';
import '../../domain/entities/onboarding_step_entity.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_primary_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // The other steps will be added here once provided
  final List<OnboardingStepEntity> _steps = [
    const OnboardingStepEntity(
      title: 'Gezi',
      subtitle: 'Energia sem fronteiras de distância.',
      imageUrl: 'assets/images/gezi-logo.svg',
    ),
  ];

  void _onNextPressed() {
    if (_currentIndex < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // TODO: Handle completion (Navigate to Home or Auth)
    }
  }

  void _onSkipPressed() {
    // TODO: Handle skip (Navigate to Home or Auth)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.32, 0.00),
            end: Alignment(0.68, 1.00),
            colors: [Color(0xFFFF6A00), Color(0xFFE84300)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _steps.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingContent(step: _steps[index]);
                },
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 32,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_steps.length > 1) ...[
                        OnboardingIndicator(
                          totalSteps: _steps.length,
                          currentStep: _currentIndex,
                        ),
                        const SizedBox(height: 24),
                      ],
                      OnboardingPrimaryButton(
                        text: 'Começar', // Will be changed based on step if needed
                        onPressed: _onNextPressed,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 24,
                child: TextButton(
                  onPressed: _onSkipPressed,
                  child: Text(
                    'Ignorar',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.70),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
