import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

/// Placeholder para a tela de perfil do utilizador.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const ShapeDecoration(
                  color: AppTheme.lightOrangeBackground,
                  shape: CircleBorder(),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 48,
                  color: AppTheme.primaryOrange,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Perfil',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.textColorDark,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Em breve',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textColorSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
