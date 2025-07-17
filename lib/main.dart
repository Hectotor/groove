import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash_screen.dart';

// Clé API directement dans le code (temporaire pour le débogage)
const String openAiApiKey = 'AIzaSyCB4ZRqEtK0jq1K6pe8YIEbo6ZDClL-aa4';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Temporairement désactivé pour résoudre les problèmes d'initialisation
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const GrooveNomadApp());
}

class GrooveNomadApp extends StatelessWidget {
  const GrooveNomadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Groove Nomad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'), // Français
      ],
      locale: const Locale('fr', 'FR'),
      home: const SplashScreen(),
    );
  }
}
