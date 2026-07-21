import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RechargeReceiptPage extends StatelessWidget {
  final String amount;
  final String meterNumber;
  final bool isCodeRecharge;
  final String? code;

  const RechargeReceiptPage({
    super.key,
    required this.amount,
    required this.meterNumber,
    this.isCodeRecharge = false,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    final double totalAmount = double.tryParse(amount) ?? 0.0;
    const bool isFirstPurchaseOfMonth = true;
    const double ratePerKwh = 7.64;
    final double txLixo = (isFirstPurchaseOfMonth && totalAmount >= 100) ? 100.0 : 0.0;
    const double txRadio = 0.0;
    const double dividaPaga = 0.0;
    
    final double remainingAfterFees = (totalAmount - txLixo - txRadio - dividaPaga).clamp(0.0, double.infinity);
    final double valEnergia = remainingAfterFees / 1.16;
    final double iva = remainingAfterFees - valEnergia;
    final double estimatedKwh = isCodeRecharge ? 150.0 : (remainingAfterFees / ratePerKwh);
    
    // Mock data for receipt
    final String transactionId = 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final String dateStr = DateFormat('dd/MM/yyyy · HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            const Padding(
              padding: EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 4),
              child: SizedBox(height: 24),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ícone principal
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF00C950),
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Títulos
                    Text(
                      'Recarga concluída!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${estimatedKwh.toStringAsFixed(1)} kWh adicionados ao seu contador',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textColorSecondary,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Comprovativo Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: AppTheme.lightOrangeBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Comprovativo
                          Container(
                            padding: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.11,
                                  color: Colors.black.withValues(alpha: 0.08),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.receipt_long_outlined,
                                  color: AppTheme.primaryOrange,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'COMPROVATIVO',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppTheme.primaryOrange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.30,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Rows
                          _ReceiptRow(title: 'Ref ID do Pagamento', value: transactionId),
                          _ReceiptRow(title: 'Data e hora', value: dateStr),
                          _ReceiptRow(title: 'Contador', value: meterNumber),
                          if (isCodeRecharge)
                            _ReceiptRow(title: 'Código aplicado', value: '${code?.substring(0, 4)}...${code?.substring((code?.length ?? 4) - 4)}')
                          else ...[
                            _ReceiptRow(title: 'Valor pago', value: '$amount MZN'),
                            _ReceiptRow(title: 'Val Energia', value: '${valEnergia.toStringAsFixed(2)} MT'),
                            _ReceiptRow(title: 'IVA (16%)', value: '${iva.toStringAsFixed(2)} MT'),
                            _ReceiptRow(title: 'Dívida Paga', value: '${dividaPaga.toStringAsFixed(2)} MT'),
                            _ReceiptRow(title: 'Tx Rádio', value: '${txRadio.toStringAsFixed(2)} MT'),
                            _ReceiptRow(title: 'Tx Lixo', value: '${txLixo.toStringAsFixed(2)} MT'),
                          ],
                          _ReceiptRow(title: 'Crédito aplicado', value: '${estimatedKwh.toStringAsFixed(1)} kWh'),
                          _ReceiptRow(title: 'Método', value: isCodeRecharge ? 'Código STS' : 'M-Pesa'),
                          
                          // Status Row (Verde)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estado',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppTheme.textColorSecondary,
                                        fontSize: 14,
                                      ),
                                ),
                                Text(
                                  'Concluído',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: const Color(0xFF00A63E),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Actions
                    _SecondaryButton(
                      title: 'Partilhar comprovativo',
                      icon: Icons.share_outlined,
                      onTap: () {
                        // TODO: Implement share
                      },
                    ),
                    const SizedBox(height: 12),
                    _SecondaryButton(
                      title: 'Guardar PDF',
                      icon: Icons.download_outlined,
                      onTap: () {
                        // TODO: Implement save PDF
                      },
                    ),
                    const SizedBox(height: 12),
                    
                    // Voltar Button
                    GestureDetector(
                      onTap: () => context.go('/home'),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: ShapeDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Voltar ao início',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String title;
  final String value;

  const _ReceiptRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1.11,
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ),
        ),
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textColorSecondary,
                    fontSize: 14,
                  ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textColorDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.11,
              color: Colors.black.withValues(alpha: 0.08),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryOrange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppTheme.textColorDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
