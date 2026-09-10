import 'package:flutter/material.dart';

import 'package:gezi/features/meter/domain/entities/meter.dart';

class MeterBalanceCard extends StatelessWidget {
  final Meter meter;

  const MeterBalanceCard({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    if (meter.kwhBalance >= 5) {
      iconColor = const Color(0xFF008236); // Verde (Com crédito - Sutil)
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
                        color: Colors.white.withValues(alpha: 0.70),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          meter.kwhBalance.toStringAsFixed(2).replaceAll(RegExp(r'0$'), ''),
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'kWh',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.80),
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
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/recharge_icon.png',
                      width: 28,
                      height: 28,
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                final bool isOnline = () {
                  final sync = meter.lastSyncAt;
                  if (sync == null) return meter.isOnline;
                  return DateTime.now().difference(sync.toLocal()).inMinutes <= 5;
                }();

                return Row(
                  spacing: 8,
                  children: [
                    _MeterStatusBadge(isOnline: isOnline),
                    if (meter.lastSyncAt != null)
                      Text(
                        '· sync ${_formatLastSync(meter.lastSyncAt!)}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 11,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSync(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt.toLocal());
    if (diff.inMinutes < 1) return 'agora mesmo';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) {
      final h = dt.toLocal().hour.toString().padLeft(2, '0');
      final m = dt.toLocal().minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    final d = dt.toLocal().day.toString().padLeft(2, '0');
    final mo = dt.toLocal().month.toString().padLeft(2, '0');
    return '$d/$mo';
  }
}

/// Badge de status de ligação do contador (Online / Offline).
class _MeterStatusBadge extends StatelessWidget {
  final bool isOnline;

  const _MeterStatusBadge({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
        color: isOnline
            ? Colors.white.withValues(alpha: 0.20)
            : Colors.white.withValues(alpha: 0.12),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: ShapeDecoration(
              color: isOnline
                  ? const Color(0xFF00C950) // verde
                  : Colors.white.withValues(alpha: 0.50), // branco semi-transparente
              shape: const CircleBorder(),
            ),
          ),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isOnline
                  ? const Color(0xFFB6FFD6)
                  : Colors.white.withValues(alpha: 0.70),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
