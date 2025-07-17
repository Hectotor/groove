import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

// Classe pour représenter un message dans le chat
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  
  @override
  void initState() {
    super.initState();
    // Ajouter les messages d'accueil
    _messages.add(ChatMessage(
      text: '🎵 Bonjour ! Je suis votre assistant spécialisé dans les festivals de musique. Comment puis-je vous aider à vivre une expérience inoubliable ?',
      isUser: false,
    ));
    _messages.add(ChatMessage(
      text: 'Je peux vous aider à :\n• Trouver des festivals par genre ou localisation\n• Réserver des billets et des hébergements\n• Donner des conseils pour votre séjour\n• Répondre à toutes vos questions sur les festivals',
      isUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistance Festivals'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + 1, // +1 pour les suggestions
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  // Afficher les suggestions uniquement si nous sommes au début
                  return _messages.length <= 2 ? Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        _buildSuggestionButton('Festivals cet été', context),
                        _buildSuggestionButton('Top festivals électro', context),
                        _buildSuggestionButton('Hébergements près des festivals', context),
                        _buildSuggestionButton('Conseils pour les festivals', context),
                      ],
                    ),
                  ) : Container(); // Ne pas afficher les suggestions après les premières interactions
                }
                return _ChatBubble(
                  message: _messages[index].text,
                  isMe: _messages[index].isUser,
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  Text("L'assistant est en train d'écrire..."),
                ],
              ),
            ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildSuggestionButton(String text, BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Envoyer la suggestion comme message utilisateur
        _sendMessage(text);
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Theme.of(context).primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border(
              top: BorderSide(color: Colors.grey[300]!), 
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Tapez votre message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _sendMessage(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Méthode pour envoyer un message et obtenir une réponse de l'API
  void _sendMessage(String message) async {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isTyping = true;
      _messageController.clear();
    });

    try {
      // Appel à l'API OpenAI (ou autre API d'IA)
      final response = await _getAIResponse(message);
      
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: "Désolé, je n'ai pas pu traiter votre demande. Veuillez réessayer plus tard.",
          isUser: false,
        ));
      });
      print("Erreur lors de l'appel à l'API: $e");
    }
  }

  // Méthode pour obtenir une réponse de l'API d'IA
  Future<String> _getAIResponse(String message) async {
    // Utilisation de l'API Google Gemini
    final apiKey = 'AIzaSyCB4ZRqEtK0jq1K6pe8YIEbo6ZDClL-aa4';
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'text': 'Tu es un assistant spécialisé dans les festivals de musique. Tu aides les utilisateurs à trouver des informations sur les festivals, à planifier leur voyage, et à répondre à toutes leurs questions concernant les événements musicaux. Voici la question de l\'utilisateur: $message'
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 800,
            'topP': 0.8,
            'topK': 40
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Structure de réponse différente pour Gemini
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print('Erreur API: ${response.statusCode} - ${response.body}');
        return "Désolé, je n'ai pas pu traiter votre demande. Veuillez réessayer plus tard.";
      }
    } catch (e) {
      print('Exception lors de l\'appel API: $e');
      return "Désolé, je n'ai pas pu traiter votre demande. Veuillez réessayer plus tard.";
    }
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  const _ChatBubble({
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
