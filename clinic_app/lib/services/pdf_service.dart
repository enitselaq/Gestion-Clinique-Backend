import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/prescription_model.dart';
import '../models/paiement_model.dart';
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

  static pw.Widget _brandHeader(String documentTitle) {
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
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'CLINIQUE EXEMPLE',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#0A4D8C'),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text('Adresse - Telephone - Email'),
              pw.Text('Zone reservee au logo et au branding'),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#0A4D8C'),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Text(
              documentTitle,
              style: pw.TextStyle(
                color: PdfColor.fromHex('#FFFFFF'),
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
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
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(child: pw.Text(value)),
        ],
      ),
    );
  }

  static Future<String?> exportPrescription({
    required PrescriptionModel ordonnance,
    required String patientName,
    required String doctorName,
  }) async {
    final pdf = pw.Document();
    final date = ordonnance.dateCreation;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(28),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _brandHeader('Ordonnance'),
            pw.SizedBox(height: 20),
            _infoRow(
              'Date',
              date != null ? date.toIso8601String().split('T')[0] : 'N/A',
            ),
            _infoRow('Patient', patientName.isEmpty ? 'N/A' : patientName),
            _infoRow('Medecin', doctorName.isEmpty ? 'N/A' : doctorName),
            pw.SizedBox(height: 18),
            pw.Text(
              'Traitement prescrit',
              style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            if (ordonnance.medicaments.isEmpty)
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex('#B8C7D9')),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Text('Aucun medicament enregistre.'),
              ),
            ...ordonnance.medicaments.map(
              (m) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColor.fromHex('#B8C7D9')),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      m.nomGenerique,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text('Dosage: ${m.dosage.isEmpty ? 'N/A' : m.dosage}'),
                    pw.Text(
                      'Instructions: ${m.instructions.isEmpty ? 'Aucune instruction' : m.instructions}',
                    ),
                  ],
                ),
              ),
            ),
            pw.Spacer(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Cachet de la clinique'),
                pw.Text('Signature du medecin'),
              ],
            ),
          ],
        ),
      ),
    );

    return await _savePdf(pdf: pdf, filePrefix: 'ordonnance');
  }

  static Future<String?> exportReceipt({
    required PaiementModel payment,
    required String patientName,
  }) async {
    final pdf = pw.Document();
    final date = payment.datePaiement;

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(28),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _brandHeader('Recu de paiement'),
            pw.SizedBox(height: 20),
            _infoRow('Recu', '#${payment.id ?? 'N/A'}'),
            _infoRow(
              'Date',
              date != null ? date.toIso8601String().split('T')[0] : 'N/A',
            ),
            _infoRow('Patient', patientName.isEmpty ? 'N/A' : patientName),
            _infoRow('Rendez-vous', '#${payment.rdvId}'),
            pw.SizedBox(height: 18),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColor.fromHex('#B8C7D9')),
              columnWidths: const {
                0: pw.FlexColumnWidth(4),
                1: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#EAF3FF'),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        'Description',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        'Montant',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        'Consultation medicale / frais administratifs',
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        '${payment.montant.toStringAsFixed(2)} MAD',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#0A4D8C'),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(8),
                  ),
                ),
                child: pw.Text(
                  'Total: ${payment.montant.toStringAsFixed(2)} MAD',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex('#FFFFFF'),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
            pw.Spacer(),
            pw.Text('Signature et cachet de la clinique'),
          ],
        ),
      ),
    );

    return await _savePdf(pdf: pdf, filePrefix: 'recu_paiement');
  }
}
