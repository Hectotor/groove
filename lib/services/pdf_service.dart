import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'catbox_service.dart';
import 'airtable_service.dart';

class PdfService {
  // Fonction pour parser le contenu de l'IA et extraire les informations structurées
  static Map<String, dynamic> parseAIContent(String content) {
    final Map<String, dynamic> parsedData = {};
    
    try {
      // Extraire le festival
      final festivalMatch = RegExp(r'🎪\s*\*\*FESTIVAL SÉLECTIONNÉ\*\*\s*([^\n]+)', multiLine: true).firstMatch(content);
      if (festivalMatch != null) {
        parsedData['festival'] = {
          'name': festivalMatch.group(1)?.trim() ?? 'Festival non spécifié',
        };
      }
      
      // Extraire les vols
      final volsSection = RegExp(r'✈️\s*\*\*VOLS ALLER-RETOUR\*\*([\s\S]*?)(?=🏨|🎟️|🎁|💶|$)', multiLine: true).firstMatch(content);
      if (volsSection != null) {
        final volsContent = volsSection.group(1) ?? '';
        final companyMatch = RegExp(r'Compagnie\s*:\s*([^\n]+)').firstMatch(volsContent);
        final priceMatch = RegExp(r'Prix par personne\s*:\s*([0-9,]+)\s*€').firstMatch(volsContent);
        final allerMatch = RegExp(r'Aller\s*:\s*([^\n]+)').firstMatch(volsContent);
        final retourMatch = RegExp(r'Retour\s*:\s*([^\n]+)').firstMatch(volsContent);
        
        parsedData['vols'] = {
          'company': companyMatch?.group(1)?.trim() ?? 'Compagnie non spécifiée',
          'pricePerPerson': priceMatch?.group(1)?.trim() ?? '0',
          'aller': allerMatch?.group(1)?.trim() ?? 'Vol aller non spécifié',
          'retour': retourMatch?.group(1)?.trim() ?? 'Vol retour non spécifié',
        };
      }
      
      // Extraire l'hébergement
      final hebergementSection = RegExp(r'🏨\s*\*\*HÉBERGEMENT\*\*([\s\S]*?)(?=🎟️|🎁|💶|$)', multiLine: true).firstMatch(content);
      if (hebergementSection != null) {
        final hebergementContent = hebergementSection.group(1) ?? '';
        final typeMatch = RegExp(r'Type\s*:\s*([^\n]+)').firstMatch(hebergementContent);
        final nomMatch = RegExp(r'Nom\s*:\s*([^\n]+)').firstMatch(hebergementContent);
        final periodeMatch = RegExp(r'Période\s*:\s*([^\n]+)').firstMatch(hebergementContent);
        final prixMatch = RegExp(r'Prix total\s*:\s*([0-9,]+)\s*€').firstMatch(hebergementContent);
        
        parsedData['hebergement'] = {
          'type': typeMatch?.group(1)?.trim() ?? 'Type non spécifié',
          'name': nomMatch?.group(1)?.trim() ?? 'Nom non spécifié',
          'periode': periodeMatch?.group(1)?.trim() ?? 'Période non spécifiée',
          'totalPrice': prixMatch?.group(1)?.trim() ?? '0',
        };
      }
      
      // Extraire les billets
      final billetsSection = RegExp(r'🎟️\s*\*\*BILLETS FESTIVAL\*\*([\s\S]*?)(?=🎁|💶|$)', multiLine: true).firstMatch(content);
      if (billetsSection != null) {
        final billetsContent = billetsSection.group(1) ?? '';
        final typeMatch = RegExp(r'Type de pass\s*:\s*([^\n]+)').firstMatch(billetsContent);
        final periodeMatch = RegExp(r'Période de validité\s*:\s*([^\n]+)').firstMatch(billetsContent);
        final prixMatch = RegExp(r'Prix par personne\s*:\s*([0-9,]+)\s*€').firstMatch(billetsContent);
        
        parsedData['billets'] = {
          'type': typeMatch?.group(1)?.trim() ?? 'Type non spécifié',
          'periode': periodeMatch?.group(1)?.trim() ?? 'Période non spécifiée',
          'pricePerPerson': prixMatch?.group(1)?.trim() ?? '0',
        };
      }
      
      // Extraire le total
      final totalMatch = RegExp(r'💰\s*\*\*TOTAL ESTIMÉ\s*:\s*([0-9,]+)\s*€', multiLine: true).firstMatch(content);
      if (totalMatch != null) {
        parsedData['total'] = totalMatch.group(1)?.trim() ?? '0';
      }
      
      print('📊 Données parsées du contenu IA: $parsedData');
      
    } catch (e) {
      print('❌ Erreur lors du parsing du contenu IA: $e');
    }
    
    return parsedData;
  }
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
      
      // Parser le contenu de l'IA pour extraire les informations structurées
      final aiContent = devisDetails['contenu']?.toString() ?? '';
      final parsedAIData = parseAIContent(aiContent);
      
      // Fusionner les données parsées avec devisDetails
      final enrichedDevisDetails = Map<String, dynamic>.from(devisDetails);
      enrichedDevisDetails.addAll(parsedAIData);
      
      print('📝 Contenu IA à parser: ${aiContent.substring(0, aiContent.length > 200 ? 200 : aiContent.length)}...');
      print('🔍 Données enrichies: $enrichedDevisDetails');
      
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
                  if (enrichedDevisDetails['festival'] != null)
                    pw.Text('• ${enrichedDevisDetails['festival']['name']}', style: boldStyle)
                  else
                    pw.Text('Aucun festival sélectionné', style: normalStyle),
                ],
              ),
            ),
            
            // Vols
            if (enrichedDevisDetails['vols'] != null)
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
                    pw.Text('• Compagnie : ${enrichedDevisDetails['vols']['company']}'),
                    pw.Text('• Prix par personne : ${enrichedDevisDetails['vols']['pricePerPerson']} €'),
                    pw.SizedBox(height: 5),
                    pw.Text('Aller :', style: boldStyle),
                    pw.Text('   ${enrichedDevisDetails['vols']['aller']}'),
                    pw.SizedBox(height: 5),
                    pw.Text('Retour :', style: boldStyle),
                    pw.Text('   ${enrichedDevisDetails['vols']['retour']}'),
                  ],
                ),
              ),
            
            // Hébergement
            if (enrichedDevisDetails['hebergement'] != null)
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
                    pw.Text('• Type : ${enrichedDevisDetails['hebergement']['type']}'),
                    pw.Text('• Nom : ${enrichedDevisDetails['hebergement']['name']}'),
                    pw.Text('• Période : ${enrichedDevisDetails['hebergement']['periode']}'),
                    pw.Text('• Prix total : ${enrichedDevisDetails['hebergement']['totalPrice']} €', style: boldStyle),
                  ],
                ),
              ),
            
            // Billets
            if (enrichedDevisDetails['billets'] != null)
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
                    pw.Text('• Type de pass : ${enrichedDevisDetails['billets']['type']}'),
                    pw.Text('• Période de validité : ${enrichedDevisDetails['billets']['periode']}'),
                    pw.Text('• Prix par personne : ${enrichedDevisDetails['billets']['pricePerPerson']} €'),
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
                  if (enrichedDevisDetails['vols'] != null)
                    pw.Text('• Vols : ${enrichedDevisDetails['vols']['pricePerPerson']} € par personne'),
                  if (enrichedDevisDetails['hebergement'] != null)
                    pw.Text('• Hébergement : ${enrichedDevisDetails['hebergement']['totalPrice']} €'),
                  if (enrichedDevisDetails['billets'] != null)
                    pw.Text('• Billets festival : ${enrichedDevisDetails['billets']['pricePerPerson']} € par personne'),
                  pw.Divider(),
                  pw.Text(
                    '💰 TOTAL ESTIMÉ : ${enrichedDevisDetails['total'] ?? 'Non spécifié'} €',
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

  /// Télécharge le PDF vers Catbox.moe et retourne l'URL
  static Future<String?> uploadPdfToCatbox(Uint8List pdfBytes, String fileName) async {
    try {
      print('📤 Téléversement du PDF vers Catbox...');
      print('📄 Taille du PDF: ${pdfBytes.length} bytes');
      print('📁 Nom du fichier: $fileName');
      
      final fileUrl = await CatboxService.uploadFile(
        fileBytes: pdfBytes,
        fileName: fileName.endsWith('.pdf') ? fileName : '$fileName.pdf',
      );
      
      if (fileUrl != null) {
        print('✅ PDF téléversé avec succès sur Catbox');
        print('🔗 URL: $fileUrl');
        
        // Vérifier que l'URL est valide
        if (fileUrl.isEmpty) {
          print('⚠️ Attention: L\'URL retournée est vide');
          return null;
        }
        
        if (!fileUrl.startsWith('http')) {
          print('⚠️ Attention: L\'URL ne commence pas par http: $fileUrl');
          return null;
        }
      } else {
        print('❌ Échec du téléversement du PDF sur Catbox - Aucune URL retournée');
      }
      
      return fileUrl;
    } catch (e) {
      print('❌ Erreur lors du téléversement sur Catbox: $e');
      return null;
    }
  }

  /// Génère un PDF, le téléverse sur Catbox et envoie le lien à Airtable
  static Future<bool> generateAndSendPdf({
    required String clientName,
    required String email,
    required Map<String, dynamic> preferences,
    required Map<String, dynamic> devisDetails,
    required String airtableApiKey,
    required String airtableBaseId,
    required String airtableTableName,
  }) async {
    print('🚀 Début de la génération et envoi du PDF');
    
    try {
      // 1. Générer le PDF
      print('📄 Génération du PDF...');
      final pdfBytes = await generateDevisPdf(
        clientName: clientName,
        email: email,
        preferences: preferences,
        devisDetails: devisDetails,
      );
      print('✅ PDF généré (${pdfBytes.length} octets)');

      // 2. Téléverser sur Catbox
      print('☁️  Téléversement sur Catbox...');
      final fileName = 'devis_${clientName.replaceAll(' ', '_').toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final pdfUrl = await CatboxService.uploadFile(
        fileBytes: pdfBytes,
        fileName: fileName,
      );
      
      if (pdfUrl == null || pdfUrl.isEmpty) {
        print('❌ Échec du téléversement sur Catbox');
        return false;
      }
      
      print('🔗 PDF disponible à l\'URL: $pdfUrl');

      // 3. Envoyer à Airtable
      print('📤 Envoi du lien vers Airtable...');
      final airtableService = AirtableService(
        apiKey: airtableApiKey,
        baseId: airtableBaseId,
        tableName: airtableTableName,
      );
      
      final success = await airtableService.saveDevisWithPdfLink(
        nomClient: clientName,
        email: email,
        resumeDevis: 'Devis généré le ${DateTime.now().toIso8601String()}',
        pdfAttachments: [
          {
            'url': pdfUrl,
            'filename': fileName,
          }
        ],
      );
      
      if (success) {
        print('✅ Succès ! Devis enregistré dans Airtable');
        print('🔗 Lien du PDF: $pdfUrl');
      } else {
        print('❌ Échec de l\'enregistrement dans Airtable');
      }
      
      return success;
    } catch (e) {
      print('❌ Erreur: $e');
      return false;
    }
  }
}
