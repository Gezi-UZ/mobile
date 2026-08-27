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
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.dividerColor),
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
                color: AppTheme.successColor,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: 24),

          // Title
          Center(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textColorDark,
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
          _buildDetailRow(context, 'Estado', status, valueColor: AppTheme.successColor),
          const SizedBox(height: 32),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: 24),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pago',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textColorDark,
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
                color: AppTheme.textColorSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor ?? AppTheme.textColorDark,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
