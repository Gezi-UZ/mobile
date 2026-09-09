import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import '../../domain/entities/recharge_breakdown.dart';
import '../bloc/recharge_bloc.dart';
import '../../../../injection_container.dart';
import '../../../meter/domain/usecases/ping_meter.dart';

class RechargeStepConfirm extends StatefulWidget {
  final Function(String?) onConfirm;
  final String amount;
  final String meterNumber;
  final String meterId;
  final bool isForSomeone;

  const RechargeStepConfirm({
    super.key,
    required this.onConfirm,
    required this.amount,
    required this.meterNumber,
    required this.meterId,
    this.isForSomeone = false,
  });

  @override
  State<RechargeStepConfirm> createState() => _RechargeStepConfirmState();
}

class _RechargeStepConfirmState extends State<RechargeStepConfirm> {
  final _phoneController = TextEditingController();
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    // Fetch the real breakdown from the backend as soon as this step appears.
    // This ensures is_primeira_compra_mes is determined server-side correctly.
    final amount = double.tryParse(widget.amount) ?? 0.0;
    if (amount > 0 && widget.meterId.isNotEmpty) {
      context.read<RechargeBloc>().add(CalculateBreakdownEvent(
        amount: amount,
        meterId: widget.meterId,
      ));
    }
  }

  @override
  void didUpdateWidget(RechargeStepConfirm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refetch if amount or meterId changed (e.g. user went back and changed them)
    if (oldWidget.amount != widget.amount || oldWidget.meterId != widget.meterId) {
      final amount = double.tryParse(widget.amount) ?? 0.0;
      if (amount > 0 && widget.meterId.isNotEmpty) {
        context.read<RechargeBloc>().add(CalculateBreakdownEvent(
          amount: amount,
          meterId: widget.meterId,
        ));
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _isPinging = false;

  void _handleConfirm() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        _phoneError = 'O número de telemóvel é obrigatório';
      });
      return;
    }
    if (!phone.startsWith('84') && !phone.startsWith('85') && !phone.startsWith('86') && !phone.startsWith('87')) {
      setState(() {
        _phoneError = 'O número deve começar por 84, 85, 86 ou 87';
      });
      return;
    }
    if (phone.length != 9) {
      setState(() {
        _phoneError = 'O número deve ter 9 dígitos';
      });
      return;
    }
    setState(() {
      _phoneError = null;
      _isPinging = true;
    });

    // Ping the meter to check online status
    final pingMeterUseCase = sl<PingMeter>();
    final result = await pingMeterUseCase(widget.meterId);
    
    if (mounted) {
      setState(() {
        _isPinging = false;
      });
    }

    bool isOnline = true;
    result.fold(
      (failure) => isOnline = false, // If error, assume offline for fallback
      (online) => isOnline = online,
    );

    if (!isOnline && mounted) {
      // Show confirmation dialog for offline meter
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Contador Offline'),
          content: const Text(
            'O contador parece estar offline ou sem ligação à internet.\n\n'
            'A compra de energia não será interrompida, mas será gerado um '
            'Código Manual (STS) de 20 dígitos que deverá ser introduzido '
            'manualmente no contador.\n\n'
            'Deseja prosseguir com o pagamento?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryOrange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Prosseguir'),
            ),
          ],
        ),
      );

      if (confirm != true) {
        return; // User cancelled
      }
    }

    widget.onConfirm(phone);
  }

  /// Fallback local calculation (used while the backend response loads).
  /// Note: always assumes isFirstPurchaseOfMonth = false (conservative).
  _FallbackBreakdown _localFallback() {
    final double totalAmount = double.tryParse(widget.amount) ?? 0.0;
    const double ratePerKwh = 7.64;
    final double remainingAfterFees = totalAmount.clamp(0.0, double.infinity);
    final double valEnergia = remainingAfterFees / 1.17;
    final double iva = remainingAfterFees - valEnergia;
    final double calculatedKwh = valEnergia / ratePerKwh;
    return _FallbackBreakdown(
      valEnergia: valEnergia,
      iva: iva,
      txLixo: 0.0,
      txRadio: 0.0,
      dividaPaga: 0.0,
      calculatedKwh: calculatedKwh,
      isFirstPurchaseOfMonth: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RechargeBloc, RechargeState>(
      builder: (context, state) {
        // Use backend breakdown when available; otherwise use conservative local fallback.
        final bool isLoadingBreakdown = state is RechargeLoading;
        RechargeBreakdown? breakdown;
        if (state is RechargeBreakdownLoaded) {
          breakdown = state.breakdown;
        }
        final fb = _localFallback();

        final double valEnergia = breakdown?.valEnergia ?? fb.valEnergia;
        final double iva = breakdown?.iva ?? fb.iva;
        final double txLixo = breakdown?.txLixo ?? fb.txLixo;
        final double txRadio = breakdown?.txRadio ?? fb.txRadio;
        final double dividaPaga = breakdown?.dividaPaga ?? fb.dividaPaga;
        final double calculatedKwh = breakdown?.calculatedKwh ?? fb.calculatedKwh;
        final bool isFirstPurchase = breakdown?.isFirstPurchaseOfMonth ?? false;

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
                          color: Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
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
                                          color: Theme.of(context).colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  Text(
                                    'Vodacom M-Pesa',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
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

                      // Número de telemóvel obrigatório
                      Text(
                        'Número de telemóvel M-Pesa',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ex: 841234567',
                          errorText: _phoneError,
                          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                          counterText: '',
                          filled: true,
                          fillColor: Theme.of(context).extension<AppColorsExtension>()?.inputBackground ?? const Color(0xFFF9FAFB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppTheme.primaryOrange),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                        ),
                        onChanged: (value) {
                          if (_phoneError != null) {
                            setState(() {
                              _phoneError = null;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // Resumo Detalhado EDM
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoadingBreakdown
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Detalhes da recarga',
                                        style: Theme.of(context).textTheme.titleSmall
                                            ?.copyWith(
                                              color: Theme.of(context).colorScheme.onSurface,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      if (isFirstPurchase) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.primaryOrange.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '1ª compra do mês',
                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: AppTheme.primaryOrange,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _SummaryRow(title: 'Contador', value: widget.meterNumber),
                                  const SizedBox(height: 8),
                                  _SummaryRow(title: 'Valor total', value: '${widget.amount} MT'),
                                  const SizedBox(height: 8),
                                  _SummaryRow(
                                    title: 'Val Energia',
                                    value: '${valEnergia.toStringAsFixed(2)} MT',
                                  ),
                                  const SizedBox(height: 8),
                                  _SummaryRow(
                                    title: 'IVA (17%)',
                                    value: '${iva.toStringAsFixed(2)} MT',
                                  ),
                                  if (dividaPaga > 0) ...[
                                    const SizedBox(height: 8),
                                    _SummaryRow(
                                      title: 'Dívida Paga',
                                      value: '${dividaPaga.toStringAsFixed(2)} MT',
                                    ),
                                  ],
                                  if (txRadio > 0) ...[
                                    const SizedBox(height: 8),
                                    _SummaryRow(
                                      title: 'Tx Rádio',
                                      value: '${txRadio.toStringAsFixed(2)} MT',
                                    ),
                                  ],
                                  if (txLixo > 0) ...[
                                    const SizedBox(height: 8),
                                    _SummaryRow(
                                      title: 'Tx Lixo',
                                      value: '${txLixo.toStringAsFixed(2)} MT',
                                      isHighlighted: true,
                                    ),
                                  ] else ...[
                                    const SizedBox(height: 8),
                                    _SummaryRow(
                                      title: 'Tx Lixo',
                                      value: 'Isento',
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  _SummaryRow(
                                    title: 'Crédito estimado',
                                    value: '${calculatedKwh.toStringAsFixed(2)} kWh',
                                    isBold: true,
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
                onTap: _isPinging ? null : _handleConfirm,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: ShapeDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isPinging 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Confirmar pagamento · ${widget.amount} MT',
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
      },
    );
  }
}

class _FallbackBreakdown {
  final double valEnergia;
  final double iva;
  final double txLixo;
  final double txRadio;
  final double dividaPaga;
  final double calculatedKwh;
  final bool isFirstPurchaseOfMonth;

  _FallbackBreakdown({
    required this.valEnergia,
    required this.iva,
    required this.txLixo,
    required this.txRadio,
    required this.dividaPaga,
    required this.calculatedKwh,
    required this.isFirstPurchaseOfMonth,
  });
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isBold;
  final bool isHighlighted;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isBold = false,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isHighlighted
                ? Colors.orange.shade700
                : isBold
                    ? AppTheme.primaryOrange
                    : Theme.of(context).colorScheme.onSurface,
            fontSize: 12,
            fontWeight: (isBold || isHighlighted) ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
