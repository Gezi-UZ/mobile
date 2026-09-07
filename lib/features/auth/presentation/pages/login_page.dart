import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/core/theme/theme.dart';
import '../../../../injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../bloc/local_auth_bloc.dart';
import '../bloc/local_auth_event.dart';
import '../bloc/local_auth_state.dart';
import '../bloc/email_auth/login_bloc.dart';
import '../bloc/email_auth/login_event.dart';
import '../bloc/email_auth/login_state.dart';
import '../widgets/auth_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  
  bool _isFormValid = false;
  bool _obscurePin = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _pinController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _pinController.removeListener(_validateForm);
    _emailController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final email = _emailController.text.trim();
    final pin = _pinController.text.trim();
    
    final emailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final pinValid = pin.length == 6 && RegExp(r'^\d{6}$').hasMatch(pin);
    
    final valid = emailValid && pinValid;
    if (valid != _isFormValid) {
      setState(() => _isFormValid = valid);
    }
  }

  void _onLoginPressed(BuildContext context) {
    if (_isFormValid) {
      context.read<LoginBloc>().add(LoginRequested(
        email: _emailController.text.trim(),
        pin: _pinController.text.trim(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LocalAuthBloc>()),
        BlocProvider(create: (_) => sl<LoginBloc>()),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              // LocalAuthBloc: handles the device biometric prompt result
              BlocListener<LocalAuthBloc, LocalAuthState>(
                listener: (context, state) {
                  if (state is LocalAuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is LocalAuthenticated) {
                    // Biometric prompt passed — now restore Supabase session
                    context.read<AuthBloc>().add(const BiometricLoginRequested());
                  }
                },
              ),
              // LoginBloc: handles email+pin sign in
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    context.read<AuthBloc>().add(SessionObtained(state.session));
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message), backgroundColor: Colors.red.shade700),
                    );
                  }
                },
              ),
              // AuthBloc: handles session availability
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    context.go('/home');
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
              ),
            ],
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, loginState) {
                final isLoading = loginState is LoginLoading;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 56,
                    left: 32,
                    right: 24,
                    bottom: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row (Logo + Gezi)
                      const AuthHeader(),
                      const SizedBox(height: 48),

                      // Title and Subtitle
                      Text(
                        'Bem-vindo ao Gezi',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Introduza o seu email e PIN para entrar.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Email Input ────────────────────────────────
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'exemplo@gezi.com',
                            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // ── PIN Input ────────────────────────────────
                      Text(
                        'PIN (6 dígitos)',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                        child: TextField(
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          obscureText: _obscurePin,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '••••••',
                            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 16,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePin ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              onPressed: () {
                                setState(() => _obscurePin = !_obscurePin);
                              },
                            ),
                          ),
                          onSubmitted: (_) => _onLoginPressed(context),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Primary Login Button ──────────────────────────────
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
                              ? () => _onLoginPressed(context)
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
                                  'Entrar',
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
                      const SizedBox(height: 16),
                      
                      Center(
                        child: TextButton(
                          onPressed: () => context.push('/signup'),
                          child: Text(
                            'Ainda não tem conta? Criar agora',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Passkey / Biometric quick-access ─────────────────
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Ou entre com',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Passkey (Biometrics)
                                _buildQuickOption(
                                  context,
                                  label: 'Biometria',
                                  icon: Icons.fingerprint,
                                  color: AppTheme.primaryOrange,
                                  onTap: () {
                                    context.read<LocalAuthBloc>().add(
                                      const AuthenticateWithBiometricsEvent(),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                // PIN
                                _buildQuickOption(
                                  context,
                                  label: 'PIN Offline',
                                  icon: Icons.pin,
                                  color: AppTheme.primaryOrange,
                                  onTap: () => context.push('/pin-login'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Terms
                      Text(
                        'Ao continuar, aceita os nossos Termos de Serviço e Política de Privacidade.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildQuickOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.08),
            width: 1.11,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
