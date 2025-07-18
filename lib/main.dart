import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'splash_screen.dart';

// Clés API (configuration temporaire)
const String openAiApiKey = 'CLÉ API';

// Configuration Airtable
const String airtableApiKey = 'CLÉ API';
const String airtableBaseId = 'CLÉ API';  // Doit commencer par 'app'
const String airtableTableName = 'CLÉ API';  // ID de la table

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  
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
