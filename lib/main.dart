// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'screens/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize AdMob
  await MobileAds.instance.initialize();

  // Initialize RevenueCat
  await Purchases.setLogLevel(LogLevel.info);
  // TODO: Replace with your real RevenueCat Public API Key before release
  await Purchases.configure(PurchasesConfiguration("goog_PLACEHOLDER_KEY"));

  runApp(const LexiconApp());
}

class LexiconApp extends StatelessWidget {
  const LexiconApp({super.key});

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
      home: const MainMenuScreen(),
    );
  }
}