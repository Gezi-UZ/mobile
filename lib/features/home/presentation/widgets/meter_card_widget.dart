import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/domain/entities/meter_balance.dart';

class MeterCardWidget extends StatelessWidget {
  final MeterBalance balance;
  final bool isPrimary;

  const MeterCardWidget({
    super.key,
    required this.balance,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 26, right: 26, bottom: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: ShapeDecoration(
              gradient: AppTheme.primaryGradient,
              shape: RoundedRectangleBorder(
                side: isPrimary
                    ? const BorderSide(width: 1.5, color: AppTheme.primaryOrange)
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBalanceRow(context),
                const SizedBox(height: 16),
                _buildMeterInfoRow(context),
              ],
            ),
          ),
          if (isPrimary)
            Positioned(
              top: -10,
              left: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppTheme.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PRINCIPAL',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBalanceRow(BuildContext context) {
    Color iconColor;
    if (balance.kwhBalance >= 5) {
      iconColor = const Color(0xFF008236); // Verde (Com crédito - Sutil)
    } else if (balance.kwhBalance > 0) {
      iconColor = const Color(0xFFFFB300); // Amarelo (Crédito baixo/warning)
    } else {
      iconColor = const Color(0xFFFF3B30); // Vermelho (Sem crédito)
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo actual',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.white.withValues(alpha: 0.70),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                Text(
                  balance.kwhBalance.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'kWh',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.white.withValues(alpha: 0.80),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Ícone do contador
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/recharge_icon.png',
              width: 32,
              height: 32,
              color: iconColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeterInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contador',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.white.withValues(alpha: 0.60),
                fontSize: 10,
              ),
            ),
            Text(
              balance.meterId,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 14,
                color: AppTheme.white,
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            _MeterStatusBadge(isOnline: balance.isOnline),
            Text(
              '· ${_formatTime(balance.lastSyncAt)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.white.withValues(alpha: 0.30),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
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
            ? const Color(0xFFDCFCE7) // verde claro
            : const Color(0xFFF3F4F6), // cinza claro
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
                  : const Color(0xFF9CA3AF), // cinza
              shape: const CircleBorder(),
            ),
          ),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isOnline
                  ? const Color(0xFF008236)
                  : const Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
