import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

/// Placeholder para a tela de lista de contadores.
class MeterListPage extends StatelessWidget {
  const MeterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.electric_meter_outlined,
                  size: 64, color: AppTheme.primaryOrange.withValues(alpha: 0.4)),
              const SizedBox(height: 16),
              Text(
                'Meus Contadores',
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
