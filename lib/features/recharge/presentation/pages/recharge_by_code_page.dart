import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:gezi/injection_container.dart';
import 'package:go_router/go_router.dart';
import '../../../meter/domain/entities/meter.dart';
import '../../../meter/presentation/bloc/meter_bloc.dart';
import '../../../meter/presentation/bloc/meter_state.dart';
import '../../../meter/presentation/bloc/meter_event.dart';

class RechargeByCodePage extends StatefulWidget {
  const RechargeByCodePage({super.key});

  @override
  State<RechargeByCodePage> createState() => _RechargeByCodePageState();
}

class _RechargeByCodePageState extends State<RechargeByCodePage> {
  final TextEditingController _codeController = TextEditingController();
  int digitCount = 0;

  @override
  void initState() {
    super.initState();
    if (sl<MeterBloc>().state is! MeterLoaded) {
      sl<MeterBloc>().add(const MeterListRequested());
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _pasteCode() async {
    final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      String cleanText = data.text!.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanText.length > 20) {
        cleanText = cleanText.substring(0, 20);
      }
      
      // Format with dashes
      String formatted = '';
      for (int i = 0; i < cleanText.length; i++) {
        if (i > 0 && i % 4 == 0) {
          formatted += '-';
        }
        formatted += cleanText[i];
      }
      
      setState(() {
        _codeController.text = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Count only digits
    final int digitCount = _codeController.text.replaceAll('-', '').length;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inserir código de recarga',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          'Código STS de 20 dígitos',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Code Input Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Código de recarga',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        GestureDetector(
                          onTap: _pasteCode,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0x19FF6A00),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.content_paste_rounded,
                                  color: AppTheme.primaryOrange,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Colar',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppTheme.primaryOrange,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Code Input Field
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).extension<AppColorsExtension>()!.inputBackground,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.08),
                          width: 1.11,
                        ),
                      ),
                      child: TextField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.80,
                        ),
                        decoration: InputDecoration(
                          hintText: 'XXXX-XXXX-XXXX-XXXX-XXXX',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.80,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          _StsCodeInputFormatter(),
                          LengthLimitingTextInputFormatter(24), // 20 digits + 4 dashes
                        ],
                        onChanged: (val) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Counter
                    Text(
                      '$digitCount/20 dígitos',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 32),


                  ],
                ),
              ),
            ),
            
            // Bottom Action
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 12),
              child: GestureDetector(
                onTap: digitCount == 20
                    ? () {
                        final rawCode = _codeController.text.replaceAll('-', '');
                        context.go(Uri(
                          path: '/recharge/status',
                          queryParameters: {
                            'amount': '0',
                            'meterNumber': '',
                            'isCodeRecharge': 'true',
                            'code': rawCode,
                          },
                        ).toString());
                      }
                    : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: ShapeDecoration(
                    gradient: digitCount == 20 ? AppTheme.primaryGradient : null,
                    color: digitCount == 20 ? null : Colors.black.withValues(alpha: 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Aplicar recarga',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: digitCount == 20 ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 16,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StsCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length && nonZeroIndex <= 20) {
        buffer.write('-'); // Add dash after every 4 digits
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
