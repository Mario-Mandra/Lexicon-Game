// File: lib/data/word_bank.dart
import 'package:flutter/material.dart';
import '../models/game_settings.dart'; 
import 'packs/generic.dart';
import 'packs/after_dark.dart';
import 'packs/pop_culture.dart';

class WordPack {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Map<String, List<String>> localizedWords;
  final bool isLocked;
  final bool requiresPremium; // ADDED: Strict firewall for top-tier features

  const WordPack({
    required this.id, 
    required this.title, 
    required this.subtitle, 
    required this.icon, 
    required this.localizedWords,
    this.isLocked = false,
    this.requiresPremium = false, // Defaults to false
  });

  bool effectivelyLocked(GameSettings settings) {
    // 1. Premium users get everything instantly.
    if (settings.isPremium) return false; 
    
    // 2. FIREWALL: If they aren't premium, and the pack requires it, KEEP IT LOCKED.
    // This blocks ads and single purchases from bypassing the premium wall.
    if (requiresPremium) return true; 

    // 3. Ad and Purchase checks for standard locked packs.
    if (settings.adSessionActive) return false; 
    if (settings.unlockedPackIds.contains(id)) return false; 
    
    // 4. Default fallback
    return isLocked;
  }
}

const List<WordPack> availableWordPacks = [
  WordPack(
    id: 'generic',
    title: 'Generic',
    subtitle: 'Everyday objects. Perfect for families.',
    icon: Icons.extension_rounded,
    localizedWords: genericWords, 
    isLocked: false,
  ),
  WordPack(
    id: 'pop_culture',
    title: 'Pop Culture',
    subtitle: 'Movies, music, and internet icons.',
    icon: Icons.movie_filter_rounded,
    localizedWords: popCultureWords, 
    isLocked: true,
  ),
  WordPack(
    id: 'after_dark',
    title: 'After Dark',
    subtitle: 'For when you play after sun down',
    icon: Icons.nightlight_round,
    localizedWords: afterDarkWords,
    isLocked: true,
  ),
  WordPack(
    id: 'custom',
    title: 'Custom Pack',
    subtitle: 'Create your own list of words.',
    icon: Icons.dashboard_customize_rounded,
    localizedWords: {'en': [], 'ro': []},
    isLocked: true,
    requiresPremium: true, // ADDED: Only Premium members can access this
  ),
];

const Map<String, String> languageNames = {'ro': 'Română', 'en': 'English'};