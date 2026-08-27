import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import '../widgets/receipt_card.dart';
import '../utils/receipt_pdf_generator.dart';

class ReceiptPreviewPage extends StatelessWidget {
  const ReceiptPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightOrangeBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.lightOrangeBackground,
        elevation: 0,
        title: Text(
          'Comprovativo',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.textColorDark,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppTheme.textColorDark),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ReceiptCard(
                    date: '12 Outubro 2023, 14:15',
                    amount: '5000 MT',
                    phoneNumber: '+244 923 456 789',
                    transactionId: 'TXN-987654321',
                    status: 'Concluído',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('A preparar PDF...')),
                    );
                    try {
                      await ReceiptPdfGenerator.generateAndShare(
                        date: '12 Outubro 2023, 14:15',
                        amount: '5000 MT',
                        phoneNumber: '+244 923 456 789',
                        transactionId: 'TXN-987654321',
                        status: 'Concluído',
                        title: 'Comprovativo de Recarga',
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao gerar PDF.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Exportar PDF'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('A preparar comprovativo...')),
                    );
                    try {
                      await ReceiptPdfGenerator.generateAndShare(
                        date: '12 Outubro 2023, 14:15',
                        amount: '5000 MT',
                        phoneNumber: '+244 923 456 789',
                        transactionId: 'TXN-987654321',
                        status: 'Concluído',
                        title: 'Comprovativo de Recarga',
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao gerar comprovativo.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.share, color: AppTheme.primaryOrange),
                  label: const Text(
                    'Partilhar Comprovativo',
                    style: TextStyle(color: AppTheme.primaryOrange),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppTheme.primaryOrange, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
