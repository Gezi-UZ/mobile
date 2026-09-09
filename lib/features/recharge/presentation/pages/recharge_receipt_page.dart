// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gezi/core/theme/theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:gezi/features/home/domain/entities/recharge.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;

class RechargeReceiptPage extends StatelessWidget {
  final Recharge recharge;
  final bool isCodeRecharge;
  final String? code;

  const RechargeReceiptPage({
    super.key,
    required this.recharge,
    this.isCodeRecharge = false,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    final double totalAmount = recharge.paidAmount;
    // We assume some hardcoded logic here based on business rules or Breakdown entity
    // Ideally Breakdown should be part of Recharge entity, but for UI we simulate if absent.
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
    final double estimatedKwh = recharge.kwhAmount > 0
        ? recharge.kwhAmount
        : (isCodeRecharge ? 150.0 : (remainingAfterFees / ratePerKwh));

    final String transactionId = recharge.id.length >= 8
        ? recharge.id.substring(0, 8).toUpperCase()
        : recharge.id.toUpperCase();
    final String dateStr = DateFormat(
      'dd/MM/yyyy · HH:mm',
    ).format(recharge.rechargedAt);
    final meterNumber = recharge.meterSerialNumber;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 24,
                  right: 24,
                  bottom: 32,
                ),
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
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${estimatedKwh.toStringAsFixed(1)} kWh adicionados ao seu contador',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Comprovativo Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: ShapeDecoration(
                        color: Theme.of(context)
                            .extension<AppColorsExtension>()!
                            .lightOrangeBackground,
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
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
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
                          _ReceiptRow(
                            title: 'Ref ID do Pagamento',
                            value: transactionId,
                          ),
                          _ReceiptRow(title: 'Data e hora', value: dateStr),
                          _ReceiptRow(title: 'Contador', value: meterNumber),
                          if (isCodeRecharge)
                            _ReceiptRow(
                              title: 'Código aplicado',
                              value:
                                  '${code?.substring(0, 4)}...${code?.substring((code?.length ?? 4) - 4)}',
                            )
                          else ...[
                            _ReceiptRow(
                              title: 'Valor pago',
                              value:
                                  '${totalAmount.toStringAsFixed(0)} ${recharge.currency}',
                            ),
                            _ReceiptRow(
                              title: 'Val Energia',
                              value:
                                  '${valEnergia.toStringAsFixed(2)} ${recharge.currency}',
                            ),
                            _ReceiptRow(
                              title: 'IVA (16%)',
                              value:
                                  '${iva.toStringAsFixed(2)} ${recharge.currency}',
                            ),
                            _ReceiptRow(
                              title: 'Dívida Paga',
                              value:
                                  '${dividaPaga.toStringAsFixed(2)} ${recharge.currency}',
                            ),
                            _ReceiptRow(
                              title: 'Tx Rádio',
                              value:
                                  '${txRadio.toStringAsFixed(2)} ${recharge.currency}',
                            ),
                            _ReceiptRow(
                              title: 'Tx Lixo',
                              value:
                                  '${txLixo.toStringAsFixed(2)} ${recharge.currency}',
                            ),
                          ],
                          if (recharge.tokenSts != null)
                            _ReceiptRow(
                              title: 'Código da recarga',
                              value: recharge.tokenSts!,
                            ),
                          _ReceiptRow(
                            title: 'Crédito aplicado',
                            value: '${estimatedKwh.toStringAsFixed(1)} kWh',
                          ),
                          _ReceiptRow(
                            title: 'Método',
                            value: isCodeRecharge
                                ? 'Código STS'
                                : recharge.paymentMethod,
                          ),

                          // Status Row (Verde)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Estado',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                ),
                                Text(
                                  'Concluído',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
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
                      onTap: () async {
                        try {
                          final pdfData = await _generatePdf();
                          await Share.shareXFiles([
                            XFile.fromData(
                              pdfData,
                              mimeType: 'application/pdf',
                              name: 'Comprovativo_Gezi_$transactionId.pdf',
                            ),
                          ], text: 'Comprovativo de Recarga Gezi');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao partilhar'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _SecondaryButton(
                      title: 'Guardar PDF',
                      icon: Icons.download_outlined,
                      onTap: () async {
                        try {
                          final pdfData = await _generatePdf();
                          await Printing.layoutPdf(
                            onLayout: (PdfPageFormat format) async => pdfData,
                            name: 'Comprovativo_Gezi_$transactionId.pdf',
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao guardar PDF'),
                              ),
                            );
                          }
                        }
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
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.white, fontSize: 16),
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

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    // Load Logo
    final ByteData bytes = await rootBundle.load('assets/images/GeziBrand.png');
    final Uint8List logoBytes = bytes.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    final double totalAmount = recharge.paidAmount;
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
    final double estimatedKwh = recharge.kwhAmount > 0
        ? recharge.kwhAmount
        : (isCodeRecharge ? 150.0 : (remainingAfterFees / ratePerKwh));

    final String transactionId =
        recharge.paymentReference ??
        (recharge.id.length >= 4
            ? 'GEZI${recharge.id.substring(0, 4).toUpperCase()}'
            : 'GEZI${recharge.id.toUpperCase()}');
    final String dateStr = DateFormat(
      'dd/MM/yyyy · HH:mm',
    ).format(recharge.rechargedAt);
    final meterNumber = recharge.meterSerialNumber;

    // Build Table Data
    final tableData = [
      ['Ref ID do Pagamento', transactionId],
      ['Data e hora', dateStr],
      ['Contador', meterNumber],
    ];

    if (isCodeRecharge) {
      tableData.add([
        'Código aplicado',
        '${code?.substring(0, 4)}...${code?.substring((code?.length ?? 4) - 4)}',
      ]);
    } else {
      tableData.addAll([
        [
          'Valor pago',
          '${totalAmount.toStringAsFixed(0)} ${recharge.currency}',
        ],
        [
          'Val Energia',
          '${valEnergia.toStringAsFixed(2)} ${recharge.currency}',
        ],
        ['IVA (16%)', '${iva.toStringAsFixed(2)} ${recharge.currency}'],
        [
          'Dívida Paga',
          '${dividaPaga.toStringAsFixed(2)} ${recharge.currency}',
        ],
        ['Tx Rádio', '${txRadio.toStringAsFixed(2)} ${recharge.currency}'],
        ['Tx Lixo', '${txLixo.toStringAsFixed(2)} ${recharge.currency}'],
      ]);
      
      if (recharge.tokenSts != null) {
        tableData.add(['Código da recarga', recharge.tokenSts!]);
      }
    }

    tableData.addAll([
      ['Crédito aplicado', '${estimatedKwh.toStringAsFixed(1)} kWh'],
      ['Método', isCodeRecharge ? 'Código STS' : recharge.paymentMethod],
    ]);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Logo
              pw.Image(logoImage, width: 120),
              pw.SizedBox(height: 16),

              // Title
              pw.Text(
                'Comprovativo de Recarga',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 32),

              // Table
              pw.Table(
                border: pw.TableBorder.all(
                  color: PdfColors.grey300,
                  width: 0.5,
                ),
                columnWidths: {
                  0: const pw.FixedColumnWidth(160),
                  1: const pw.FlexColumnWidth(),
                },
                children: tableData.asMap().entries.map((entry) {
                  int index = entry.key;
                  List<String> row = entry.value;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: index % 2 == 0
                          ? PdfColors.grey100
                          : PdfColors.white,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: pw.Text(
                          row[0],
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        child: pw.Text(
                          row[1],
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              pw.SizedBox(height: 40),
              pw.Divider(color: PdfColors.grey400),
              pw.SizedBox(height: 16),

              // Footer
              pw.Text(
                'Obrigado por usar o Gezi!',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey700,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
    return pdf.save();
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
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
            Icon(icon, color: AppTheme.primaryOrange, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
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
