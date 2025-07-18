import 'dart:convert';
import 'package:http/http.dart' as http;

class AirtableService {
  static const String _baseUrl = 'https://api.airtable.com/v0';
  final String apiKey;
  final String baseId;
  final String tableName;

  AirtableService({
    required this.apiKey,
    required this.baseId,
    required this.tableName,
  });

  Future<bool> saveDevis({
    required String nomClient,
    required String email,
    required String resumeDevis,
  }) async {
    try {
      final url = '$_baseUrl/$baseId/$tableName';
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };
      
      final body = {
        'fields': {
          'Nom': nomClient,
          'Email': email,
          'Date': DateTime.now().toIso8601String(),
          'Résumé': resumeDevis,
        },
      };
      
      print('🌐 Envoi des données à Airtable...');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print('📥 Réponse reçue d\'Airtable:');
      print('🔢 Status code: ${response.statusCode}');
      print('📄 En-têtes: ${response.headers}');
      print('📝 Corps de la réponse: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✅ Succès ! Devis enregistré dans Airtable');
        return true;
      } else if (response.statusCode == 403) {
        print('❌ Erreur 403 - Accès refusé. Vérifiez :');
        print('1. Que la clé API est correcte et active');
        print('2. Que la clé API a les permissions en écriture');
        print('3. Que la base et la table sont accessibles avec cette clé');
        print('4. Que les champs PDF_Info, PDF_Size et PDF_Preview existent dans votre table Airtable');
        return false;
      } else {
        print('❌ Erreur Airtable (${response.statusCode})');
        return false;
      }
    } catch (e, stackTrace) {
      print('Exception lors de l\'envoi à Airtable:');
      print('Type d\'erreur: ${e.runtimeType}');
      print('Message: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> saveDevisWithPdfLink({
    required String nomClient,
    required String email,
    required String resumeDevis,
    required List<Map<String, String>> pdfAttachments,
  }) async {
    try {
      final url = '$_baseUrl/$baseId/$tableName';
      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      };

      // Vérifier les pièces jointes
      if (pdfAttachments.isEmpty) {
        print('❌ Aucune pièce jointe fournie');
        return false;
      }

      // Préparer les données
      final data = {
        'fields': {
          'Nom': nomClient,
          'Email': email,
          'Date': DateTime.now().toIso8601String(),
          'Résumé': resumeDevis,
          'PDF_Link': pdfAttachments, // Format attendu: [{'url': '...', 'filename': '...'}]
        }
      };

      print('🔍 Analyse des pièces jointes:');
      for (int i = 0; i < pdfAttachments.length; i++) {
        final attachment = pdfAttachments[i];
        print('  Pièce jointe ${i + 1}:');
        print('    URL: ${attachment['url']}');
        print('    Filename: ${attachment['filename']}');
      }

      print('📄 Données à envoyer:');
      print(jsonEncode(data));

      print('📤 Envoi à Airtable...');
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      print('📥 Réponse complète:');
      print('  Status: ${response.statusCode}');
      print('  Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Analyser la réponse pour voir si le champ PDF_Link est présent
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['fields'] != null) {
            final fields = responseData['fields'];
            print('🔍 Champs dans la réponse:');
            fields.forEach((key, value) {
              print('  $key: $value');
            });
            
            if (fields.containsKey('PDF_Link')) {
              print('✅ Champ PDF_Link présent dans la réponse');
              print('📎 Contenu PDF_Link: ${fields['PDF_Link']}');
            } else {
              print('❌ Champ PDF_Link ABSENT de la réponse!');
              print('💡 Vérifiez que le champ existe et est de type "Attachment" dans Airtable');
            }
          }
        } catch (e) {
          print('⚠️ Impossible d\'analyser la réponse: $e');
        }
        
        print('✅ Données enregistrées avec succès');
        return true;
      } else {
        print('❌ Erreur ${response.statusCode}: ${response.body}');
        return false;
      }
    } catch (e, stackTrace) {
      print('❌ Exception lors de l\'envoi à Airtable:');
      print('Type d\'erreur: ${e.runtimeType}');
      print('Message: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}
