import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/register/register_bloc.dart';
import '../bloc/register/register_event.dart';
import '../bloc/register/register_state.dart';
import '../../../../core/theme/theme.dart';
import 'pin_input_field.dart';
import 'step_progress_indicator.dart';

class RegisterStep2 extends StatefulWidget {
  const RegisterStep2({super.key});

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpComplete = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value) {
    final complete = value.length == 6;
    if (complete != _isOtpComplete) {
      setState(() {
        _isOtpComplete = complete;
      });
    }
  }

  void _submit() {
    if (_isOtpComplete) {
      final code = _otpController.text.trim();
      context.read<RegisterBloc>().add(OtpSubmitted(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final phone = state.phoneNumber;

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
                            GestureDetector(
                              onTap: () {
                                // Should navigate back to step 1
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(Icons.arrow_back),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person_add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Verificação',
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
                          currentStep: 2,
                          label: 'Verificar número',
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'Código de verificação',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: AppTheme.textColorDark,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Introduza o código de 6 dígitos enviado por SMS para o seu número.',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppTheme.textColorSecondary,
                                      fontSize: 14,
                                    ),
                              ),
                              TextSpan(
                                text: '+258 $phone',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textColorDark,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // OTP Input Field
                        PinInputField(
                          controller: _otpController,
                          length: 6,
                          autofocus: true,
                          onChanged: _onOtpChanged,
                          onCompleted: (pin) => _submit(),
                        ),
                        const SizedBox(height: 24),

                        // Resend Text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Não recebeu? ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppTheme.textColorSecondary,
                                    fontSize: 14,
                                  ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                // Reenviar
                              },
                              child: Text(
                                'Reenviar em 00:23',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: AppTheme.primaryOrange,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isOtpComplete ? _submit : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isOtpComplete
                                  ? AppTheme.primaryOrange
                                  : const Color(0xFFCCCCCC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Verificar código',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
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
      },
    );
  }
}
