// File: lib/screens/wordpack_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/word_bank.dart';

class WordpackSelectionScreen extends StatelessWidget {
  final String currentPackId;

  const WordpackSelectionScreen({super.key, required this.currentPackId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('CHOOSE WORDPACK', style: TextStyle(letterSpacing: 2)), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(24.0),
        itemCount: availableWordPacks.length,
        itemBuilder: (context, index) {
          final pack = availableWordPacks[index];
          final isSelected = pack.id == currentPackId;
          // We count the English words as the baseline length
          final wordCount = pack.localizedWords['en']?.length ?? 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context, pack.id);
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [theme.colorScheme.surface, const Color(0xFF1A1A1A)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 2) : Border.all(color: theme.colorScheme.primary.withAlpha(20), width: 1),
                  boxShadow: isSelected ? [BoxShadow(color: theme.colorScheme.primary.withAlpha(30), blurRadius: 20)] : [],
                ),
                child: Row(
                  children: [
                    Icon(pack.icon, size: 40, color: isSelected ? theme.colorScheme.primary : Colors.white54),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pack.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? theme.colorScheme.primary : Colors.white)),
                          const SizedBox(height: 4),
                          Text(pack.subtitle, style: const TextStyle(fontSize: 14, color: Colors.white54)),
                          const SizedBox(height: 8),
                          Text('$wordCount Words per language', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white30)),
                        ],
                      ),
                    ),
                    if (isSelected) Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 28),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}