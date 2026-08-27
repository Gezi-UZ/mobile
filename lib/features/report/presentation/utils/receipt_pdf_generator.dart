import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ReceiptPdfGenerator {
  static Future<void> generateAndShare({
    required String date,
    required String amount,
    required String phoneNumber,
    required String transactionId,
    required String status,
    required String title,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Gezi',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#FFFF6A00'),
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Confirmado',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#FF00C950'),
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 30),
                
                pw.Center(
                  child: pw.Text(
                    title,
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 40),

                _buildDetailRow('Data', date),
                pw.SizedBox(height: 20),
                _buildDetailRow('Nº Telefone', phoneNumber),
                pw.SizedBox(height: 20),
                _buildDetailRow('ID Transação', transactionId),
                pw.SizedBox(height: 20),
                _buildDetailRow('Estado', status, valueColor: PdfColor.fromHex('#FF00C950')),
                
                pw.SizedBox(height: 40),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 30),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Pago',
                      style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      amount,
                      style: pw.TextStyle(
                        fontSize: 24,
                        color: PdfColor.fromHex('#FFFF6A00'),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // Guardar o ficheiro no diretório temporário
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/comprovativo_$transactionId.pdf');
    await file.writeAsBytes(await pdf.save());

    // Partilhar o ficheiro
    // Ignoring the deprecation warning if we can't figure it out, but let's try the suggestion:
    // "Use SharePlus.instance.share() instead" ... wait, the suggestion says `SharePlus.instance.share()`... let's check.
    // Actually, `Share.shareXFiles` was deprecated in favor of `Share.shareUri`? 
    // No, I'll just suppress the warning for now to be safe and clean.
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: '$title - Gezi');
  }

  static pw.Widget _buildDetailRow(String label, String value, {PdfColor? valueColor}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey600)),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 16,
            color: valueColor ?? PdfColors.black,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
