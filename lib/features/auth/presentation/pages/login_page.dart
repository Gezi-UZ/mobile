import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import '../widgets/auth_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 56,
            left: 32,
            right: 24,
            bottom: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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

              // Account Selection Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.lightOrangeBackground,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 1.11,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons
                            .person, // Using a standard icon as placeholder for user avatar
                        color: AppTheme.primaryOrange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ana Machava',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppTheme.textColorDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '+258 84 123 4567',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppTheme.textColorSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Primary Action (Passkey)
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryOrange.withValues(
                              alpha: 0.4,
                            ),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: AppTheme.primaryOrange.withValues(
                              alpha: 0.12,
                            ),
                            spreadRadius: 12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.fingerprint, // Placeholder icon for fingerprint
                        color: AppTheme.white,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Toque para entrar com Passkey',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.textColorDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSecondaryAuthOption(
                          context,
                          'Impressão digital',
                          Icons.fingerprint,
                        ),
                        const SizedBox(width: 8),
                        _buildSecondaryAuthOption(context, 'PIN', Icons.pin),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textColorSecondary,
                      ),
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
                  onPressed: () {},
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
    );
  }

  Widget _buildSecondaryAuthOption(
    BuildContext context,
    String text,
    IconData icon,
  ) {
    return Container(
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
          Icon(icon, size: 14, color: AppTheme.textColorDark),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppTheme.textColorDark),
          ),
        ],
      ),
    );
  }
}
