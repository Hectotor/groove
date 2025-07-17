import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:groove_nomad/main.dart';

// Modèle pour stocker les réponses du formulaire
class FestivalPreferences {
  int? numberOfPeople;
  String? destinationCountry;
  String? destinationCity;
  DateTime? travelDate;
  int? duration;
  String? musicGenre;
  double? budget;
  String? name;
  String? email;
  
  bool get isComplete => 
      numberOfPeople != null &&
      destinationCountry != null &&
      destinationCity != null &&
      travelDate != null &&
      duration != null &&
      musicGenre != null &&
      budget != null &&
      name != null &&
      email != null;
      
  // Méthode pour convertir les préférences en Map
  Map<String, dynamic> toJson() {
    return {
      'numberOfPeople': numberOfPeople,
      'destinationCountry': destinationCountry,
      'destinationCity': destinationCity,
      'travelDate': travelDate?.toIso8601String(),
      'duration': duration,
      'musicGenre': musicGenre,
      'budget': budget,
      'name': name,
      'email': email,
    };
  }
  
  // Méthode pour définir une valeur par sa clé
  void operator []=(String key, dynamic value) {
    switch (key) {
      case 'numberOfPeople':
        numberOfPeople = value as int?;
        break;
      case 'destinationCountry':
        destinationCountry = value as String?;
        break;
      case 'destinationCity':
        destinationCity = value as String?;
        break;
      case 'travelDate':
        if (value is String) {
          travelDate = DateTime.tryParse(value);
        } else if (value is DateTime) {
          travelDate = value;
        }
        break;
      case 'duration':
        duration = value as int?;
        break;
      case 'musicGenre':
        musicGenre = value as String?;
        break;
      case 'budget':
        if (value is int) {
          budget = value.toDouble();
        } else {
          budget = value as double?;
        }
        break;
      case 'name':
        name = value as String?;
        break;
      case 'email':
        email = value as String?;
        break;
    }
  }
  
  // Méthode pour obtenir une valeur par sa clé
  dynamic operator [](String key) {
    switch (key) {
      case 'numberOfPeople': return numberOfPeople;
      case 'destinationCountry': return destinationCountry;
      case 'destinationCity': return destinationCity;
      case 'travelDate': return travelDate;
      case 'duration': return duration;
      case 'musicGenre': return musicGenre;
      case 'budget': return budget;
      case 'name': return name;
      case 'email': return email;
      default: return null;
    }
  }
}

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
  String? _apiKey;
  
  // État du formulaire
  final FestivalPreferences _preferences = FestivalPreferences();
  int _currentQuestionIndex = 0;
  bool _isFormComplete = false;
  
  // Questions du formulaire
  final List<Map<String, dynamic>> _formQuestions = [
    {
      'question': 'Pour combien de personnes souhaitez-vous réserver ?',
      'key': 'numberOfPeople',
      'type': 'number',
    },
    {
      'question': 'Dans quel pays souhaitez-vous aller ?',
      'key': 'destinationCountry',
      'type': 'text',
    },
    {
      'question': 'Quand souhaitez-vous partir ? (par exemple: la semaine prochaine, en août, l\'été prochain, etc.)',
      'key': 'travelDate',
      'type': 'text',
    },
    {
      'question': 'Combien de jours durera votre séjour ?',
      'key': 'duration',
      'type': 'number',
    },
    {
      'question': 'Quel genre de musique préférez-vous ? (ex: électro, rock, jazz, etc.)',
      'key': 'musicGenre',
      'type': 'text',
    },
    {
      'question': 'Quel est votre budget approximatif par personne (en €) ?',
      'key': 'budget',
      'type': 'number',
    },
    {
      'question': 'Quel est votre prénom et nom ?',
      'key': 'name',
      'type': 'text',
    },
    {
      'question': 'Quelle est votre adresse email ?',
      'key': 'email',
      'type': 'email',
    },
  ];

  @override
  void initState() {
    super.initState();
    _apiKey = openAiApiKey;
    
    // Message d'accueil personnalisé
    _messages.add(ChatMessage(
      text: '🎵 Bienvenue sur Groove Nomad ! Je vais vous aider à trouver votre evasion musicale pour vous.',
      isUser: false,
    ));
    
    // Démarrer le formulaire
    _startForm();
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
                  return Container(); // Ne plus afficher de suggestions
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
                  enabled: !_isTyping,
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
                  onPressed: _isTyping
                      ? null
                      : () {
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
  
  // Démarrer le formulaire
  void _startForm() {
    _askNextQuestion();
  }

  // Poser la question suivante du formulaire
  void _askNextQuestion() {
    if (_currentQuestionIndex < _formQuestions.length) {
      final question = _formQuestions[_currentQuestionIndex]['question'];
      setState(() {
        _isTyping = false; // S'assurer que l'interface n'est pas bloquée
        _messages.add(ChatMessage(text: question, isUser: false));
      });
    } else {
      // Toutes les questions ont été posées, générer la proposition
      _generateProposal();
    }
  }

  // Traiter la réponse de l'utilisateur
  void _processAnswer(String answer) async {
    if (_currentQuestionIndex >= _formQuestions.length) return;
    
    setState(() {
      _isTyping = true; // Indiquer que le traitement est en cours
    });
    
    final currentQuestion = _formQuestions[_currentQuestionIndex];
    final key = currentQuestion['key'] as String;
    
    // Valider et traiter la réponse selon le type
    try {
      switch (currentQuestion['type']) {
        case 'number':
          final value = int.tryParse(answer);
          if (value != null) {
            _preferences[key] = value;
          } else {
            _showError('Veuillez entrer un nombre valide');
            return;
          }
          break;
        case 'date':
          // On laisse l'IA interpréter la date
          _preferences[key] = answer;
          break;
        case 'email':
          if (answer.contains('@') && answer.contains('.')) {
            _preferences[key] = answer;
          } else {
            _showError('Veuillez entrer une adresse email valide');
            return;
          }
          break;
        default:
          _preferences[key] = answer;
      }
      
      _currentQuestionIndex++;
      
      // Utiliser un délai pour s'assurer que l'interface est mise à jour
      await Future.delayed(const Duration(milliseconds: 100));
      
      _askNextQuestion();
    } finally {
      // S'assurer que _isTyping est toujours désactivé même en cas d'erreur
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: false));
    });
  }

  // Générer une proposition personnalisée
  void _generateProposal() async {
    setState(() {
      _isTyping = true;
      _isFormComplete = true;
    });

    try {
      // Construire le message pour l'IA
      final prompt = '''
      L'utilisateur cherche un voyage musical avec les critères suivants :
      - Nombre de personnes: ${_preferences.numberOfPeople}
      - Pays de destination: ${_preferences.destinationCountry}
      - Période de voyage: ${_preferences.travelDate}
      - Durée du séjour: ${_preferences.duration} jours
      - Genre musical: ${_preferences.musicGenre}
      - Budget par personne: ${_preferences.budget}€
      
      Crée une proposition de voyage complète qui comprend :
      1. Un festival de musique correspondant aux critères, dans une ville adaptée au genre musical
      2. Des options de vols depuis la France avec des prix indicatifs
      3. Des suggestions d'hébergements à proximité du festival avec des fourchettes de prix
      4. Un budget global estimé
      
      Sois précis dans tes propositions et utilise des informations réalistes. 
      Si la période n'est pas précise, propose plusieurs options de dates avec des festivals.
      ''';

      final response = await _getAIResponse(prompt);
      
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: "Désolé, je n'ai pas pu générer de proposition. Veuillez réessayer plus tard.",
          isUser: false,
        ));
      });
      print("Erreur lors de la génération de la proposition: $e");
    }
  }

  // Méthode pour envoyer un message et obtenir une réponse de l'API
  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isTyping = true;
      _messageController.clear();
    });

    if (!_isFormComplete) {
      // Si le formulaire n'est pas complet, traiter la réponse
      _processAnswer(message);
    } else {
      // Sinon, utiliser l'IA pour répondre
      try {
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
  }

  // Méthode pour obtenir une réponse de l'API d'IA
  Future<String> _getAIResponse(String message) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return 'Désolé, le service de chat n\'est pas configuré correctement. Veuillez contacter le support.';
    }
    
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_apiKey');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': '''
                Tu es un assistant spécialisé dans les festivals de musique pour Groove Nomad. 
                Ton rôle est d'aider les utilisateurs à trouver le festival parfait et à organiser leur voyage.
                
                Voici les informations à utiliser pour répondre :
                $message
                
                Sois amical, professionnel et précis dans tes réponses.
                Si on te demande de recommander un festival, propose des options qui correspondent aux préférences de l'utilisateur.
                '''}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.8,
            'maxOutputTokens': 2000,
            'stopSequences': []
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
