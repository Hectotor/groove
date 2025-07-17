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
    // Construction de l'URL de l'API Airtable
    final url = '$_baseUrl/$baseId/$tableName';
    
    try {
      print('🔄 Envoi des données à Airtable...');
      print('🔑 Clé API: ${apiKey.substring(0, 10)}...');
      print('🌐 URL: $url');
      print('📊 Base ID: $baseId');
      print('📋 Table: $tableName');
      
      final body = {
        'fields': {
          'Nom': nomClient,
          'Email': email,
          'Date': DateTime.now().toIso8601String(),
          'Résumé': resumeDevis,
        },
      };
      
      print('Données à envoyer: ${jsonEncode(body)}');
      
      print('📤 Envoi de la requête...');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
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
}
