import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/auth_header.dart';
import '../widgets/pin_input_field.dart';
import '../widgets/user_profile_card.dart';

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

  void _onLoginPressed() {
    if (_isPinComplete) {
      // Execute PIN authentication logic
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Autenticando PIN: ${_pinController.text}...')),
      // );
      context.go('/home');
    }
  }

  void _onUseFingerprintPressed() {
    // Navigate or trigger biometric authentication
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
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

              // User Profile Card
              const Center(
                child: UserProfileCard(
                  userName: 'Dai Wen Xuan',
                  phoneNumber: '+258 83 361 7829',
                ),
              ),
              const SizedBox(height: 40),

              // PIN Input Field
              PinInputField(
                controller: _pinController,
                length: 6,
                autofocus: true,
                onChanged: _onPinChanged,
                onCompleted: (pin) => _onLoginPressed(),
              ),
              const SizedBox(height: 12),

              const Spacer(),

              // Primary Login Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: _isPinComplete ? _onLoginPressed : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: _isPinComplete
                          ? AppTheme.primaryGradient
                          : null,
                      color: _isPinComplete
                          ? null
                          : AppTheme.textColorDark.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Entrar',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Secondary Fingerprint Option Button
              Center(
                child: TextButton.icon(
                  onPressed: _onUseFingerprintPressed,
                  icon: const Icon(
                    Icons.fingerprint,
                    size: 16,
                    color: AppTheme.primaryOrange,
                  ),
                  label: Text(
                    'Usar impressão digital',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
  }
}
