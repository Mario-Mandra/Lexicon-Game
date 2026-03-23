// File: lib/data/word_bank.dart

import 'package:flutter/material.dart';
import '../models/game_settings.dart';
import 'packs/generic.dart';
import 'packs/after_dark.dart';
import 'packs/pop_culture.dart';
import 'packs/retro.dart';

class WordPack {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Map<String, List<String>> localizedWords;
  final bool isLocked;
  final bool requiresPremium;

  const WordPack({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.localizedWords,
    this.isLocked = false,
    this.requiresPremium = false,
  });

  bool effectivelyLocked(GameSettings settings) {
    if (settings.isPremium) return false;
    if (requiresPremium) return true;
    if (settings.adSessionActive) return false;
    if (settings.unlockedPackIds.contains(id)) return false;
    return isLocked;
  }
}

// ─────────────────────────────────────────────
// TO ADD A NEW PACK:
// 1. Create lib/data/packs/your_pack.dart
// 2. Define its constants and word map there
// 3. Import it below and add one WordPack() entry to the list
// ─────────────────────────────────────────────

const List<WordPack> availableWordPacks = [
  WordPack(
    id: genericId,
    title: genericTitle,
    subtitle: genericSubtitle,
    icon: genericIcon,
    localizedWords: genericWords,
    isLocked: genericIsLocked,
    requiresPremium: genericRequiresPremium,
  ),
  WordPack(
    id: popCultureId,
    title: popCultureTitle,
    subtitle: popCultureSubtitle,
    icon: popCultureIcon,
    localizedWords: popCultureWords,
    isLocked: popCultureIsLocked,
    requiresPremium: popCultureRequiresPremium,
  ),
  WordPack(
    id: afterDarkId,
    title: afterDarkTitle,
    subtitle: afterDarkSubtitle,
    icon: afterDarkIcon,
    localizedWords: afterDarkWords,
    isLocked: afterDarkIsLocked,
    requiresPremium: afterDarkRequiresPremium,
  ),
  WordPack(
    id: retroId,
    title: retroTitle,
    subtitle: retroSubtitle,
    icon: retroIcon,
    localizedWords: retroWords,
    isLocked: retroIsLocked,
    requiresPremium: retroRequiresPremium,
  ),
  WordPack(
    id: 'custom',
    title: 'Custom Pack',
    subtitle: 'Create your own list of words.',
    icon: Icons.dashboard_customize_rounded,
    localizedWords: {'en': [], 'ro': []},
    isLocked: true,
    requiresPremium: true,
  ),
    
];

const Map<String, String> languageNames = {
  'ro': 'Română',
  'en': 'English',
};