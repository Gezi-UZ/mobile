import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gezi/core/theme/theme.dart';

class RechargeStepMeter extends StatefulWidget {
  final Function(String) onNext;

  const RechargeStepMeter({super.key, required this.onNext});

  @override
  State<RechargeStepMeter> createState() => _RechargeStepMeterState();
}

class _RechargeStepMeterState extends State<RechargeStepMeter> {
  final TextEditingController _meterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _meterController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _meterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid = _meterController.text.length == 11;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: AppTheme.lightOrangeBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.darkerOrange,
                  size: 16,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Introduza o número de 11 dígitos do contador CREDELEC da pessoa que vai receber a energia. Encontra-o na factura CREDELEC ou na caixa do contador.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.darkerOrange,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Input field
          Text(
            'Número do contador (11 dígitos)',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.textColorDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: ShapeDecoration(
              color: const Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.11,
                  color: Colors.black.withValues(alpha: 0.08),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.electric_meter_outlined,
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _meterController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textColorSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.80,
                    ),
                    decoration: InputDecoration(
                      hintText: '00000000000',
                      hintStyle: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(
                            color: AppTheme.textColorSecondary.withValues(
                              alpha: 0.5,
                            ),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.80,
                          ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_meterController.text.length}/11 dígitos',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textColorSecondary,
              fontSize: 12,
            ),
          ),

          const Spacer(),

          // Continue Button
          GestureDetector(
            onTap: isValid ? () => widget.onNext(_meterController.text) : null,
            child: Opacity(
              opacity: isValid ? 1.0 : 0.50,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  color: isValid
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
