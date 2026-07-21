import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class RechargeStepConfirm extends StatelessWidget {
  final VoidCallback onConfirm;
  final String amount;
  final String meterNumber;
  final bool isForSomeone;

  const RechargeStepConfirm({
    super.key,
    required this.onConfirm,
    required this.amount,
    required this.meterNumber,
    this.isForSomeone = false,
  });

  @override
  Widget build(BuildContext context) {
    final double totalAmount = double.tryParse(amount) ?? 0.0;
    const bool isFirstPurchaseOfMonth = true;
    const double ratePerKwh = 7.64;
    final double txLixo = (isFirstPurchaseOfMonth && totalAmount >= 100)
        ? 100.0
        : 0.0;
    const double txRadio = 0.0;
    const double dividaPaga = 0.0;

    final double remainingAfterFees =
        (totalAmount - txLixo - txRadio - dividaPaga).clamp(
          0.0,
          double.infinity,
        );
    final double valEnergia = remainingAfterFees / 1.16;
    final double iva = remainingAfterFees - valEnergia;
    final double calculatedKwh = remainingAfterFees / ratePerKwh;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Método de Pagamento
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: AppTheme.lightOrangeBackground,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1.11,
                          color: AppTheme.primaryOrange,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/mpesa.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Text(
                                      'M',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'M-Pesa',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppTheme.textColorDark,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                'Vodacom M-Pesa',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTheme.textColorSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: ShapeDecoration(
                            color: AppTheme.primaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resumo Detalhado EDM
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: AppTheme.lightOrangeBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes da recarga',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: AppTheme.textColorDark,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _SummaryRow(title: 'Contador', value: meterNumber),
                        const SizedBox(height: 8),
                        _SummaryRow(title: 'Valor total', value: '$amount MZN'),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          title: 'Val Energia',
                          value: '${valEnergia.toStringAsFixed(2)} MT',
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          title: 'IVA (16%)',
                          value: '${iva.toStringAsFixed(2)} MT',
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          title: 'Dívida Paga',
                          value: '${dividaPaga.toStringAsFixed(2)} MT',
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          title: 'Tx Rádio',
                          value: '${txRadio.toStringAsFixed(2)} MT',
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          title: 'Tx Lixo',
                          value: '${txLixo.toStringAsFixed(2)} MT',
                        ),
                        const SizedBox(height: 8),
                        _SummaryRow(
                          title: 'Crédito estimado',
                          value: '${calculatedKwh.toStringAsFixed(2)} kWh',
                        ),
                        const SizedBox(height: 8),
                        const _SummaryRow(title: 'Método', value: 'M-Pesa'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão Confirmar
          GestureDetector(
            onTap: onConfirm,
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
                'Confirmar pagamento · $amount MZN',
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
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textColorSecondary),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textColorDark,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
