// File: lib/data/word_bank.dart
import 'package:flutter/material.dart';
import 'packs/generic.dart';
import 'packs/pop_culture.dart';
import 'packs/celebrities.dart'; 

class WordPack {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Map<String, List<String>> localizedWords; 

  const WordPack({
    required this.id, 
    required this.title, 
    required this.subtitle, 
    required this.icon, 
    required this.localizedWords,
  });
}

// Removing 'const' from the list allows it to handle the imported maps safely
final List<WordPack> availableWordPacks = [
  WordPack(
    id: 'generic',
    title: 'Generic',
    subtitle: 'Everyday objects. Perfect for families.',
    icon: Icons.extension_rounded,
    localizedWords: genericWords, 
  ),
  WordPack(
    id: 'pop_culture',
    title: 'Pop Culture',
    subtitle: 'Movies, music, and internet icons.',
    icon: Icons.movie_filter_rounded,
    localizedWords: popCultureWords, 
  ),
  WordPack(
    id: 'celebrities',
    title: 'Celebrities',
    subtitle: 'Famous people from around the world.',
    icon: Icons.star_rounded,
    localizedWords: celebritiesWords, 
  ),
];

const Map<String, String> languageNames = {'ro': 'Română', 'en': 'English'};