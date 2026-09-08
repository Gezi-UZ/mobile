import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';

class RechargeStepConfirm extends StatefulWidget {
  final Function(String?) onConfirm;
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
  State<RechargeStepConfirm> createState() => _RechargeStepConfirmState();
}

class _RechargeStepConfirmState extends State<RechargeStepConfirm> {
  final _phoneController = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        _phoneError = 'O número de telemóvel é obrigatório';
      });
      return;
    }
    if (!phone.startsWith('84') && !phone.startsWith('85')) {
      setState(() {
        _phoneError = 'O número deve começar por 84 ou 85';
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
    });
    widget.onConfirm(phone);
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount = double.tryParse(widget.amount) ?? 0.0;
    const bool isFirstPurchaseOfMonth = true;
    const double ratePerKwh = 7.64;
    double txLixo = 0.0;
    if (isFirstPurchaseOfMonth) {
      if (totalAmount == 100.0) {
        txLixo = 50.0;
      } else if (totalAmount > 100.0) {
        txLixo = 100.0;
      }
    }
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detalhes da recarga',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
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
            onTap: _handleConfirm,
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
          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
