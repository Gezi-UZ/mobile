import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/domain/entities/meter_balance.dart';

class MeterCardWidget extends StatelessWidget {
  final MeterBalance balance;
  final bool isPrimary;
  final String meterAlias;

  const MeterCardWidget({
    super.key,
    required this.balance,
    this.isPrimary = false,
    required this.meterAlias,
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
                    Icon(
                      Icons.star_rounded,
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'PRINCIPAL',
                      style: const TextStyle(
                        color: Colors.white,
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
                color: Colors.white.withValues(alpha: 0.70),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 8,
              children: [
                Text(
                  balance.kwhBalance.toStringAsFixed(2).replaceAll(RegExp(r'0$'), ''),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'kWh',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.80),
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
            color: Colors.white.withValues(alpha: 0.15),
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
    final bool isOnline = () {
      if (!balance.isOnline) return false;
      final sync = balance.lastSyncAt;
      return DateTime.now().difference(sync.toLocal()).inMinutes <= 5;
    }();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meterAlias,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.70),
                fontSize: 10,
              ),
            ),
            Text(
              balance.meterId,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            _MeterStatusBadge(isOnline: isOnline),
            Text(
              '· ${_formatLastSync(balance.lastSyncAt)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
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
