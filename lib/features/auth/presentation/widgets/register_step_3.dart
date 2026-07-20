import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/register/register_bloc.dart';
import '../bloc/register/register_event.dart';
import '../../../../core/theme/theme.dart';
import 'passkey_benefits_card.dart';
import 'passkey_method_selector.dart';
import 'step_progress_indicator.dart';

class RegisterStep3 extends StatefulWidget {
  const RegisterStep3({super.key});

  @override
  State<RegisterStep3> createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  String _selectedMethod = 'fingerprint';

  void _createPasskey(BuildContext context) {
    if (_selectedMethod == 'pin') {
      context.push('/create-pin');
    } else {
      context.read<RegisterBloc>().add(
        PasskeyCreationRequested(method: _selectedMethod),
      );
    }
  }

  void _skipPasskey(BuildContext context) {
    context.read<RegisterBloc>().add(PasskeyCreationSkipped());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 32.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Icon(Icons.person_add, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Quase pronto!',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppTheme.textColorDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Progress Indicators
                    const StepProgressIndicator(
                      currentStep: 3,
                      label: 'Criar passkey',
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Criar a sua Passkey',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uma passkey substitui a password. Usa a impressão digital do seu telemóvel ou crie um PIN para entrar de forma segura e rápida, sem precisar de lembrar passwords.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textColorSecondary,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Passkey Benefits Box
                    const PasskeyBenefitsCard(),

                    const SizedBox(height: 24),

                    // Passkey Method Selector
                    PasskeyMethodSelector(
                      selectedMethod: _selectedMethod,
                      onMethodSelected: (method) {
                        setState(() {
                          _selectedMethod = method;
                        });
                      },
                    ),

                    const Spacer(),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _createPasskey(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _selectedMethod == 'fingerprint'
                              ? 'Criar Passkey com Impressão digital'
                              : 'Criar Passkey com PIN',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Skip Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: TextButton(
                        onPressed: () => _skipPasskey(context),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textColorSecondary,
                        ),
                        child: Text(
                          'Fazer isto mais tarde',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppTheme.textColorSecondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
