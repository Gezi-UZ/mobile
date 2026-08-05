import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';

class MeterRecentTransactions extends StatelessWidget {
  final List<Recharge> recharges;

  const MeterRecentTransactions({super.key, required this.recharges});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ÚLTIMAS TRANSACÇÕES',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.textColorSecondary,
              letterSpacing: 0.30,
            ),
          ),
          if (recharges.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Nenhuma transacção recente',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColorSecondary,
                ),
              ),
            )
          else
            ...recharges.map((recharge) {
              final isSuccess = recharge.status == RechargeStatus.success;
              final isPending = recharge.status == RechargeStatus.pending;
              final provider = 'M-PESA'; // Mock provider since Recharge doesn't have paymentMethod yet
              final dateStr = _formatDate(recharge.rechargedAt);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildTransactionItem(
                  context,
                  '${recharge.kwhAmount.toStringAsFixed(1)} kWh',
                  '$dateStr · $provider',
                  isSuccess,
                  isPending,
                ),
              );
            }),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Widget _buildTransactionItem(BuildContext context, String amount, String details, bool isSuccess, bool isPending) {
    final statusColor = isSuccess ? const Color(0xFF22C55E) : (isPending ? const Color(0xFFFFB300) : const Color(0xFFFF3B30));
    final statusBg = isSuccess ? const Color(0xFFDCFCE7) : (isPending ? const Color(0xFFFFF8E1) : const Color(0xFFFFEDED));
    final statusText = isSuccess ? 'Sucesso' : (isPending ? 'Pendente' : 'Falhou');
    final statusTextColor = isSuccess ? const Color(0xFF008236) : (isPending ? const Color(0xFFF57F17) : const Color(0xFFD32F2F));
    final iconData = isSuccess ? Icons.check_circle_outline : (isPending ? Icons.access_time : Icons.error_outline);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1.11,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                iconData,
                color: statusColor,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.textColorDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  details,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColorSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(37282700),
            ),
            child: Text(
              statusText,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: statusTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
