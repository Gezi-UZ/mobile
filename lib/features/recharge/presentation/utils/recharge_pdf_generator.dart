import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;
import 'package:gezi/features/home/domain/entities/recharge.dart';

class RechargePdfGenerator {
  static bool _isPending(String status) {
    final s = status.toUpperCase();
    return s == 'PENDING' || s == 'MQTT_SENT' || s == 'CONFIRMED' || s == 'PROCESSING';
  }

  static Future<Uint8List> generatePdf({
    required Recharge recharge,
    bool isCodeRecharge = false,
    String? code,
  }) async {
    final pdf = pw.Document();

    // Load Logo
    final ByteData bytes = await rootBundle.load('assets/images/GeziBrand.png');
    final Uint8List logoBytes = bytes.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    final double totalAmount = recharge.paidAmount;
    const double ratePerKwh = 7.64;
    const double taxaIva = 0.16;

    double valEnergia;
    double iva;
    double txRadio = 0.0;
    double txLixo = 0.0;
    const double dividaPaga = 0.0;
    double estimatedKwh = recharge.kwhAmount > 0
        ? recharge.kwhAmount
        : (isCodeRecharge ? 150.0 : 0.0);

    if (estimatedKwh > 0 && !isCodeRecharge) {
      valEnergia = (estimatedKwh * ratePerKwh).clamp(0.0, totalAmount);
      iva = valEnergia * taxaIva;
      final double deducaoTaxas = (totalAmount - (valEnergia + iva)).clamp(0.0, totalAmount);
      if (deducaoTaxas > 0) {
        txRadio = (deducaoTaxas >= 15.0) ? 15.0 : deducaoTaxas;
        txLixo = (deducaoTaxas - txRadio).clamp(0.0, totalAmount);
      }
    } else {
      valEnergia = totalAmount / (1.0 + taxaIva);
      iva = totalAmount - valEnergia;
      estimatedKwh = valEnergia / ratePerKwh;
    }

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
        '${code?.substring(0, 4)}...${code?.substring((code.length) - 4)}',
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
      
      if (recharge.tokenSts != null && recharge.tokenSts!.isNotEmpty) {
        tableData.add(['Código da recarga', recharge.tokenSts!]);
      }
    }

    tableData.addAll([
      [_isPending(recharge.rawStatus) ? 'Crédito a aplicar' : 'Crédito aplicado', '${estimatedKwh.toStringAsFixed(1)} kWh'],
      ['Método', isCodeRecharge ? 'Código STS' : recharge.paymentMethod ],
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
