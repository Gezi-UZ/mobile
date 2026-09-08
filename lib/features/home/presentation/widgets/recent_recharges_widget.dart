import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';

/// Sumário das últimas 5 recargas do utilizador.
class RecentRechargesWidget extends StatelessWidget {
  final List<Recharge> recharges;
  final VoidCallback? onSeeAll;

  const RecentRechargesWidget({
    super.key,
    required this.recharges,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (recharges.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da secção
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Últimas recargas',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                ),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Text(
                    'Ver todas',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Lista de itens
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recharges.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _RechargeItem(recharge: recharges[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _RechargeItem extends StatelessWidget {
  final Recharge recharge;

  const _RechargeItem({required this.recharge});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSuccess = recharge.status == RechargeStatus.success;
    final isPending = recharge.status == RechargeStatus.pending;

    final statusColor = isSuccess
        ? const Color(0xFF00C950)
        : isPending
        ? const Color(0xFFFFB300)
        : const Color(0xFFFF3B30);

    final statusBg = isSuccess
        ? (isDark ? const Color(0xFF052E16) : const Color(0xFFDCFCE7))
        : isPending
        ? (isDark ? const Color(0xFF3D2600) : const Color(0xFFFFF8E1))
        : (isDark ? const Color(0xFF450A0A) : const Color(0xFFFFEDED));

    final isMyMeter = recharge.isMyMeter;
    final badgeColor = isMyMeter
        ? (isDark ? const Color(0xFFFF8C38) : const Color(0xFFFF6A00))
        : (isDark ? const Color(0xFFFFC107) : const Color(0xFF8A5500));
    final badgeBgColor = isMyMeter
        ? (isDark ? const Color(0x33FF6A00) : const Color(0x11FF6A00))
        : (isDark ? const Color(0x33FFB300) : const Color(0x17FFB300));
    final badgeText = isMyMeter ? 'Meu' : 'Outro';

    final meterText = isMyMeter
        ? (recharge.meterAlias != null && recharge.meterAlias!.isNotEmpty
            ? '${recharge.meterAlias} • ${recharge.meterSerialNumber}'
            : recharge.meterSerialNumber)
        : recharge.meterSerialNumber;
    final dateText = _formatDate(recharge.rechargedAt);

    final secondaryTextColor = isDark ? Colors.white60 : const Color(0xFF666666);

    return GestureDetector(
      onTap: () {
        context.push('/recharge_detail', extra: recharge);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: ShapeDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isDark ? Colors.white.withValues(alpha: 0.10) : Colors.black.withValues(alpha: 0.08),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Barra lateral de status
              Container(
                width: 4,
                decoration: ShapeDecoration(
                  color: statusColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Ícone
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/recharge_icon.png',
                    color: statusColor,
                    height: 16,
                    width: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Dados da recarga
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${recharge.kwhAmount.toStringAsFixed(1)} kWh',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$meterText · $dateText',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: secondaryTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Valor + pequeno icone de status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_formatAmount(recharge.paidAmount)} ${recharge.currency}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right,
                    color: secondaryTextColor,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'Há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Há ${diff.inHours}h';
    if (diff.inDays == 1) return 'Ontem';
    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}';
  }

  String _formatAmount(double amount) {
    return amount
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
}
