import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:groove_nomad/main.dart';
import 'package:groove_nomad/services/pdf_service.dart';

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
      case 'numberOfPeople': 
        return numberOfPeople is String ? int.tryParse(numberOfPeople) : numberOfPeople;
      case 'destinationCountry': 
        return destinationCountry;
      case 'destinationCity': 
        return destinationCity;
      case 'travelDate': 
        return travelDate;
      case 'duration': 
        return duration is String ? int.tryParse(duration) : duration;
      case 'musicGenre': 
        return musicGenre;
      case 'budget': 
        return budget is String ? int.tryParse(budget) : budget;
      case 'name': 
        return name;
      case 'email': 
        return email;
      default: 
        return null;
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
  String _lastDevisContent = ''; // Pour stocker le dernier devis généré
  
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
      **GROOVE NOMAD - DEVIS PERSONNALISÉ**
      *Pour : Lola Beille*
      *Date : ${DateTime.now().toString().substring(0, 10)}*
      
      **INFORMATIONS CLIENT**
      👥 Nombre de voyageurs : ${_preferences.numberOfPeople ?? 'Non précisé'}
      🎯 Destination : ${_preferences.destinationCountry ?? 'Non précisée'}
      📅 Période : ${_preferences.travelDate ?? 'Non précisée'}
      ⏱️ Durée : ${_preferences.duration ?? 'Non précisée'}
      🎵 Style musical : ${_preferences.musicGenre ?? 'Non précisé'}
      💰 Budget : ${_preferences.budget ?? 'Non précisé'}
      
      **PROPOSITION DE VOYAGE**
      
      🎪 **FESTIVAL SÉLECTIONNÉ**
      [Nom du festival correspondant aux critères]
      
      ✈️ **VOLS ALLER-RETOUR**
      • Compagnie : [Nom de la compagnie aérienne]
      • Prix par personne : [Prix] €
      • Aller : [Date] - Départ [Heure] • [Ville de départ] → [Ville d'arrivée] • Arrivée [Heure]
      • Retour : [Date] - Départ [Heure] • [Ville d'arrivée] → [Ville de départ] • Arrivée [Heure]
      
      🏨 **HÉBERGEMENT**
      • Type : [Hôtel/Auberge/Appartement]
      • Nom : [Nom de l'établissement]
      • Période : Du [Date check-in] au [Date check-out]
      • Prix total : [Prix] €
      
      🎟️ **BILLETS FESTIVAL**
      • Type de pass : [Pass 1 jour/Pass 3 jours/Pass VIP]
      • Période de validité : Du [Date début] au [Date fin]
      • Prix par personne : [Prix] €
      
      🎁 **OPTIONS SUPPLÉMENTAIRES**
      • Transferts aéroport : [Oui/Non] • [Prix] €
      • Assurance voyage : [Oui/Non] • [Prix] €
      • Autres options : [Détails] • [Prix] €
      
      💶 **RÉCAPITULATIF DES TARIFS**
      • Vols : [Prix total] €
      • Hébergement : [Prix total] €
      • Billets festival : [Prix total] €
      • Options : [Prix total] €
      
      💰 **TOTAL ESTIMÉ : [MONTANT TOTAL] €**
      
      *Les prix sont donnés à titre indicatif et peuvent varier selon la période de réservation et les disponibilités.*
      
      ---
      
      Souhaitez-vous recevoir ce devis détaillé par email ? Si oui, répondez simplement OUI à ce message.
      
      *Notre équipe reste à votre disposition pour toute question ou modification de ce devis.*
      
      **L'équipe Groove Nomad**
      ✉️ contact@groovenomad.com
      🌐 www.groovenomad.com
      
      [IMPORTANT : Utilise des dates et prix réalistes en fonction de la destination et de la période. Sois précis et professionnel dans ta réponse.]
      ''';

      String fullResponse = await _getAIResponse(prompt);
      
      // Séparer la réponse de l'IA et la question de confirmation
      final parts = fullResponse.split('Souhaitez-vous recevoir ce devis détaillé par email ?');
      final devisContent = parts[0].trim();
      
      // Stocker le contenu du devis pour l'enregistrement (sans la question de confirmation)
      _lastDevisContent = devisContent;
      
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: fullResponse, // Utilisation de fullResponse au lieu de response
          isUser: false,
        ));
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

  // Envoyer le devis par email via Airtable
  Future<void> _sendQuoteByEmail() async {
    setState(() {
      _isTyping = true;
      _messages.add(ChatMessage(
        text: "Je vous envoie le devis par email. Merci Lola !",
        isUser: false,
      ));
    });

    try {
      // Récupérer la dernière réponse de l'IA
      final lastAIMessage = _messages.lastWhere((m) => !m.isUser).text;
      final devisContent = _lastDevisContent.isNotEmpty ? _lastDevisContent : lastAIMessage;
      
      // Générer le PDF et l'envoyer à Airtable avec le lien Catbox
      final success = await PdfService.generateAndSendPdf(
        clientName: 'Lola Beille',
        email: 'hector.chablis@gmail.com',
        preferences: {
          'numberOfPeople': _preferences.numberOfPeople?.toString() ?? 'Non précisé',
          'destinationCountry': _preferences.destinationCountry ?? 'Non précisée',
          'travelDate': _preferences.travelDate ?? 'Non précisée',
          'duration': _preferences.duration ?? 'Non précisée',
          'musicGenre': _preferences.musicGenre ?? 'Non précisé',
          'budget': _preferences.budget?.toString() ?? 'Non précisé',
        },
        devisDetails: {
          'contenu': devisContent,
          'date': DateTime.now().toIso8601String(),
        },
        airtableApiKey: airtableApiKey,
        airtableBaseId: airtableBaseId,
        airtableTableName: airtableTableName,
      );

      if (!success) {
        _showError('Erreur lors de la génération du PDF et de l\'enregistrement. Veuillez réessayer.');
      }
    } catch (e) {
      debugPrint('Erreur: $e');
      _showError('Une erreur est survenue. Veuillez réessayer plus tard.');
    } finally {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
