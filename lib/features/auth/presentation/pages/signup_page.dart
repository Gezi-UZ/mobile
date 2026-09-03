import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/core/theme/theme.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/email_auth/signup_bloc.dart';
import '../bloc/email_auth/signup_event.dart';
import '../bloc/email_auth/signup_state.dart';
import '../widgets/auth_header.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  
  bool _isFormValid = false;
  bool _obscurePin = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _pinController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateForm);
    _emailController.removeListener(_validateForm);
    _pinController.removeListener(_validateForm);
    _nameController.dispose();
    _emailController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final pin = _pinController.text.trim();
    
    final nameValid = name.isNotEmpty;
    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final pinValid = pin.length == 6 && RegExp(r'^\d{6}$').hasMatch(pin);
    
    final valid = nameValid && emailValid && pinValid;
    if (valid != _isFormValid) {
      setState(() => _isFormValid = valid);
    }
  }

  void _onSignupPressed(BuildContext context) {
    if (_isFormValid) {
      context.read<SignupBloc>().add(SignupRequested(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        pin: _pinController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SignupBloc>(),
      child: Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textColorDark),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              // SignupBloc: handles account creation
              BlocListener<SignupBloc, SignupState>(
                listener: (context, state) {
                  if (state is SignupSuccess) {
                    // Update global auth session
                    context.read<AuthBloc>().add(SessionObtained(state.session));
                    // Go to passkey setup page to ask for biometric enable
                    context.go('/passkey-setup');
                  } else if (state is SignupFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red.shade700),
                    );
                  }
                },
              ),
            ],
            child: BlocBuilder<SignupBloc, SignupState>(
              builder: (context, signupState) {
                final isLoading = signupState is SignupLoading;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 24,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeader(title: 'Nova Conta'),
                      const SizedBox(height: 32),

                      Text(
                        'Criar conta',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppTheme.textColorDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preencha os seus dados para aderir ao Gezi.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textColorSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Full Name Input ────────────────────────────────
                      Text(
                        'Nome Completo',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.textColorDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'O seu nome',
                            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textColorSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Email Input ────────────────────────────────
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.textColorDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'exemplo@gezi.com',
                            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textColorSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // ── PIN Input ────────────────────────────────
                      Text(
                        'Crie um PIN',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppTheme.textColorDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          obscureText: _obscurePin,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '••••••',
                            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textColorSecondary,
                              fontSize: 16,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePin ? Icons.visibility_off : Icons.visibility,
                                color: AppTheme.textColorSecondary,
                              ),
                              onPressed: () {
                                setState(() => _obscurePin = !_obscurePin);
                              },
                            ),
                          ),
                          onSubmitted: (_) => _onSignupPressed(context),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Primary Signup Button ──────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryOrange,
                            disabledBackgroundColor: AppTheme.primaryOrange
                                .withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: (_isFormValid && !isLoading)
                              ? () => _onSignupPressed(context)
                              : null,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Criar Conta',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
