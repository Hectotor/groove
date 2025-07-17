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
    final url = '$_baseUrl/$baseId/$tableName';
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fields': {
            'Nom': nomClient,
            'Email': email,
            'Date': DateTime.now().toIso8601String(),
            'Résumé': resumeDevis,
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de l\'envoi à Airtable: $e');
      return false;
    }
  }
}
