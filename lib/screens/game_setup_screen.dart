// File: lib/screens/game_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_settings.dart';
import '../data/word_bank.dart';
import 'team_setup_screen.dart'; 
import 'wordpack_selection_screen.dart'; 

class GameSetupScreen extends StatefulWidget {
  final GameSettings settings;

  const GameSetupScreen({super.key, required this.settings});
  
  @override
  State<GameSetupScreen> createState() => _GameSetupScreenState();
}

class _GameSetupScreenState extends State<GameSetupScreen> {
  bool _isProcessing = false;

  Future<void> _processAd() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad failed to load. Please try again later.', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent,
        )
      );
    }
  }

  Future<void> _processPurchase() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchase failed: Service unavailable.', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.redAccent,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final currentPack = availableWordPacks.firstWhere(
      (pack) => pack.id == widget.settings.selectedPackId,
      orElse: () => availableWordPacks.first,
    );
    
    final availableLanguages = currentPack.localizedWords.keys.toList();
    final bool isLocked = currentPack.effectivelyLocked(widget.settings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('GAME SETTINGS', style: TextStyle(letterSpacing: 2)), 
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPackLangSelectors(context, theme, currentPack, availableLanguages, isLocked),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      _sliderCard('TOTAL PLAYERS', '${widget.settings.totalPlayers}', widget.settings.totalPlayers.toDouble(), 4, 10, 3, (v) => setState(() => widget.settings.totalPlayers = v.toInt())),
                      _sliderCard('TARGET SCORE', '${widget.settings.targetScore} PTS', widget.settings.targetScore.toDouble(), 10, 100, 9, (v) => setState(() => widget.settings.targetScore = v.toInt())),
                      _sliderCard('ROUND TIME', '${widget.settings.roundDurationSeconds} SEC', widget.settings.roundDurationSeconds.toDouble(), 30, 120, 3, (v) => setState(() => widget.settings.roundDurationSeconds = v.toInt())),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // FOOTER
                if (!isLocked)
                  _lobbyButton(theme)
                else
                  _transactionButtons(theme, currentPack.id),
              ],
            ),
          ),
          if (_isProcessing)
            Container(color: Colors.black.withAlpha(200), child: const Center(child: CircularProgressIndicator(color: Color(0xFFFF00FF)))),
        ],
      ),
    );
  }

  Widget _buildPackLangSelectors(BuildContext context, ThemeData theme, WordPack currentPack, List<String> availableLanguages, bool isLocked) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () async {
              final id = await Navigator.push<String>(context, MaterialPageRoute(builder: (context) => WordpackSelectionScreen(currentPackId: widget.settings.selectedPackId, settings: widget.settings)));
              if (id != null) {
                setState(() {
                  widget.settings.selectedPackId = id;
                  final newPack = availableWordPacks.firstWhere((p) => p.id == id);
                  if (!newPack.localizedWords.containsKey(widget.settings.language)) {
                    widget.settings.language = newPack.localizedWords.keys.first;
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
                border: Border.all(color: isLocked ? Colors.amber.withAlpha(100) : theme.colorScheme.primary.withAlpha(80), width: isLocked ? 2 : 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [const Text('WORDPACK', style: TextStyle(fontSize: 10, color: Colors.white54)), if (isLocked) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.lock, size: 10, color: Colors.amber))]),
                  Text(currentPack.title, style: TextStyle(color: isLocked ? Colors.amber : theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
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
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LANG', style: TextStyle(fontSize: 10, color: Colors.white54)),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.settings.language, isExpanded: true, dropdownColor: theme.colorScheme.surface,
                    items: availableLanguages.map((l) => DropdownMenuItem(value: l, child: Text(languageNames[l] ?? l.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
                    onChanged: (v) => setState(() => widget.settings.language = v!),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _lobbyButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamSetupScreen(settings: widget.settings))),
      style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: const Text('NEXT: LOBBY', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
    );
  }

  Widget _transactionButtons(ThemeData theme, String packId) {
    // If it's the custom pack, it shouldn't show these anyway based on word_bank logic, 
    // but we can add an extra safety check here.
    final bool isCustom = packId == 'custom';

    if (isCustom) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(color: Colors.amber.withAlpha(20), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.withAlpha(50))),
        child: const Center(child: Text("PREMIUM ONLY", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2))),
      );
    }

    return Row(
      children: [
        Expanded(child: _footerAction("WATCH AD", Icons.play_circle_outline, Colors.white10, _processAd)),
        const SizedBox(width: 12),
        Expanded(child: _footerAction("BUY \$0.99", Icons.shopping_bag_outlined, theme.colorScheme.primary.withAlpha(40), _processPurchase)),
      ],
    );
  }

  Widget _footerAction(String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap, icon: Icon(icon, size: 18), label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
    );
  }

  Widget _sliderCard(String title, String display, double val, double min, double max, int div, Function(double) onCh) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(20)),
      child: Column(children: [Text(title, style: const TextStyle(fontSize: 12, color: Colors.white38, letterSpacing: 1)), Text(display, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)), Slider(value: val, min: min, max: max, divisions: div, activeColor: Theme.of(context).colorScheme.primary, onChanged: onCh)]),
    );
  }
}