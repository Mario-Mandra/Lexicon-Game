// File: lib/screens/game_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game_settings.dart';
import '../models/game_models.dart';
import '../data/word_bank.dart';

enum GamePhase { handoff, playing, leaderboard, victory }

class GameScreen extends StatefulWidget {
  final GameSettings settings;
  final List<Team> teams;

  const GameScreen({super.key, required this.settings, required this.teams});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GamePhase _phase = GamePhase.handoff;
  
  late List<Team> _playOrder;
  int _currentTeamIndex = 0;
  int _roundNumber = 0;

  Timer? _timer;
  int _timeLeft = 0;
  
  List<String> _currentWordDeck = [];
  String _currentWord = '';

  @override
  void initState() {
    super.initState();
    _playOrder = List.from(widget.teams)..shuffle();
    _loadWords();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadWords() {
    final selectedPack = availableWordPacks.firstWhere(
      (pack) => pack.id == widget.settings.selectedPackId,
      orElse: () => availableWordPacks.first,
    );
    List<String> wordsToLoad = selectedPack.localizedWords[widget.settings.language] ?? selectedPack.localizedWords['en']!;
    _currentWordDeck = List.from(wordsToLoad)..shuffle();
  }

  void _nextWord() {
    if (_currentWordDeck.isEmpty) _loadWords();
    setState(() {
      _currentWord = _currentWordDeck.removeLast();
    });
  }

  void _startTurn() {
    HapticFeedback.lightImpact();
    setState(() {
      _phase = GamePhase.playing;
      _timeLeft = widget.settings.roundDurationSeconds;
    });
    _nextWord();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
        if (_timeLeft <= 5) {
          HapticFeedback.heavyImpact();
        } else {
          HapticFeedback.selectionClick();
        }
      } else {
        _endTurn(); 
      }
    });
  }

  void _scoreWord(int points) {
    if (points > 0) {
      HapticFeedback.mediumImpact(); 
    } else {
      HapticFeedback.heavyImpact(); 
    }

    setState(() {
      _playOrder[_currentTeamIndex].score += points;
      
      // INSTANT VICTORY CHECK:
      // The moment a team hits or exceeds the target, we kill the timer and end the game.
      if (_playOrder[_currentTeamIndex].score >= widget.settings.targetScore) {
        _timer?.cancel();
        _phase = GamePhase.victory;
      }
    });

    if (_phase != GamePhase.victory) {
      _nextWord();
    }
  }

  void _endTurn() {
    _timer?.cancel();
    HapticFeedback.vibrate(); 
    
    setState(() {
      // If no one won during the active turn, just go to the leaderboard
      _phase = GamePhase.leaderboard;
    });
  }

  void _setupNextTurn() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentTeamIndex++;
      if (_currentTeamIndex >= _playOrder.length) {
        _currentTeamIndex = 0;
        _roundNumber++;
      }
      _phase = GamePhase.handoff;
    });
  }

  void _resetGameSamePlayers() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (var team in _playOrder) {
        team.score = 0;
      }
      _playOrder.shuffle();
      _currentTeamIndex = 0;
      _roundNumber = 0;
      _phase = GamePhase.handoff;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case GamePhase.handoff: return _buildHandoffScreen();
      case GamePhase.playing: return _buildPlayingScreen();
      case GamePhase.leaderboard: return _buildLeaderboardScreen();
      case GamePhase.victory: return _buildVictoryScreen(); 
    }
  }

  // --- UI COMPONENTS ---

  Widget _buildHandoffScreen() {
    final team = _playOrder[_currentTeamIndex];
    final explainer = team.players[_roundNumber % 2]!;
    final guesser = team.players[(_roundNumber + 1) % 2]!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _teamCard(team, explainer, guesser, theme),
            const SizedBox(height: 60),
            _actionButton("START ROUND", _startTurn, theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayingScreen() {
    final activeTeam = _playOrder[_currentTeamIndex];
    final theme = Theme.of(context);
    final bool isPanic = _timeLeft <= 10;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _gameHeader(activeTeam, isPanic, theme),
            const Spacer(),
            _wordCard(theme),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('<<< SKIP', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  Text('CORRECT >>>', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardScreen() {
    final sortedTeams = List<Team>.from(_playOrder)..sort((a, b) => b.score.compareTo(a.score));
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('SCOREBOARD', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 4, color: theme.colorScheme.primary)),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: sortedTeams.length,
                itemBuilder: (context, index) {
                  final team = sortedTeams[index];
                  return _leaderboardTile(team, index == 0, theme);
                },
              ),
            ),
            const SizedBox(height: 20),
            _actionButton("NEXT TEAM", _setupNextTurn, theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildVictoryScreen() {
    final winner = (List<Team>.from(_playOrder)..sort((a, b) => b.score.compareTo(a.score))).first;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.emoji_events_rounded, size: 120, color: Colors.amber),
            const SizedBox(height: 20),
            const Text('CHAMPIONS', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, letterSpacing: 8, color: Colors.white38)),
            Text(winner.name.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white)),
            const SizedBox(height: 60),
            _actionButton("PLAY AGAIN", _resetGameSamePlayers, theme.colorScheme.primary),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('EXIT TO MAIN MENU', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE COMPONENTS ---

  Widget _actionButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
      ),
      child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
    );
  }

  Widget _teamCard(Team team, Player e, Player g, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(80), width: 2),
      ),
      child: Column(
        children: [
          Text(team.name.toUpperCase(), style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w900, letterSpacing: 4)),
          const Divider(height: 40, color: Colors.white10),
          const Text('DESCRIBING', style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2)),
          Text(e.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          const Text('GUESSING', style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2)),
          Text(g.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _gameHeader(Team team, bool panic, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${team.name}: ${team.score}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 20)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(color: panic ? Colors.red.withAlpha(40) : Colors.white10, borderRadius: BorderRadius.circular(20)),
            child: Text('$_timeLeft', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: panic ? Colors.red : Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _wordCard(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Dismissible(
        key: ValueKey(_currentWord),
        onDismissed: (dir) {
          _scoreWord(dir == DismissDirection.startToEnd ? 1 : -1);
        },
        background: _swipeBg(Colors.green, Icons.check, Alignment.centerLeft),
        secondaryBackground: _swipeBg(Colors.red, Icons.close, Alignment.centerRight),
        child: Container(
          height: 300, width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A), 
            borderRadius: BorderRadius.circular(32), 
            border: Border.all(color: theme.colorScheme.primary.withAlpha(100), width: 2)
          ),
          child: Center(child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: FittedBox(child: Text(_currentWord, style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: Colors.white))),
          )),
        ),
      ),
    );
  }

  Widget _swipeBg(Color c, IconData i, Alignment a) => Container(
    alignment: a, padding: const EdgeInsets.symmetric(horizontal: 40),
    decoration: BoxDecoration(color: c.withAlpha(40), borderRadius: BorderRadius.circular(32)),
    child: Icon(i, color: c, size: 60),
  );

  Widget _leaderboardTile(Team t, bool first, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: first ? theme.colorScheme.primary.withAlpha(20) : Colors.white.withAlpha(5), 
        borderRadius: BorderRadius.circular(16), 
        border: first ? Border.all(color: theme.colorScheme.primary) : null
      ),
      child: Row(children: [Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), const Spacer(), Text('${t.score}', style: TextStyle(fontWeight: FontWeight.w900, color: first ? theme.colorScheme.primary : Colors.white))]),
    );
  }
}