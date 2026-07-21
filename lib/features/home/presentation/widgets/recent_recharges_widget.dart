import 'package:flutter/material.dart';
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
                  color: AppTheme.textColorDark,
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
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF0F0F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recharges.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                thickness: 1,
                indent: 56,
                color: Color(0xFFF5F5F5),
              ),
              itemBuilder: (context, index) {
                return _RechargeItem(recharge: recharges[index]);
              },
            ),
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
    final isSuccess = recharge.status == RechargeStatus.success;
    final isPending = recharge.status == RechargeStatus.pending;

    final statusColor = isSuccess
        ? const Color(0xFF00C950)
        : isPending
        ? const Color(0xFFFFB300)
        : const Color(0xFFFF3B30);

    final statusBg = isSuccess
        ? const Color(0xFFDCFCE7)
        : isPending
        ? const Color(0xFFFFF8E1)
        : const Color(0xFFFFEDED);

    final statusLabel = isSuccess
        ? 'Sucesso'
        : isPending
        ? 'Pendente'
        : 'Falhou';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Ícone
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.lightOrangeBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/images/recharge_icon.png',
              color: AppTheme.primaryOrange,
              height: 12,
              width: 12,
            ),
          ),
          const SizedBox(width: 12),
          // Dados da recarga
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${recharge.kwhAmount.toStringAsFixed(0)} kWh',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textColorDark,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(recharge.rechargedAt),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Valor + estado
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatAmount(recharge.paidAmount)} ${recharge.currency}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.textColorDark,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
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
