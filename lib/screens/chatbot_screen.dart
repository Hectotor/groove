import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:groove_nomad/main.dart';

// Modèle pour stocker les réponses du formulaire
class FestivalPreferences {
  dynamic numberOfPeople;
  String? destinationCountry;
  String? destinationCity;
  dynamic travelDate;
  dynamic duration;
  String? musicGenre;
  dynamic budget;
  String? name;
  String? email;

  FestivalPreferences({
    this.numberOfPeople,
    this.destinationCountry,
    this.destinationCity,
    this.travelDate,
    this.duration,
    this.musicGenre,
    this.budget,
    this.name,
    this.email,
  });

  // Méthodes pour obtenir les valeurs avec conversion
  String get numberOfPeopleStr => _toString(numberOfPeople);
  String get durationStr => _toString(duration);
  String get budgetStr => _toString(budget);
  String get travelDateStr {
    if (travelDate == null) return '';
    if (travelDate is String) return travelDate;
    if (travelDate is DateTime) return travelDate.toString();
    return travelDate.toString();
  }

  String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'numberOfPeople': numberOfPeopleStr,
      'destinationCountry': destinationCountry,
      'destinationCity': destinationCity,
      'travelDate': travelDateStr,
      'duration': durationStr,
      'musicGenre': musicGenre,
      'budget': budgetStr,
      'name': name,
      'email': email,
    };
  }
  
  // Méthode pour définir une valeur par sa clé
  void operator []=(String key, dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return;
    
    switch (key) {
      case 'numberOfPeople':
        numberOfPeople = value.toString();
        break;
      case 'destinationCountry':
        destinationCountry = value.toString();
        break;
      case 'destinationCity':
        destinationCity = value.toString();
        break;
      case 'travelDate':
        travelDate = value.toString();
        break;
      case 'duration':
        duration = value.toString();
        break;
      case 'musicGenre':
        musicGenre = value?.toString();
        break;
      case 'budget':
        budget = value.toString();
        break;
      case 'name':
        name = value?.toString();
        break;
      case 'email':
        email = value?.toString();
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
  late FestivalPreferences _preferences = FestivalPreferences()..email = 'hector.chablis@gmail.com';
  int _currentQuestionIndex = 0;
  bool _isFormComplete = false;
  
  // Questions du formulaire - version conversationnelle
  final List<Map<String, dynamic>> _formQuestions = [
    {
      'question': 'Pour commencer, pour combien de personnes prévoyez-vous ce voyage musical ?',
      'key': 'numberOfPeople',
      'type': 'text',
    },
    {
      'question': 'Super ! Dans quel pays aimeriez-vous vivre cette expérience musicale ?',
      'key': 'destinationCountry',
      'type': 'text',
    },
    {
      'question': 'Quand souhaitez-vous partir ? (par exemple : "la semaine prochaine", "en août", "l\'été prochain")',
      'key': 'travelDate',
      'type': 'text',
    },
    {
      'question': 'Combien de temps souhaitez-vous rester sur place ? (par exemple : "un week-end", "une semaine", "10 jours")',
      'key': 'duration',
      'type': 'text',
    },
    {
      'question': 'Quel style de musique vous fait vibrer ? (par exemple : "électro", "rock", "jazz", "hip-hop")',
      'key': 'musicGenre',
      'type': 'text',
    },
    {
      'question': 'Quel est votre budget par personne pour ce voyage ? (par exemple : "environ 500€", "entre 1000 et 1500€")',
      'key': 'budget',
      'type': 'text',
    },
  ];

  @override
  void initState() {
    super.initState();
    _apiKey = openAiApiKey;
    
    // Message d'accueil personnalisé
    _messages.add(ChatMessage(
      text: '🎵 Bienvenue sur Groove Nomad Lola Beille ! Je vais vous aider à trouver votre evasion musicale pour vous.',
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
    // Réinitialiser l'index
    _currentQuestionIndex = 0;
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

  // Traiter la réponse de l'utilisateur de manière naturelle
  void _processAnswer(String answer) async {
    if (_currentQuestionIndex >= _formQuestions.length) return;
    
    setState(() {
      _isTyping = true; // Indiquer que le traitement est en cours
    });
    
    final currentQuestion = _formQuestions[_currentQuestionIndex];
    final key = currentQuestion['key'] as String;
    
    try {
      // Toutes les réponses sont traitées comme du texte, l'IA s'occupera de l'interprétation
      _preferences[key] = answer.trim();
      
      // Pour les emails, on fait une vérification basique mais on laisse passer
      if (key == 'email' && (!answer.contains('@') || !answer.contains('.'))) {
        // On laisse passer quand même mais on pourrait ajouter un avertissement si nécessaire
        debugPrint('Email potentiellement invalide : $answer');
      }
      
      _currentQuestionIndex++;
      
      // Utiliser un délai pour s'assurer que l'interface est mise à jour
      await Future.delayed(const Duration(milliseconds: 100));
      
      _askNextQuestion();
    } catch (e) {
      debugPrint('Erreur lors du traitement de la réponse: $e');
    } finally {
      // S'assurer que _isTyping est toujours désactivé même en cas d'erreur
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    }
  }

  // Générer une proposition personnalisée
  void _generateProposal() async {
    setState(() {
      _isTyping = true;
      _isFormComplete = true;
    });

    try {
      // Construire le message pour l'IA avec une approche plus naturelle
      final prompt = '''
      Voici les informations pour un voyage musical personnalisé :
      
      Pour : Lola Beille\n
      - Nombre de voyageurs : ${_preferences.numberOfPeople ?? 'non précisé'}
      - Destination : ${_preferences.destinationCountry ?? 'non précisé'}
      - Période : ${_preferences.travelDate ?? 'non précisée'}
      - Durée : ${_preferences.duration ?? 'non précisée'}
      - Style musical : ${_preferences.musicGenre ?? 'non précisé'}
      - Budget : ${_preferences.budget ?? 'non précisé'}
      
      Crée une proposition de voyage détaillée avec :
      
      1. UNIQUEMENT le nom d'un festival correspondant aux critères, sans description
      
      2. Une proposition de voyage détaillée avec les éléments suivants :
         - Dates du séjour : [date de départ] au [date de retour] (incluant les jours de voyage)
         - Vols A/R : [compagnie aérienne] - [prix par personne]€ (varie selon disponibilité)
           * Aller : [date] - [ville de départ] → [ville d'arrivée] - [horaires]
           * Retour : [date] - [ville d'arrivée] → [ville de départ] - [horaires]
         - Hébergement : [type d\'hébergement] - [prix total]€ (du [date check-in] au [date check-out])
         - Billets festival : [type de pass] - [prix par personne]€ (valable du [date début] au [date fin])
         - Extras : [options comme transferts, assurances] - [prix total]€ (facultatif)
         
         TOTAL ESTIMÉ : [montant total]€
         
         Note : Les prix sont donnés à titre indicatif et peuvent varier selon la période de réservation et les disponibilités.
      
      3. À la fin de ta réponse, pose la question suivante :
      "Souhaitez-vous recevoir ce devis détaillé par email ? Si oui, répondez simplement OUI à ce message."
      
      IMPORTANT : Inclus des dates précises pour chaque élément (vols, hébergement, festival) en te basant sur la période indiquée.
      
      Sois concis et professionnel. Ne mets pas de texte avant la proposition de voyage.
      
      IMPORTANT : Les prix doivent être réalistes et variés, sans forcément correspondre au budget indiqué. 
      Propose des options qui ont du sens par rapport à la destination et au type de festival, même si ça dépasse légèrement le budget mentionné.
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

  // Vérifier si l'utilisateur a répondu OUI pour recevoir le devis
  bool _checkForEmailConfirmation(String message) {
    return message.trim().toLowerCase() == 'oui';
  }

  // Envoyer le devis par email via l'API
  Future<void> _sendQuoteByEmail() async {
    setState(() {
      _isTyping = true;
      _messages.add(ChatMessage(
        text: "Je vous envoie le devis par email à hector.chablis@gmail.com. Merci Lola !",
        isUser: false,
      ));
    });
    
    // Ici, vous pourriez ajouter l'appel à votre service d'email
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isTyping = false;
    });
  }

  // Méthode pour envoyer un message et obtenir une réponse de l'API
  void _sendMessage(String message) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;
    
    setState(() {
      _messages.add(ChatMessage(text: trimmedMessage, isUser: true));
      _isTyping = true;
      _messageController.clear();
    });
    
    // Vérifier si l'utilisateur a répondu OUI pour recevoir le devis
    if (_checkForEmailConfirmation(trimmedMessage)) {
      await _sendQuoteByEmail();
      return;
    }

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
