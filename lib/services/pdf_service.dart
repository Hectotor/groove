import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart' as intl;
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';

class PdfService {
  static Future<Uint8List> generateDevisPdf({
    required String clientName,
    required String email,
    required String resume,
  }) async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();
      final dateFormat = intl.DateFormat('dd/MM/yyyy');
      
      // Nettoyer le texte des emojis et caractères spéciaux
      String cleanText(String text) {
        return text.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
      }
      
      // Définir les styles
      final headerStyle = pw.TextStyle(
        fontSize: 22,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue800,
      );
      
      final titleStyle = pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue700,
      );
      
      final normalStyle = pw.TextStyle(fontSize: 12);
      
      // Créer le contenu du PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // En-tête
                pw.Text('Devis Groove Nomad', style: headerStyle),
                pw.SizedBox(height: 20),
                
                // Informations client
                pw.Text('Informations client', style: titleStyle),
                pw.SizedBox(height: 10),
                pw.Text('Nom: ${cleanText(clientName)}', style: normalStyle),
                pw.Text('Email: ${cleanText(email)}', style: normalStyle),
                pw.Text('Date: ${dateFormat.format(now)}', style: normalStyle),
                pw.SizedBox(height: 20),
                
                // Détails du devis
                pw.Text('Détails du devis', style: titleStyle),
                pw.SizedBox(height: 10),
                pw.Text(cleanText(resume), style: normalStyle),
                pw.Spacer(),
                
                // Pied de page
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Divider(),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Merci de votre confiance !',
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      ' Groove Nomad - Tous droits réservés',
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Retourner les bytes du PDF
      return pdf.save();
    } catch (e) {
      print('Erreur lors de la génération du PDF: $e');
      rethrow;
    }
  }
  
  static Future<File> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    try {
      // Obtenir le répertoire temporaire
      final dir = await getTemporaryDirectory();
      
      // Créer un fichier dans le répertoire temporaire
      final file = File('${dir.path}/$fileName');
      
      // Écrire les bytes dans le fichier
      await file.writeAsBytes(pdfBytes);
      
      return file;
    } catch (e) {
      print('Erreur lors de la sauvegarde du fichier PDF: $e');
      rethrow;
    }
  }
}
