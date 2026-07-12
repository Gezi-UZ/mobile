import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/onboarding_step_entity.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_primary_button.dart';
import '../../../../core/theme/theme.dart';
import '../../../../injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      imageUrl: 'assets/images/gezi-logo.png',
      isLargeTitle: true,
    ),
    const OnboardingStepEntity(
      title: 'Recarregue de onde estiver',
      subtitle:
          'Pague via M-Pesa ou e-Mola e o crédito chega directamente ao contador —em qualquer lugar e a qualquer momento',
      backgroundColors: [AppTheme.darkOrange, AppTheme.darkerOrange],
      footerText: 'ELECTRICIDADE DE MOÇAMBIQUE',
      imageUrl: 'assets/images/onboarding-content1.svg',
      imageWidth: 220.0,
      imageHeight: 200.0,
    ),
    const OnboardingStepEntity(
      title: 'Controle o seu saldo',
      subtitle:
          'Monitorize o consumo em tempo real, receba alertas de saldo baixo e veja o histórico completo.',
      backgroundColors: [AppTheme.primaryOrange, AppTheme.lightOrange],
      footerText: 'ELECTRICIDADE DE MOÇAMBIQUE',
      imageUrl: 'assets/images/onboarding-content-2.svg',
      imageWidth: 220.0,
      imageHeight: 200.0,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = sl<SharedPreferences>();
    await prefs.setBool('has_seen_onboarding', true);
    if (mounted) {
      context.go('/login');
    }
  }

  void _onNextPressed() {
    if (_currentIndex < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _onSkipPressed() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.32, 0.00),
            end: const Alignment(0.68, 1.00),
            colors: _steps[_currentIndex].backgroundColors,
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
                bottom: 56,
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
                        text: _currentIndex == 0
                            ? 'Começar'
                            : _currentIndex == 1
                                ? 'Próximo'
                                : 'Entrar',
                        onPressed: _onNextPressed,
                      ),
                    ],
                  ),
                ),
              ),
              if (_currentIndex < _steps.length - 1)
                Positioned(
                  top: 16,
                  right: 24,
                  child: TextButton(
                    onPressed: _onSkipPressed,
                    child: Text(
                      'Ignorar',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              if (_steps[_currentIndex].footerText != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 16,
                  child: Text(
                    _steps[_currentIndex].footerText!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall,
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
