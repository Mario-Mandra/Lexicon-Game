// File: lib/screens/main_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'rules_screen.dart';
import 'game_setup_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // --- THE NEW LEGALLY DISTINCT BRANDING ---
              Text(
                'LEXICON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56, // Slightly smaller to fit the longer word perfectly
                  fontWeight: FontWeight.w900,
                  letterSpacing: 12,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: theme.colorScheme.primary.withAlpha(150), blurRadius: 30)
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'THE PASS & PLAY PARTY GAME',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white54, letterSpacing: 4, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              
              MenuIsland(
                title: 'HOST GAME',
                subtitle: 'Create a new local room',
                icon: Icons.add_circle_outline,
                isPrimary: true, 
                onTap: () {
                  HapticFeedback.lightImpact(); 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GameSetupScreen()),
                  );
                },
              ),
              const SizedBox(height: 16), 
              
              MenuIsland(
                title: 'HOW TO PLAY',
                subtitle: 'Read the rules',
                icon: Icons.menu_book_rounded,
                isPrimary: false, 
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RulesScreen()),
                  );
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuIsland extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const MenuIsland({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [theme.colorScheme.surface, const Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: isPrimary 
              ? Border.all(color: theme.colorScheme.primary.withAlpha(150), width: 2)
              : Border.all(color: theme.colorScheme.primary.withAlpha(20), width: 1),
          boxShadow: isPrimary 
              ? [BoxShadow(color: theme.colorScheme.primary.withAlpha(30), blurRadius: 20, spreadRadius: 2)]
              : [],
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: isPrimary ? theme.colorScheme.primary : Colors.white),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1, color: isPrimary ? theme.colorScheme.primary : Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.white54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }
}