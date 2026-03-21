// File: lib/screens/rules_screen.dart

import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOW TO PLAY', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: const [
          RuleCard(
            step: '1',
            title: 'THE SETUP',
            description: 'Split into teams of two. The game is played on a single device—just pass the phone when told!',
          ),
          SizedBox(height: 16),
          // --- NEW RULE EXPLAINING YOUR MODULAR DATA ---
          RuleCard(
            step: '2',
            title: 'THE DECK',
            description: 'The Host chooses a Wordpack and selects a Language from the dropdown. The app will automatically adapt the deck for your match.',
          ),
          SizedBox(height: 16),
          RuleCard(
            step: '3',
            title: 'THE GOAL',
            description: 'When it is your turn, explain the word on the screen to your team WITHOUT saying the word itself, parts of it, or rhyming words.',
          ),
          SizedBox(height: 16),
          RuleCard(
            step: '4',
            title: 'SCORING',
            description: 'Swipe Right for Correct = +1 point.\nSwipe Left for Skip = -1 point.\nWork fast before the timer runs out!',
          ),
          SizedBox(height: 16),
          RuleCard(
            step: '5',
            title: 'WINNING',
            description: 'The first team to reach the target score wins. Simple as that. Good luck!',
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.surface, const Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(40), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: theme.colorScheme.primary.withAlpha(50), blurRadius: 10, spreadRadius: 1)
              ]
            ),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              radius: 18,
              child: Text(step, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
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
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: 1,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14, 
                    color: Colors.white70, 
                    height: 1.6, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}