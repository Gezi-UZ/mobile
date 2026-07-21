import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';

class RechargeByCodePage extends StatefulWidget {
  const RechargeByCodePage({super.key});

  @override
  State<RechargeByCodePage> createState() => _RechargeByCodePageState();
}

class _RechargeByCodePageState extends State<RechargeByCodePage> {
  final TextEditingController _codeController = TextEditingController();
  int _selectedMeterIndex = 0;

  final List<Map<String, dynamic>> _mockMeters = [
    {'name': 'Casa principal', 'number': 'CRED-4892', 'status': 'Online'},
    {'name': 'Escritório', 'number': 'CRED-1204', 'status': 'Online'},
    {'name': 'Armazém', 'number': 'CRED-0371', 'status': 'Offline'},
  ];

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
      backgroundColor: AppTheme.white,
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
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppTheme.textColorDark,
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
                                color: AppTheme.textColorDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        Text(
                          'Código STS de 20 dígitos',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textColorSecondary,
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
                                color: AppTheme.textColorDark,
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
                        color: const Color(0xFFF5F5F5),
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
                        style: const TextStyle(
                          color: AppTheme.textColorDark,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.80,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'XXXX-XXXX-XXXX-XXXX-XXXX',
                          hintStyle: TextStyle(
                            color: AppTheme.textColorSecondary,
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
                            color: AppTheme.textColorSecondary,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Target Meter Section
                    Text(
                      'Contador de destino',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppTheme.textColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Meter List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _mockMeters.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final meter = _mockMeters[index];
                        final bool isSelected = _selectedMeterIndex == index;
                        final bool isOnline = meter['status'] == 'Online';

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMeterIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.lightOrangeBackground : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryOrange
                                    : Colors.black.withValues(alpha: 0.08),
                                width: 1.11,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Radio button
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? AppTheme.primaryOrange : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppTheme.primaryOrange
                                          : Colors.black.withValues(alpha: 0.08),
                                      width: 1.11,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Center(
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meter['name'],
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              color: AppTheme.textColorDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      Text(
                                        meter['number'],
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppTheme.textColorSecondary,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isOnline ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: isOnline ? const Color(0xFF00C950) : const Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isOnline ? 'Online' : 'Offline',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: isOnline ? const Color(0xFF008236) : const Color(0xFFB91C1C),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                        final meter = _mockMeters[_selectedMeterIndex];
                        final rawCode = _codeController.text.replaceAll('-', '');
                        context.go(Uri(
                          path: '/recharge/status',
                          queryParameters: {
                            'amount': '0',
                            'meterNumber': meter['number'],
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
                          color: digitCount == 20 ? Colors.white : AppTheme.textColorSecondary,
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
