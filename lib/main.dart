import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the new library
import 'screens/main_menu_screen.dart';

void main() {
  runApp(const AliasGameApp());
}

class AliasGameApp extends StatelessWidget {
  const AliasGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass and Play Alias',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF00FF), // Neon Magenta
          surface: Color(0xFF1A1A1A), // The "Island" dark gray color
        ),
        useMaterial3: true,
        // Override the default font with Poppins for a premium, geometric look
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFFF00FF),
          elevation: 0,
        ),
      ),
      home: const MainMenuScreen(), 
    );
  }
}