// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'models/game_settings.dart';
import 'screens/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await MobileAds.instance.initialize();

  // Initialize RevenueCat with your real API key
  await Purchases.setLogLevel(LogLevel.debug);
  await Purchases.configure(
    PurchasesConfiguration("test_iQDJwcHgWSvoClmUiYAIRegVopq"),
  );

  // Restore purchases on every launch
  final settings = GameSettings();
  await settings.initializeAccess();

  runApp(LexiconApp(settings: settings));
}

class LexiconApp extends StatelessWidget {
  final GameSettings settings;

  const LexiconApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lexicon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF00FF),
          brightness: Brightness.dark,
          primary: const Color(0xFFFF00FF),
        ),
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: MainMenuScreen(settings: settings),
    );
  }
}