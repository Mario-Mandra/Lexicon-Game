// File: lib/data/word_bank.dart
import 'package:flutter/material.dart';
import 'packs/generic.dart';
import 'packs/after_dark.dart';
import 'packs/pop_culture.dart';

class WordPack {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Map<String, List<String>> localizedWords; 

  const WordPack({
    required this.id, required this.title, required this.subtitle, 
    required this.icon, required this.localizedWords,
  });
}

const List<WordPack> availableWordPacks = [
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
    id: 'after_dark',
    title: 'After Dark',
    subtitle: 'For when you play after sun down',
    icon: Icons.nightlight_round,
    localizedWords: afterDarkWords, 
  ),
];

const Map<String, String> languageNames = {'ro': 'Română', 'en': 'English'};