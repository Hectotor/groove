import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Service pour téléverser des fichiers sur Catbox.moe
class CatboxService {
  /// Téléverse un fichier sur Catbox.moe et retourne l'URL du fichier
  static Future<String?> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      print('🌐 Préparation du téléversement vers Catbox.moe...');
      print('📄 Taille du fichier: ${fileBytes.length} bytes');
      print('📁 Nom du fichier: $fileName');
      
      final url = Uri.parse('https://catbox.moe/user/api.php');
      final request = http.MultipartRequest('POST', url);
      
      // Ajouter le fichier
      final file = http.MultipartFile.fromBytes(
        'fileToUpload',
        fileBytes,
        filename: fileName,
      );
      
      request.files.add(file);
      
      // Ajouter le type de requête
      request.fields['reqtype'] = 'fileupload';
      
      print('📤 Envoi du fichier vers Catbox.moe...');
      print('📎 Détails de la requête:');
      print('- URL: $url');
      print('- Nombre de fichiers: ${request.files.length}');
      print('- Champs: ${request.fields}');
      
      final stopwatch = Stopwatch()..start();
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      stopwatch.stop();
      
      print('⏱️  Temps de réponse: ${stopwatch.elapsedMilliseconds}ms');
      print('🔢 Status code: ${response.statusCode}');
      print('📦 En-têtes de la réponse: ${response.headers}');
      
      if (response.statusCode == 200) {
        final fileUrl = response.body.trim();
        print('📥 Réponse brute de Catbox:');
        print('   Code de statut: ${response.statusCode}');
        print('   Longueur de la réponse: ${response.body.length} caractères');
        print('   Contenu: "$fileUrl"');
        
        if (fileUrl.startsWith('http')) {
          print('✅ Fichier téléversé avec succès sur Catbox.moe');
          print('🔗 URL du fichier: $fileUrl');
          
          // Vérifier que l'URL est accessible
          try {
            final testResponse = await http.head(Uri.parse(fileUrl));
            print('🔍 Test d\'accès au fichier:');
            print('   Status: ${testResponse.statusCode}');
            print('   Content-Type: ${testResponse.headers['content-type']}');
            
            if (testResponse.statusCode != 200) {
              print('❌ Le fichier n\'est pas accessible (${testResponse.statusCode})');
              return null;
            }
          } catch (e) {
            print('⚠️ Impossible de vérifier l\'accès au fichier: $e');
          }
          
          return fileUrl;
        } else {
          print('❌ Réponse inattendue de Catbox:');
          print('   La réponse ne commence pas par http');
          
          // Essayer d'extraire une URL si elle est dans la réponse
          final urlMatch = RegExp(r'(https?://[^\s]+)').firstMatch(fileUrl);
          if (urlMatch != null) {
            final extractedUrl = urlMatch.group(1);
            print('ℹ️ URL extraite de la réponse: $extractedUrl');
            return extractedUrl;
          }
          
          return null;
        }
      } else {
        print('❌ Échec du téléversement:');
        print('   Code de statut: ${response.statusCode}');
        print('   Corps de la réponse: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      print('❌ Erreur lors du téléversement sur Catbox:');
      print('   Type d\'erreur: ${e.runtimeType}');
      print('   Message: $e');
      print('   Stack trace: $stackTrace');
      return null;
    }
  }
}
