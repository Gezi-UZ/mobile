import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gezi/core/theme/theme.dart';
import '../widgets/transaction_list_item.dart';

class ReportListPage extends StatelessWidget {
  const ReportListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        title: Text(
          'Relatórios',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textColorDark,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.textColorDark),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Histórico de Transações',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textColorSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  // Mock data for UI testing
                  final isCredit = index % 3 == 0; // Example condition
                  return InkWell(
                    onTap: () {
                      context.push('/receipt_preview');
                    },
                    child: TransactionListItem(
                      title: isCredit ? 'Recarga de Saldo' : 'Pagamento de Serviço',
                      date: '12 Outubro 2023, 14:${10 + index}',
                      amount: '${(index + 1) * 1500} MT',
                      isCredit: isCredit,
                      icon: isCredit ? Icons.add_card : Icons.receipt_long,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
