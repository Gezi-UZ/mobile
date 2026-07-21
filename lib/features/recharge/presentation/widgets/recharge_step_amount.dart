import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gezi/core/theme/theme.dart';

class RechargeStepAmount extends StatefulWidget {
  final Function(String) onNext;
  final bool isForSomeone;
  final String meterNumber;

  const RechargeStepAmount({
    super.key,
    required this.onNext,
    this.isForSomeone = false,
    this.meterNumber = '10293847561',
  });

  @override
  State<RechargeStepAmount> createState() => _RechargeStepAmountState();
}

class _RechargeStepAmountState extends State<RechargeStepAmount> {
  final TextEditingController _amountController = TextEditingController();
  final bool _isFirstPurchaseOfMonth = true; // Simulado: 1ª compra do mês

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setAmount(int amount) {
    _amountController.text = amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount = double.tryParse(_amountController.text) ?? 0.0;
    final bool hasAmount = totalAmount > 0;

    // Cálculo conforme guião da EDM (Tarifa Doméstica = 7.64 MT/kWh)
    const double ratePerKwh = 7.64;
    final double txLixo = (_isFirstPurchaseOfMonth && totalAmount >= 100) ? 100.0 : 0.0;
    const double txRadio = 0.0;
    const double dividaPaga = 0.0;
    
    final double remainingAfterFees = (totalAmount - txLixo - txRadio - dividaPaga).clamp(0.0, double.infinity);
    final double valEnergia = remainingAfterFees / 1.16; // Retirando IVA de 16%
    final double iva = remainingAfterFees - valEnergia;
    final double calculatedKwh = remainingAfterFees / ratePerKwh;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Input
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Valor em MZN',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textColorSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'MZN',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppTheme.textColorDark,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            IntrinsicWidth(
                              child: TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(
                                      color: hasAmount
                                          ? AppTheme.primaryOrange
                                          : AppTheme.primaryOrange.withValues(
                                              alpha: 0.5,
                                            ),
                                      fontSize: 48,
                                      fontWeight: FontWeight.w700,
                                    ),
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        color: AppTheme.primaryOrange.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontSize: 48,
                                        fontWeight: FontWeight.w700,
                                      ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (hasAmount) ...[
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.bolt_rounded,
                                color: AppTheme.primaryOrange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '≈ ${calculatedKwh.toStringAsFixed(1)} kWh',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppTheme.primaryOrange,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick Amounts
                  Row(
                    children: [
                      _QuickAmountButton(
                        amount: 100,
                        onTap: () => _setAmount(100),
                      ),
                      const SizedBox(width: 12),
                      _QuickAmountButton(
                        amount: 250,
                        onTap: () => _setAmount(250),
                      ),
                      const SizedBox(width: 12),
                      _QuickAmountButton(
                        amount: 500,
                        onTap: () => _setAmount(500),
                      ),
                      const SizedBox(width: 12),
                      _QuickAmountButton(
                        amount: 1000,
                        onTap: () => _setAmount(1000),
                      ),
                    ],
                  ),

                  if (hasAmount) ...[
                    const SizedBox(height: 24),

                    // Transparência de Taxas e Detalhamento EDM
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: AppTheme.lightOrangeBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: AppTheme.primaryOrange.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long_rounded,
                                color: AppTheme.primaryOrange,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Detalhamento da recarga (EDM)',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: AppTheme.primaryOrange,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            title: 'Contador',
                            value: widget.meterNumber.isNotEmpty ? widget.meterNumber : 'Por selecionar',
                          ),
                          _DetailRow(
                            title: 'Val Energia',
                            value: '${valEnergia.toStringAsFixed(2)} MT',
                          ),
                          _DetailRow(
                            title: 'IVA (16%)',
                            value: '${iva.toStringAsFixed(2)} MT',
                          ),
                          _DetailRow(
                            title: 'Dívida Paga',
                            value: '${dividaPaga.toStringAsFixed(2)} MT',
                          ),
                          _DetailRow(
                            title: 'Tx Rádio',
                            value: '${txRadio.toStringAsFixed(2)} MT',
                          ),
                          _DetailRow(
                            title: 'Tx Lixo (${_isFirstPurchaseOfMonth ? "1ª compra/mês" : "isento"})',
                            value: '${txLixo.toStringAsFixed(2)} MT',
                          ),
                          const Divider(height: 16, thickness: 1, color: Color(0x1F000000)),
                          _DetailRow(
                            title: 'Energia Líquida',
                            value: '${calculatedKwh.toStringAsFixed(2)} kWh',
                            isBold: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Continue Button
          GestureDetector(
            onTap: hasAmount
                ? () => widget.onNext(_amountController.text)
                : null,
            child: Opacity(
              opacity: hasAmount ? 1.0 : 0.50,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  color: hasAmount
                      ? AppTheme.primaryOrange
                      : const Color(0xFFCCCCCC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Continuar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;

  const _DetailRow({
    required this.title,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textColorSecondary,
                  fontSize: 12,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isBold ? AppTheme.primaryOrange : AppTheme.textColorDark,
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

class _QuickAmountButton extends StatelessWidget {
  final int amount;
  final VoidCallback onTap;

  const _QuickAmountButton({required this.amount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.11,
                color: Colors.black.withValues(alpha: 0.08),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            amount.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.textColorDark,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
