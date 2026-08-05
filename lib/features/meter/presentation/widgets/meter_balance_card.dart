import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

import 'package:gezi/features/meter/domain/entities/meter.dart';

class MeterBalanceCard extends StatelessWidget {
  final Meter meter;

  const MeterBalanceCard({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    if (meter.kwhBalance > 20) {
      iconColor = const Color(0xFF00C950); // Verde (Com crédito)
    } else if (meter.kwhBalance > 0) {
      iconColor = const Color(0xFFFFB300); // Amarelo (Crédito baixo/warning)
    } else {
      iconColor = const Color(0xFFFF3B30); // Vermelho (Sem crédito)
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, 0.00),
            end: Alignment(1.00, 1.00),
            colors: [Color(0xFFFF6A00), Color(0xFFE84300)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo actual',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.white.withValues(alpha: 0.70),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          meter.kwhBalance.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: AppTheme.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'kWh',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.white.withValues(alpha: 0.80),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/recharge_icon.png',
                      width: 28,
                      height: 28,
                      color: iconColor, // Dinamicamente aplicando cor ao PNG
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '· sync 14:32',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.white.withValues(alpha: 0.50), // Increased alpha slightly for readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}
