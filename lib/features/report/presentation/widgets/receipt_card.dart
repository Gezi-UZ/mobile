import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class ReceiptCard extends StatelessWidget {
  final String date;
  final String amount;
  final String phoneNumber;
  final String transactionId;
  final String status;
  final String title;

  const ReceiptCard({
    super.key,
    required this.date,
    required this.amount,
    required this.phoneNumber,
    required this.transactionId,
    this.status = 'Concluído',
    this.title = 'Comprovativo de Recarga',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Theme.of(context).extension<AppColorsExtension>()!.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gezi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Icon(
                Icons.check_circle,
                color: Theme.of(context).extension<AppColorsExtension>()!.successColor,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Divider(color: Theme.of(context).extension<AppColorsExtension>()!.dividerColor),
          const SizedBox(height: 24),

          // Title
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 32),

          // Details
          _buildDetailRow(context, 'Data', date),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'Nº Telefone', phoneNumber),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'ID Transação', transactionId),
          const SizedBox(height: 16),
          _buildDetailRow(context, 'Estado', status, valueColor: Theme.of(context).extension<AppColorsExtension>()!.successColor),
          const SizedBox(height: 32),
          Divider(color: Theme.of(context).extension<AppColorsExtension>()!.dividerColor),
          const SizedBox(height: 24),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pago',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                amount,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
