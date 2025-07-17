import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash_screen.dart';

// Clés API (configuration temporaire)
const String openAiApiKey = 'AIzaSyCB4ZRqEtK0jq1K6pe8YIEbo6ZDClL-aa4';

// Configuration Airtable
const String airtableApiKey = 'pat277eOGKWhtvCFG.92393623e73c60487b6f01001a976736a8129990210e99342c115aaedfc1b486';
const String airtableBaseId = 'appAKwBROwR1YdbgH';  // Doit commencer par 'app'
const String airtableTableName = 'tbl8nnIC9j2xLbxil';  // ID de la table

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
