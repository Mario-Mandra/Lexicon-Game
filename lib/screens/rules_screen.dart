// File: lib/screens/rules_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/game_settings.dart';

class RulesScreen extends StatefulWidget {
  final GameSettings settings;
  final VoidCallback onUpdate;

  const RulesScreen({super.key, required this.settings, required this.onUpdate});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  void _showCheatDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'ENTER CODE',
          style: TextStyle(color: Colors.white, letterSpacing: 2),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF00FF)),
            ),
            hintText: 'Enter 5-digit code',
            hintStyle: TextStyle(color: Colors.white24),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final code = controller.text.trim();
              String message = 'Invalid Code';

              if (code == '10001') {
                widget.settings.adSessionActive = true;
                message = 'DEBUG: Ad Session Activated.';
              } else if (code == '10002') {
                widget.settings.unlockedPackIds = ['pop_culture', 'after_dark'];
                message = 'DEBUG: All Packs Purchased.';
              } else if (code == '10003') {
                widget.settings.isPremium = true;
                message = 'DEBUG: Premium Membership Granted.';
              } else if (code == '10004') {
                widget.settings.resetAccess();
                message = 'DEBUG: All Access Revoked.';
              }

              widget.onUpdate();
              HapticFeedback.heavyImpact();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: const Color(0xFFFF00FF),
                ),
              );
            },
            child: const Text(
              'EXECUTE',
              style: TextStyle(
                color: Color(0xFFFF00FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOW TO PLAY', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report_outlined, color: Colors.white10),
            onPressed: () => _showCheatDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: const [
          RuleCard(
            step: '1',
            title: 'THE SETUP',
            description:
                'Split into teams of two. The game is played on a single device, so you will just pass the phone to the next team when it is their turn!',
          ),
          RuleCard(
            step: '2',
            title: 'THE DECK',
            description:
                'Choose a Wordpack. The Generic pack is always free. Special themed packs can be unlocked via Ads, a one-time Purchase, or a Premium membership.',
          ),
          RuleCard(
            step: '3',
            title: 'THE GOAL',
            description:
                'When it is your turn, you must explain the word on the screen to your teammate WITHOUT saying the word itself, parts of the word, or "rhymes with".',
          ),
          RuleCard(
            step: '4',
            title: 'SCORING',
            description:
                'Swipe the card Right if your teammate guesses correctly (+1 point). Swipe Left to skip if the word is too hard (-1 point). Move as fast as you can!',
          ),
          RuleCard(
            step: '5',
            title: 'WINNING',
            description:
                'The first team to reach the target score wins the game. Simple as that. Good luck!',
          ),
        ],
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;

  const RuleCard({
    super.key,
    required this.step,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              step,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}