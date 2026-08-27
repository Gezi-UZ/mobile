import 'package:flutter/material.dart';
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
import '../widgets/auth_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalAuthBloc>(),
      child: Scaffold(
        backgroundColor: AppTheme.white,
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
              // AuthBloc: handles session restoration result
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
            child: Padding(
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
                    'Bem-vindo de volta',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.textColorDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use a sua passkey para entrar de forma rápida e segura.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textColorSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),



                  const Spacer(),

                  // Primary Action (Passkey)
                  Center(
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            return GestureDetector(
                              onTap: () {
                                context.read<LocalAuthBloc>().add(
                                  const AuthenticateWithBiometricsEvent(),
                                );
                              },
                              child: Container(
                                width: 112,
                                height: 112,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.fingerprint,
                                  color: AppTheme.white,
                                  size: 48,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Toque para entrar com Passkey',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppTheme.textColorDark),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSecondaryAuthOption(
                              context,
                              'PIN',
                              Icons.pin,
                              AppTheme.primaryOrange,
                              onTap: () {
                                context.push('/pin-login');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Or divider
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'ou',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textColorSecondary),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.black.withValues(alpha: 0.08),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.08),
                          width: 1.11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        context.push('/register');
                      },
                      child: Text(
                        'Criar conta nova',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppTheme.textColorDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Terms
                  Text(
                    'Ao continuar, aceita os nossos Termos de Serviço e Política de Privacidade.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryAuthOption(
    BuildContext context,
    String text,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.08),
            width: 1.11,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppTheme.textColorDark),
            ),
          ],
        ),
      ),
    );
  }
}
