import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/injection_container.dart';
import '../../../meter/domain/entities/meter.dart';
import '../../../meter/domain/usecases/validate_meter_by_serial.dart';

class RechargeStepMeter extends StatefulWidget {
  final Function(String id, String number) onNext;

  const RechargeStepMeter({super.key, required this.onNext});

  @override
  State<RechargeStepMeter> createState() => _RechargeStepMeterState();
}

class _RechargeStepMeterState extends State<RechargeStepMeter> {
  final TextEditingController _meterController = TextEditingController();
  bool _isValidating = false;
  Meter? _validatedMeter;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _meterController.addListener(_onMeterChanged);
  }

  void _onMeterChanged() {
    final text = _meterController.text.trim();
    if (text.length == 11) {
      _validateMeter(text);
    } else {
      if (_validatedMeter != null || _validationError != null || _isValidating) {
        setState(() {
          _validatedMeter = null;
          _validationError = null;
          _isValidating = false;
        });
      } else {
        setState(() {});
      }
    }
  }

  Future<void> _validateMeter(String serialNumber) async {
    setState(() {
      _isValidating = true;
      _validationError = null;
      _validatedMeter = null;
    });

    final validateUseCase = sl<ValidateMeterBySerial>();
    final result = await validateUseCase(
      ValidateMeterParams(serialNumber: serialNumber),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isValidating = false;
          _validationError = failure.message;
          _validatedMeter = null;
        });
      },
      (meter) {
        setState(() {
          _isValidating = false;
          _validationError = null;
          _validatedMeter = meter;
        });
      },
    );
  }

  @override
  void dispose() {
    _meterController.removeListener(_onMeterChanged);
    _meterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _validatedMeter != null && !_isValidating;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Theme.of(context).extension<AppColorsExtension>()!.lightOrangeBackground,
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
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: ShapeDecoration(
              color: Theme.of(context).extension<AppColorsExtension>()!.inputBackground,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.11,
                  color: _validatedMeter != null
                      ? Colors.green
                      : _validationError != null
                          ? Colors.red
                          : Colors.black.withValues(alpha: 0.08),
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.80,
                    ),
                    decoration: InputDecoration(
                      hintText: '00000000000',
                      hintStyle: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(
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
                if (_isValidating)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryOrange,
                      ),
                    ),
                  )
                else if (_validatedMeter != null)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 20,
                  )
                else if (_validationError != null)
                  const Icon(
                    Icons.cancel_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Status message
          if (_isValidating)
            Text(
              'A validar contador no sistema EDM...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryOrange,
                fontSize: 12,
              ),
            )
          else if (_validatedMeter != null)
            Text(
              '✓ Contador reconhecido: ${_validatedMeter!.alias.isNotEmpty ? _validatedMeter!.alias : 'EDM Válido'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            )
          else if (_validationError != null)
            Text(
              '✗ $_validationError',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            )
          else
            Text(
              '${_meterController.text.length}/11 dígitos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),

          const Spacer(),

          // Continue Button
          GestureDetector(
            onTap: canContinue
                ? () {
                    final id = _validatedMeter?.id ?? '';
                    final number = _validatedMeter?.serialNumber ?? _meterController.text;
                    widget.onNext(id.isNotEmpty ? id : number, number);
                  }
                : null,
            child: Opacity(
              opacity: canContinue ? 1.0 : 0.50,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: ShapeDecoration(
                  color: canContinue
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
