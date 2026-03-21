// File: lib/screens/team_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // REQUIRED FOR HAPTICS
import '../models/game_settings.dart';
import '../models/game_models.dart';
import 'game_screen.dart';

class TeamSetupScreen extends StatefulWidget {
  final GameSettings settings;

  const TeamSetupScreen({super.key, required this.settings});

  @override
  State<TeamSetupScreen> createState() => _TeamSetupScreenState();
}

class _TeamSetupScreenState extends State<TeamSetupScreen> {
  late List<Team> _teams;

  @override
  void initState() {
    super.initState();
    int numberOfTeams = widget.settings.totalPlayers ~/ 2;
    _teams = List.generate(numberOfTeams, (index) => Team(name: 'Team ${index + 1}', capacity: 2));
  }

  // --- NEW FEATURE: Edit Team Name Dialog ---
  Future<void> _openTeamNameDialog(int teamIndex) async {
    HapticFeedback.lightImpact(); 
    String tempName = _teams[teamIndex].name; // Pre-fill with the current name
    final TextEditingController controller = TextEditingController(text: tempName);
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Theme.of(context).colorScheme.primary.withAlpha(50))),
          title: const Text('Edit Team Name', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller, // This puts the current text in the box
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. The Brainiacs',
              hintStyle: const TextStyle(color: Colors.white30),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
            onChanged: (value) => tempName = value,
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Text('SAVE', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (tempName.trim().isNotEmpty) {
      setState(() {
        _teams[teamIndex].name = tempName.trim();
      });
    }
  }

  // Edit Player Name Dialog
  Future<void> _openNameDialog(int teamIndex, int slotIndex) async {
    HapticFeedback.lightImpact(); 
    String tempName = '';
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Theme.of(context).colorScheme.primary.withAlpha(50))),
          title: const Text('Enter Player Name', style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'e.g. Alex',
              hintStyle: const TextStyle(color: Colors.white30),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
            onChanged: (value) => tempName = value,
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
              child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: Text('JOIN', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (tempName.trim().isNotEmpty) {
      setState(() {
        _teams[teamIndex].players[slotIndex] = Player(name: tempName.trim());
      });
    }
  }

  bool _isLobbyFull() {
    for (var team in _teams) {
      if (!team.isFull) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canStart = _isLobbyFull();

    return Scaffold(
      appBar: AppBar(title: const Text('LOBBY', style: TextStyle(letterSpacing: 2)), centerTitle: true),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Tap an empty slot to join a team!', style: TextStyle(fontSize: 14, color: Colors.white70, letterSpacing: 1)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _teams.length,
              itemBuilder: (context, teamIndex) {
                final team = _teams[teamIndex];
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [theme.colorScheme.surface, const Color(0xFF1A1A1A)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
                    boxShadow: [BoxShadow(color: theme.colorScheme.primary.withAlpha(10), blurRadius: 20)],
                  ),
                  child: Column(
                    children: [
                      // --- UPDATED: Clickable Team Name Header ---
                      InkWell(
                        onTap: () => _openTeamNameDialog(teamIndex),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(40),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                team.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2, color: theme.colorScheme.primary),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.edit, size: 16, color: theme.colorScheme.primary.withAlpha(200)), // Little edit pencil
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: List.generate(2, (slotIndex) {
                            final player = team.players[slotIndex];
                            final isEmpty = player == null;

                            return GestureDetector(
                              onTap: () => _openNameDialog(teamIndex, slotIndex),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isEmpty ? Colors.transparent : theme.colorScheme.primary.withAlpha(20),
                                  border: Border.all(
                                    color: isEmpty ? Colors.white24 : theme.colorScheme.primary.withAlpha(150),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isEmpty ? Icons.person_add_alt_1 : Icons.person,
                                      color: isEmpty ? Colors.white54 : theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      isEmpty ? 'Empty Slot - Tap to Join' : player.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isEmpty ? Colors.white54 : Colors.white,
                                        fontWeight: isEmpty ? FontWeight.normal : FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              onPressed: canStart ? () {
                HapticFeedback.mediumImpact(); 
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(settings: widget.settings, teams: _teams)),
                );
              } : null, 
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: Colors.grey.shade900,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: canStart ? 10 : 0,
                shadowColor: theme.colorScheme.primary.withAlpha(127),
              ),
              child: Text(
                canStart ? 'START GAME' : 'WAITING FOR PLAYERS...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1, color: canStart ? Colors.white : Colors.white30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}