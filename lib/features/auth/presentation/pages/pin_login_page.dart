import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../bloc/local_auth_bloc.dart';
import '../bloc/local_auth_event.dart';
import '../bloc/local_auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/pin_input_field.dart';
import '../../../../injection_container.dart';
import '../../../../core/shared_widgets/buttons/primary_button.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final TextEditingController _pinController = TextEditingController();
  bool _isPinComplete = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onPinChanged(String value) {
    setState(() {
      _isPinComplete = value.length == 6;
    });
  }

  void _onLoginPressed(BuildContext context) {
    if (_isPinComplete) {
      final pin = _pinController.text.trim();
      context.read<AuthBloc>().add(PinLoginRequested(pin));
    }
  }

  void _onUseFingerprintPressed(BuildContext context) {
    // Trigger device biometric prompt via LocalAuthBloc
    context.read<LocalAuthBloc>().add(const AuthenticateWithBiometricsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalAuthBloc>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                context.go('/home');
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<LocalAuthBloc, LocalAuthState>(
            listener: (context, state) {
              if (state is LocalAuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is LocalAuthenticated) {
                // Biometric prompt passed — now restore Supabase session
                context.read<AuthBloc>().add(const BiometricLoginRequested());
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: AppTheme.white,
              body: SafeArea(
                child: Padding(
              padding: const EdgeInsets.only(
                top: 56,
                left: 24,
                right: 24,
                bottom: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const AuthHeader(title: 'Entrar'),
                  const SizedBox(height: 48),

                  // Title and Subtitle
                  Text(
                    'Entrar com PIN',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppTheme.textColorDark,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Introduza o PIN de 6 dígitos que definiu quando criou a sua passkey.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textColorSecondary,
                      fontSize: 14,
                      height: 1.63,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // PIN Input Field
                  PinInputField(
                    controller: _pinController,
                    length: 6,
                    autofocus: true,
                    onChanged: _onPinChanged,
                  ),
                  const SizedBox(height: 12),

                  const Spacer(),

                  // Primary Login Button
                  PrimaryButton(
                    text: 'Entrar',
                    onPressed: _isPinComplete ? () => _onLoginPressed(context) : null,
                  ),
                  const SizedBox(height: 12),

                  // Secondary Fingerprint Option Button
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _onUseFingerprintPressed(context),
                      icon: const Icon(
                        Icons.fingerprint,
                        size: 16,
                        color: AppTheme.primaryOrange,
                      ),
                      label: Text(
                        'Usar impressão digital',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppTheme.primaryOrange,
                              fontSize: 14,
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
          },
        ),
      ),
    );
  }
}
