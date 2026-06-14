import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/prescription_model.dart';
import '../models/paiement_model.dart';
import '../models/consultation_model.dart';
import 'pdf_share_helper.dart';

class PdfService {
  static Future<Directory> _resolveDownloadDirectory() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final downloadDir = Directory(
          '${externalDir.path}${Platform.pathSeparator}downloads',
        );
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
        return downloadDir;
      }
      return await getApplicationDocumentsDirectory();
    }

    final userProfile = Platform.environment['USERPROFILE'];
    if (userProfile != null && userProfile.isNotEmpty) {
      final downloads = Directory(
        '$userProfile${Platform.pathSeparator}Downloads',
      );
      if (await downloads.exists()) {
        return downloads;
      }
    }

    final home = Platform.environment['HOME'];
    if (home != null && home.isNotEmpty) {
      final downloads = Directory('$home${Platform.pathSeparator}Downloads');
      if (await downloads.exists()) {
        return downloads;
      }
    }

    return Directory.current;
  }

  static Future<String?> _savePdf({
    required pw.Document pdf,
    required String filePrefix,
  }) async {
    final bytes = Uint8List.fromList(await pdf.save());
    final safePrefix = filePrefix.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final fileName =
        '${safePrefix}_${DateTime.now().millisecondsSinceEpoch}.pdf';

    if (kIsWeb) {
      await sharePdf(bytes: bytes, filename: fileName);
      return fileName;
    }

    final targetDir = await _resolveDownloadDirectory();
    final file = File(
      '${targetDir.path}${Platform.pathSeparator}$fileName',
    );
    await file.writeAsBytes(bytes, flush: true);
    debugPrint('PDF saved to ${file.path}');
    return file.path;
  }

  static Future<pw.Widget> _brandHeader(String documentTitle) async {
    pw.ImageProvider? logo;
    try {
      final logoData = await rootBundle.load('assets/pdf_logo_argana.png');
      logo = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error loading logo: $e');
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#EAF3FF'),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        border: pw.Border.all(color: PdfColor.fromHex('#0A4D8C'), width: 1.2),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              if (logo != null)
                pw.Container(
                  width: 60,
                  height: 60,
                  margin: const pw.EdgeInsets.only(right: 12),
                  child: pw.Image(logo),
                ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'CLINIQUE ARGANA',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#0A4D8C'),
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('Votre Santé, Notre Priorité',
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Contact: +212 5XX XX XX XX',
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#0A4D8C'),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Text(
              documentTitle.toUpperCase(),
              style: pw.TextStyle(
                color: PdfColor.fromHex('#FFFFFF'),
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
          ),
          pw.Expanded(
              child: pw.Text(value, style: const pw.TextStyle(fontSize: 11))),
        ],
      ),
    );
  }

  static Future<String?> exportFullDiagnostic({
    required ConsultationModel consultation,
    required PrescriptionModel? prescription,
    required String patientName,
    required String doctorName,
  }) async {
    final pdf = pw.Document();
    final date = consultation.dateConsult ?? DateTime.now();
    final header = await _brandHeader('Rapport de Consultation');

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            header,
            pw.SizedBox(height: 24),
            pw.Text('INFORMATIONS GÉNÉRALES',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 8),
            _infoRow('Date', date.toIso8601String().split('T')[0]),
            _infoRow('Patient', patientName),
            _infoRow('Médecin', doctorName),
            pw.SizedBox(height: 24),
            pw.Text('DIAGNOSTIC & OBSERVATIONS',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
            pw.Divider(thickness: 1),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Diagnostic:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(consultation.diagnostic),
                  pw.SizedBox(height: 10),
                  pw.Text('Notes:',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(consultation.notes),
                ],
              ),
            ),
            if (prescription != null && prescription.medicaments.isNotEmpty) ...[
              pw.SizedBox(height: 24),
              pw.Text('ORDONNANCE (TRAITEMENT)',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 13)),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),
              ...prescription.medicaments.map((m) => pw.Bullet(
                    text: '${m.nomGenerique} - ${m.dosage}\n${m.instructions}',
                    style: const pw.TextStyle(fontSize: 11),
                    margin: const pw.EdgeInsets.only(bottom: 6),
                  )),
            ],
            pw.Spacer(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text('Cachet de la clinique',
                        style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 40),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Signature du Médecin',
                        style: const pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 40),
                  ],
                ),
              ],
            ),
            pw.Center(
              child: pw.Text('Document généré via Argana Clinic App',
                  style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
            ),
          ],
        ),
      ),
    );

    return await _savePdf(pdf: pdf, filePrefix: 'rapport_medical');
  }

  static Future<String?> exportReceipt({
    required PaiementModel payment,
    required String patientName,
  }) async {
    final pdf = pw.Document();
    final date = payment.datePaiement;
    final header = await _brandHeader('Recu de paiement');

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            header,
            pw.SizedBox(height: 24),
            _infoRow('Reçu N°', '#${payment.id ?? 'N/A'}'),
            _infoRow(
              'Date',
              date != null ? date.toIso8601String().split('T')[0] : 'N/A',
            ),
            _infoRow('Patient', patientName),
            _infoRow('Rendez-vous', '#${payment.rdvId}'),
            pw.SizedBox(height: 24),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: const {
                0: pw.FlexColumnWidth(4),
                1: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text('Description',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text('Montant',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                          'Consultation médicale / Frais de diagnostic'),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text('${payment.montant.toStringAsFixed(2)} MAD'),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#0A4D8C'),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                ),
                child: pw.Text(
                  'TOTAL: ${payment.montant.toStringAsFixed(2)} MAD',
                  style: pw.TextStyle(
                      color: PdfColors.white, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ),
            pw.Spacer(),
            pw.Text('Signature et Cachet', style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );

    return await _savePdf(pdf: pdf, filePrefix: 'recu_paiement');
  }
}
