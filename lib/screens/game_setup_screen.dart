// File: lib/screens/game_setup_screen.dart
import 'package:flutter/material.dart';
import '../models/game_settings.dart';
import '../data/word_bank.dart';
import 'team_setup_screen.dart'; 
import 'wordpack_selection_screen.dart'; 

class GameSetupScreen extends StatefulWidget {
  const GameSetupScreen({super.key});
  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  final GameSettings _settings = GameSettings();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Safety check to find the active pack
    final currentPack = availableWordPacks.firstWhere(
      (pack) => pack.id == _settings.selectedPackId,
      orElse: () => availableWordPacks.first,
    );
    
    final availableLanguages = currentPack.localizedWords.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('GAME SETTINGS', style: TextStyle(letterSpacing: 2)), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row for Pack and Language Selection
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InkWell(
                    onTap: () async {
                      final id = await Navigator.push<String>(
                        context, 
                        MaterialPageRoute(builder: (context) => WordpackSelectionScreen(currentPackId: _settings.selectedPackId))
                      );
                      if (id != null) {
                        setState(() {
                          _settings.selectedPackId = id;
                          final newPack = availableWordPacks.firstWhere((p) => p.id == id);
                          if (!newPack.localizedWords.containsKey(_settings.language)) {
                            _settings.language = newPack.localizedWords.keys.first;
                          }
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.primary.withAlpha(80)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('WORDPACK', style: TextStyle(fontSize: 10, color: Colors.white54)),
                          Text(currentPack.title, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('LANG', style: TextStyle(fontSize: 10, color: Colors.white54)),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _settings.language,
                            isExpanded: true,
                            dropdownColor: theme.colorScheme.surface,
                            items: availableLanguages.map((l) => DropdownMenuItem(
                              value: l, 
                              child: Text(languageNames[l] ?? l.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))
                            )).toList(),
                            onChanged: (v) => setState(() => _settings.language = v!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Settings Sliders
            Expanded(
              child: ListView(
                children: [
                  _sliderCard(
                    'TOTAL PLAYERS', 
                    '${_settings.totalPlayers}', 
                    _settings.totalPlayers.toDouble(), 4, 10, 3, 
                    (v) => setState(() => _settings.totalPlayers = v.toInt())
                  ),
                  _sliderCard(
                    'TARGET SCORE', 
                    '${_settings.targetScore} PTS', 
                    _settings.targetScore.toDouble(), 10, 100, 9, 
                    (v) => setState(() => _settings.targetScore = v.toInt())
                  ),
                  _sliderCard(
                    'ROUND TIME', 
                    '${_settings.roundDurationSeconds} SEC', 
                    _settings.roundDurationSeconds.toDouble(), 30, 120, 3, 
                    (v) => setState(() => _settings.roundDurationSeconds = v.toInt())
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamSetupScreen(settings: _settings))),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('NEXT: LOBBY', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderCard(String title, String display, double val, double min, double max, int div, Function(double) onCh) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.white38, letterSpacing: 1)),
          Text(display, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
          Slider(
            value: val, 
            min: min, 
            max: max, 
            divisions: div, 
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: onCh
          ),
        ],
      ),
    );
  }
}