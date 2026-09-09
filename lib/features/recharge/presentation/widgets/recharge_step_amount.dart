import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import '../bloc/recharge_bloc.dart';

class RechargeStepAmount extends StatefulWidget {
  final Function(String) onNext;
  final bool isForSomeone;
  final String meterId;
  final String meterNumber;

  const RechargeStepAmount({
    super.key,
    required this.onNext,
    this.isForSomeone = false,
    this.meterId = '', // Certifique-se de passar o ID real do contador
    this.meterNumber = '',
  });

  @override
  State<RechargeStepAmount> createState() => _RechargeStepAmountState();
}

class _RechargeStepAmountState extends State<RechargeStepAmount> {
  final TextEditingController _amountController = TextEditingController();
  Timer? _debounce;
  bool _isUnderMinimum = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    final double totalAmount = double.tryParse(_amountController.text) ?? 0.0;
    
    setState(() {
      _isUnderMinimum = totalAmount > 0 && totalAmount < 10.0;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (totalAmount >= 10.0 && widget.meterId.isNotEmpty) {
        context.read<RechargeBloc>().add(
          CalculateBreakdownEvent(
            amount: totalAmount,
            meterId: widget.meterId,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
    final bool isValidAmount = totalAmount >= 10.0;

    return BlocBuilder<RechargeBloc, RechargeState>(
      builder: (context, state) {
        double valEnergia = 0.0;
        double iva = 0.0;
        double dividaPaga = 0.0;
        double txRadio = 0.0;
        double txLixo = 0.0;
        double calculatedKwh = 0.0;
        bool isLoading = false;

        if (state is RechargeLoading) {
          isLoading = true;
        } else if (state is RechargeBreakdownLoaded) {
          final breakdown = state.breakdown;
          valEnergia = breakdown.valEnergia;
          iva = breakdown.iva;
          dividaPaga = breakdown.dividaPaga;
          txRadio = breakdown.txRadio;
          txLixo = breakdown.txLixo;
          calculatedKwh = breakdown.calculatedKwh;
        } else if (state is RechargeError) {
          // You could show a snackbar or inline error here
        }

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
                          color: Theme.of(context).extension<AppColorsExtension>()!.inputBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Valor em MT',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                            color: AppTheme.primaryOrange
                                                .withValues(alpha: 0.5),
                                            fontSize: 48,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'MT',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            if (_isUnderMinimum) ...[
                              const SizedBox(height: 8),
                              Text(
                                'O valor mínimo é 10 MT',
                                style: TextStyle(color: Colors.red.shade400, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                            if (isValidAmount && calculatedKwh > 0) ...[
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (isLoading)
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryOrange),
                                    )
                                  else ...[
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
                      if (isValidAmount && calculatedKwh > 0) ...[
                        const SizedBox(height: 24),
                        // Transparência de Taxas e Detalhamento EDM
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: ShapeDecoration(
                            color: Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: AppTheme.primaryOrange.withValues(
                                  alpha: 0.2,
                                ),
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
                                    style: Theme.of(context).textTheme.titleSmall
                                        ?.copyWith(
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
                                value: widget.meterNumber.isNotEmpty
                                    ? widget.meterNumber
                                    : 'Por selecionar',
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
                                title: 'Tx Lixo',
                                value: '${txLixo.toStringAsFixed(2)} MT',
                              ),
                              const Divider(
                                height: 16,
                                thickness: 1,
                                color: Color(0x1F000000),
                              ),
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
                onTap: isValidAmount && calculatedKwh > 0 && !isLoading
                    ? () => widget.onNext(_amountController.text)
                    : null,
                child: Opacity(
                  opacity: isValidAmount && calculatedKwh > 0 && !isLoading ? 1.0 : 0.50,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: ShapeDecoration(
                      color: isValidAmount && calculatedKwh > 0
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
      },
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
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isBold ? AppTheme.primaryOrange : Theme.of(context).colorScheme.onSurface,
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
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.11,
                color: Theme.of(context).extension<AppColorsExtension>()?.dividerColor ?? Colors.grey.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            amount.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
