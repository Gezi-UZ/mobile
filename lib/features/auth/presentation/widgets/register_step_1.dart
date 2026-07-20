import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/register/register_bloc.dart';
import '../bloc/register/register_event.dart';
import '../../../../core/theme/theme.dart';
import 'step_progress_indicator.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneChanged);
    _phoneController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    final clean = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final valid = clean.length == 9 && RegExp(r'^8[2-8]').hasMatch(clean);
    if (valid != _isValid) {
      setState(() {
        _isValid = valid;
      });
    }
  }

  void _submit() {
    if (_isValid) {
      final phone = _phoneController.text.trim();
      context.read<RegisterBloc>().add(PhoneNumberSubmitted(phone));
    }
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
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
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
                            child: Icon(Icons.person_add, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Criar conta',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textColorDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(width: double.infinity, height: 24),

                    // Progress Indicators
                    const StepProgressIndicator(
                      currentStep: 1,
                      label: 'Inserir número',
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'O seu número',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Introduza o seu número de telefone para criar a sua conta Gezi. Enviaremos um código de verificação por SMS.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textColorSecondary,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Número de telefone',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),

                    // Phone Input
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Text(
                            '+258',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppTheme.textColorDark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '|',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textColorDark,
                                    fontSize: 16,
                                  ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '84 000 0000',
                                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textColorSecondary,
                                      fontSize: 16,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'O código chega por SMS em até 30 segundos.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textColorSecondary,
                            fontSize: 12,
                          ),
                    ),

                    const Spacer(),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isValid ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isValid
                              ? AppTheme.primaryOrange
                              : const Color(0xFFCCCCCC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Receber código SMS',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
  }
}
