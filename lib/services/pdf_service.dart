import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<Uint8List> generateDevisPdf({
    required String clientName,
    required String email,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> devisDetails,
  }) async {
    try {
      await initializeDateFormatting('fr_FR', null);
      final pdf = pw.Document();
      final now = DateTime.now();
      final dateFormat = DateFormat('dd/MM/yyyy', 'fr_FR');
      
      // Styles
      final headerStyle = pw.TextStyle(
        fontSize: 24,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue900,
      );
      
      final titleStyle = pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue800,
      );
      
      final sectionStyle = pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.blue700,
      );
      
      final normalStyle = pw.TextStyle(
        fontSize: 12,
        lineSpacing: 1.5,
      );
      
      final boldStyle = pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
      );
      
      // Fonction pour créer une ligne de détail
      pw.Widget buildDetailRow(String label, String value, {bool isTotal = false}) {
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('• $label: ', style: isTotal ? boldStyle : normalStyle),
              pw.Expanded(
                child: pw.Text(value, style: isTotal ? boldStyle : normalStyle),
              ),
            ],
          ),
        );
      }
      
      // Créer le contenu du PDF
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.copyWith(
            marginTop: 2.0 * PdfPageFormat.cm,
            marginBottom: 2.0 * PdfPageFormat.cm,
            marginLeft: 2.0 * PdfPageFormat.cm,
            marginRight: 2.0 * PdfPageFormat.cm,
          ),
          header: (context) {
            return pw.Column(
              children: [
                pw.Text('GROOVE NOMAD', style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                )),
                pw.SizedBox(height: 5),
                pw.Text('Voyages musicaux sur mesure', style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                )),
                pw.Divider(thickness: 2, color: PdfColors.blue900),
                pw.SizedBox(height: 20),
              ],
            );
          },
          footer: (context) {
            return pw.Column(
              children: [
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Merci de votre confiance !',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'contact@groovenomad.com • www.groovenomad.com',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
                ),
              ],
            );
          },
          build: (context) => [
            // En-tête du devis
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('DEVIS PERSONNALISÉ', style: headerStyle),
                  pw.SizedBox(height: 5),
                  pw.Text('Pour : $clientName', style: titleStyle),
                  pw.Text('Date : ${dateFormat.format(now)}', style: normalStyle),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Section Informations client
            pw.Header(
              level: 1,
              child: pw.Text('INFORMATIONS CLIENT', style: sectionStyle),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  buildDetailRow('👥 Nombre de voyageurs', preferences['numberOfPeople'] ?? 'Non précisé'),
                  buildDetailRow('🎯 Destination', preferences['destinationCountry'] ?? 'Non précisée'),
                  buildDetailRow('📅 Période', preferences['travelDate'] ?? 'Non précisée'),
                  buildDetailRow('⏱️ Durée', preferences['duration'] ?? 'Non précisée'),
                  buildDetailRow('🎵 Style musical', preferences['musicGenre'] ?? 'Non précisé'),
                  buildDetailRow('💰 Budget', preferences['budget'] ?? 'Non précisé'),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),
            
            // Section Détails du voyage
            pw.Header(
              level: 1,
              child: pw.Text('DÉTAILS DU VOYAGE', style: sectionStyle),
            ),
            
            // Festival
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(15),
              margin: const pw.EdgeInsets.only(bottom: 15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('🎪 FESTIVAL SÉLECTIONNÉ', style: titleStyle),
                  pw.SizedBox(height: 10),
                  if (devisDetails['festival'] != null) ...[
                    pw.Text('• ${devisDetails['festival']['name']}', style: boldStyle),
                    pw.Text('   ${devisDetails['festival']['dates']}'),
                    pw.Text('   ${devisDetails['festival']['location']}'),
                  ] else
                    pw.Text('Aucun festival sélectionné', style: normalStyle),
                ],
              ),
            ),
            
            // Vols
            if (devisDetails['vols'] != null)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(15),
                margin: const pw.EdgeInsets.only(bottom: 15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('✈️ VOLS ALLER-RETOUR', style: titleStyle),
                    pw.SizedBox(height: 10),
                    pw.Text('• Compagnie : ${devisDetails['vols']['company']}'),
                    pw.Text('• Prix par personne : ${devisDetails['vols']['pricePerPerson']} €'),
                    pw.SizedBox(height: 5),
                    pw.Text('Aller :', style: boldStyle),
                    pw.Text('   ${devisDetails['vols']['departureDate']} - Départ ${devisDetails['vols']['departureTime']}'),
                    pw.Text('   ${devisDetails['vols']['from']} → ${devisDetails['vols']['to']}'),
                    pw.Text('   Arrivée ${devisDetails['vols']['arrivalTime']}'),
                    pw.SizedBox(height: 5),
                    pw.Text('Retour :', style: boldStyle),
                    pw.Text('   ${devisDetails['vols']['returnDate']} - Départ ${devisDetails['vols']['returnDepartureTime']}'),
                    pw.Text('   ${devisDetails['vols']['to']} → ${devisDetails['vols']['from']}'),
                    pw.Text('   Arrivée ${devisDetails['vols']['returnArrivalTime']}'),
                    pw.SizedBox(height: 5),
                    pw.Text('• Prix total : ${devisDetails['vols']['totalPrice']} €', style: boldStyle),
                  ],
                ),
              ),
            
            // Hébergement
            if (devisDetails['hebergement'] != null)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(15),
                margin: const pw.EdgeInsets.only(bottom: 15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('🏨 HÉBERGEMENT', style: titleStyle),
                    pw.SizedBox(height: 10),
                    pw.Text('• Type : ${devisDetails['hebergement']['type']}'),
                    pw.Text('• Nom : ${devisDetails['hebergement']['name']}'),
                    pw.Text('• Période : Du ${devisDetails['hebergement']['checkIn']} au ${devisDetails['hebergement']['checkOut']}'),
                    pw.Text('• Capacité : ${devisDetails['hebergement']['capacity']} personnes'),
                    pw.Text('• Prix total : ${devisDetails['hebergement']['totalPrice']} €', style: boldStyle),
                  ],
                ),
              ),
            
            // Billets
            if (devisDetails['billets'] != null)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(15),
                margin: const pw.EdgeInsets.only(bottom: 15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('🎟️ BILLETS FESTIVAL', style: titleStyle),
                    pw.SizedBox(height: 10),
                    pw.Text('• Type de pass : ${devisDetails['billets']['type']}'),
                    pw.Text('• Période de validité : Du ${devisDetails['billets']['validFrom']} au ${devisDetails['billets']['validTo']}'),
                    pw.Text('• Quantité : ${devisDetails['billets']['quantity']}'),
                    pw.Text('• Prix par personne : ${devisDetails['billets']['pricePerPerson']} €'),
                    pw.Text('• Prix total : ${devisDetails['billets']['totalPrice']} €', style: boldStyle),
                  ],
                ),
              ),
            
            // Options
            if (devisDetails['options'] != null && devisDetails['options'].isNotEmpty)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(15),
                margin: const pw.EdgeInsets.only(bottom: 15),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('🎁 OPTIONS SUPPLÉMENTAIRES', style: titleStyle),
                    pw.SizedBox(height: 10),
                    ...devisDetails['options'].map<pw.Widget>((option) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 5),
                        child: pw.Text('• ${option['name']} : ${option['price']} €'),
                      );
                    }).toList(),
                    pw.SizedBox(height: 5),
                    pw.Text('Total options : ${devisDetails['optionsTotal']} €', style: boldStyle),
                  ],
                ),
              ),
            
            // Récapitulatif des tarifs
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(15),
              margin: const pw.EdgeInsets.only(bottom: 15),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.blue900, width: 1.5),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                color: PdfColors.blue50,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('💶 RÉCAPITULATIF DES TARIFS', style: titleStyle.copyWith(color: PdfColors.blue900)),
                  pw.SizedBox(height: 10),
                  if (devisDetails['vols'] != null)
                    pw.Text('• Vols : ${devisDetails['vols']['totalPrice']} €'),
                  if (devisDetails['hebergement'] != null)
                    pw.Text('• Hébergement : ${devisDetails['hebergement']['totalPrice']} €'),
                  if (devisDetails['billets'] != null)
                    pw.Text('• Billets festival : ${devisDetails['billets']['totalPrice']} €'),
                  if (devisDetails['optionsTotal'] != null && devisDetails['optionsTotal'] > 0)
                    pw.Text('• Options : ${devisDetails['optionsTotal']} €'),
                  pw.Divider(),
                  pw.Text(
                    '💰 TOTAL ESTIMÉ : ${devisDetails['total']} €',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    '* Les prix sont donnés à titre indicatif et peuvent varier selon la période de réservation et les disponibilités.',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Mentions légales
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 10),
              child: pw.Text(
                'En acceptant ce devis, vous reconnaissez avoir pris connaissance des conditions générales de vente disponibles sur notre site web. Ce devis est valable 30 jours à compter de sa date d\'émission.',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey600,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
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
      // Obtenir le répertoire des documents de l'application
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      
      // Créer le fichier et écrire les données
      await file.writeAsBytes(pdfBytes);
      print('📄 Fichier PDF enregistré à: ${file.path}');
      
      return file;
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde du PDF: $e');
      rethrow;
    }
  }
}
