// File: lib/screens/wordpack_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/word_bank.dart';
import '../models/game_settings.dart'; 
import 'custom_pack_editor_screen.dart';

class WordpackSelectionScreen extends StatefulWidget {
  final String currentPackId;
  final GameSettings settings;

  const WordpackSelectionScreen({
    super.key,
    required this.currentPackId,
    required this.settings,
  });

  @override
  State<WordpackSelectionScreen> createState() => _WordpackSelectionScreenState();
}

class _WordpackSelectionScreenState extends State<WordpackSelectionScreen> {
  bool _isProcessingTransaction = false;

  // --- PRODUCTION STUBS (WILL FAIL WITHOUT SDK) ---
  
  Future<void> _processAdReward() async {
    setState(() => _isProcessingTransaction = true);
    try {
      await Future.delayed(const Duration(seconds: 2)); 
      throw Exception("SDK Not Linked"); 
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessingTransaction = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ad service unavailable.'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _processPurchase(String packId, String packTitle) async {
    setState(() => _isProcessingTransaction = true);
    try {
      await Future.delayed(const Duration(seconds: 2)); 
      throw Exception("Billing Not Linked");
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessingTransaction = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Store unavailable.'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // CRITICAL FIX: We calculate availability DYNAMICALLY based on effectivelyLocked.
    // This ensures that if adSessionActive is true, effectivelyLocked returns false,
    // and the pack moves to the 'availablePacks' list.
    final availablePacks = availableWordPacks.where((p) => !p.effectivelyLocked(widget.settings)).toList();
    final lockedPacks = availableWordPacks.where((p) => p.effectivelyLocked(widget.settings)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('CHOOSE WORDPACK', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              if (availablePacks.isNotEmpty) ...[
                _sectionHeader("AVAILABLE"),
                ...availablePacks.map((pack) => _buildPackTile(context, pack, theme, false)),
              ],
              if (lockedPacks.isNotEmpty) ...[
                const SizedBox(height: 32),
                _sectionHeader("LOCKED"),
                ...lockedPacks.map((pack) => _buildPackTile(context, pack, theme, true)),
              ],
            ],
          ),
          if (_isProcessingTransaction)
            Container(
              color: Colors.black.withAlpha(220),
              child: const Center(child: CircularProgressIndicator(color: Color(0xFFFF00FF))),
            ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 12),
      ),
    );
  }

  Widget _buildPackTile(BuildContext context, WordPack pack, ThemeData theme, bool isLocked) {
    final isSelected = pack.id == widget.currentPackId;
    final isCustom = pack.id == 'custom';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary.withAlpha(20) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.primary.withAlpha(20),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (isLocked) {
            HapticFeedback.vibrate();
            return;
          }
          HapticFeedback.mediumImpact();
          Navigator.pop(context, pack.id);
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    isLocked ? Icons.lock_outline_rounded : pack.icon,
                    size: 32,
                    color: isSelected ? theme.colorScheme.primary : Colors.white54,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pack.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? theme.colorScheme.primary : Colors.white,
                          ),
                        ),
                        Text(pack.subtitle, style: const TextStyle(fontSize: 13, color: Colors.white54)),
                      ],
                    ),
                  ),
                  if (isSelected && !isLocked)
                    Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 24),
                ],
              ),
              
              if (isLocked) ...[
                const SizedBox(height: 16),
                if (pack.requiresPremium)
                  _premiumBadge()
                else
                  Row(
                    children: [
                      Expanded(child: _actionBtn("WATCH AD", Icons.play_circle_outline, Colors.white10, _processAdReward)),
                      const SizedBox(width: 8),
                      Expanded(child: _actionBtn("BUY \$0.99", Icons.shopping_bag_outlined, theme.colorScheme.primary.withAlpha(40), () => _processPurchase(pack.id, pack.title))),
                    ],
                  ),
              ] else if (isCustom && widget.settings.isPremium) ...[
                const SizedBox(height: 12),
                _editButton(context, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _premiumBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withAlpha(100)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.workspace_premium, size: 16, color: Colors.amber),
          SizedBox(width: 8),
          Text("PREMIUM ONLY", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomPackEditorScreen())),
        icon: const Icon(Icons.edit, size: 18),
        label: const Text('EDIT WORDS'),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.primary.withAlpha(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}