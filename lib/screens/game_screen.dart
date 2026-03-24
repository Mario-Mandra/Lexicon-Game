// File: lib/screens/game_screen.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  GamePhase _phase = GamePhase.handoff;
  bool _isWordsLoading = true;
  bool _isProcessingTransaction = false;

  late List<Team> _playOrder;
  int _currentTeamIndex = 0;
  int _roundNumber = 0;

  Timer? _timer;
  int _timeLeft = 0;

  List<String> _currentWordDeck = [];
  String _currentWord = '';

  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;
  final String _rewardedAdUnitId = 'ca-app-pub-3836287958039986/4233855759';

  // --- Swipe state ---
  double _dragOffset = 0;
  double _dragStartX = 0;
  bool _isAnimatingOut = false;

  late AnimationController _cardFlyController;
  late Animation<Offset> _cardFlyAnimation;

  // --- Handoff pulse ---
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // --- Victory animations ---
  late AnimationController _victoryController;
  late Animation<double> _trophyBounce;
  late Animation<double> _nameScale;
  late Animation<double> _confettiProgress;

  @override
  void initState() {
    super.initState();
    _playOrder = List.from(widget.teams)..shuffle();
    _initGameData();
    _loadRewardedAd();

    _cardFlyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _victoryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _trophyBounce = CurvedAnimation(
      parent: _victoryController,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    );

    _nameScale = CurvedAnimation(
      parent: _victoryController,
      curve: const Interval(0.3, 0.7, curve: Curves.elasticOut),
    );

    _confettiProgress = CurvedAnimation(
      parent: _victoryController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rewardedAd?.dispose();
    _cardFlyController.dispose();
    _pulseController.dispose();
    _victoryController.dispose();
    widget.settings.adSessionActive = false;
    super.dispose();
  }

  // --- Ad loading ---

  void _loadRewardedAd() {
    if (_isAdLoading) return;
    _isAdLoading = true;

    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _isAdLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              _rewardedAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadRewardedAd();
              if (mounted) setState(() => _isProcessingTransaction = false);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadRewardedAd();
              if (mounted) setState(() => _isProcessingTransaction = false);
            },
          );
          if (mounted) setState(() => _rewardedAd = ad);
        },
        onAdFailedToLoad: (err) {
          _isAdLoading = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  // --- Word loading ---

  Future<void> _initGameData() async {
    await _loadWords();
    if (mounted) setState(() => _isWordsLoading = false);
  }

  Future<void> _loadWords() async {
    if (widget.settings.selectedPackId == 'custom') {
      final prefs = await SharedPreferences.getInstance();
      final savedWords = prefs.getStringList('custom_pack_words') ?? [];
      _currentWordDeck = savedWords.isEmpty
          ? ['Add words in settings!', 'Custom pack empty']
          : (List.from(savedWords)..shuffle());
    } else {
      final selectedPack = availableWordPacks.firstWhere(
        (pack) => pack.id == widget.settings.selectedPackId,
        orElse: () => availableWordPacks.first,
      );
      final wordsToLoad =
          selectedPack.localizedWords[widget.settings.language] ??
              selectedPack.localizedWords['en'] ??
              [];
      _currentWordDeck = List.from(wordsToLoad)..shuffle();
    }

    if (_currentWord.isEmpty && _currentWordDeck.isNotEmpty) {
      _nextWord();
    }
  }

  void _nextWord() {
    if (_currentWordDeck.isEmpty) {
      _loadWords().then((_) {
        if (mounted && _currentWordDeck.isNotEmpty) {
          setState(() => _currentWord = _currentWordDeck.removeLast());
        }
      });
    } else {
      setState(() => _currentWord = _currentWordDeck.removeLast());
    }
  }

  // --- Game flow ---

  void _startTurn() {
    HapticFeedback.lightImpact();
    _cardFlyController.reset();
    setState(() {
      _phase = GamePhase.playing;
      _timeLeft = widget.settings.roundDurationSeconds;
      _dragOffset = 0;
      _isAnimatingOut = false;
    });
    _nextWord();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
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

    final newScore = _playOrder[_currentTeamIndex].score + points;
    _playOrder[_currentTeamIndex].score = newScore;

    final bool won = newScore >= widget.settings.targetScore;

    if (won) {
      _timer?.cancel();
      _cardFlyController.reset();
      widget.settings.adSessionActive = false;
      setState(() {
        _isAnimatingOut = false;
        _dragOffset = 0;
        _phase = GamePhase.victory;
      });
      _victoryController.forward();
    } else {
      setState(() {
        _isAnimatingOut = false;
        _dragOffset = 0;
      });
      _cardFlyController.reset();
      _nextWord();
    }
  }

  void _endTurn() {
    _timer?.cancel();
    _cardFlyController.reset();
    HapticFeedback.vibrate();
    setState(() {
      _isAnimatingOut = false;
      _dragOffset = 0;
      _phase = GamePhase.leaderboard;
    });
  }

  void _setupNextTurn() {
    HapticFeedback.lightImpact();
    _cardFlyController.reset();
    setState(() {
      _currentTeamIndex++;
      if (_currentTeamIndex >= _playOrder.length) {
        _currentTeamIndex = 0;
        _roundNumber++;
      }
      _phase = GamePhase.handoff;
      _dragOffset = 0;
      _isAnimatingOut = false;
    });
  }

  void _resetGameSamePlayers() {
    HapticFeedback.mediumImpact();
    _cardFlyController.reset();
    _victoryController.reset();
    setState(() {
      for (var team in _playOrder) {
        team.score = 0;
      }
      _playOrder.shuffle();
      _currentTeamIndex = 0;
      _roundNumber = 0;
      _phase = GamePhase.handoff;
      _dragOffset = 0;
      _isAnimatingOut = false;
    });
  }

  // --- Swipe handlers ---

  void _onDragStart(DragStartDetails details) {
    if (_isAnimatingOut) return;
    setState(() => _dragStartX = details.globalPosition.dx);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_isAnimatingOut) return;
    setState(() {
      _dragOffset = details.globalPosition.dx - _dragStartX;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isAnimatingOut) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.35;

    if (_dragOffset.abs() > threshold) {
      _animateCardOut(_dragOffset > 0 ? 1 : -1);
    } else {
      setState(() => _dragOffset = 0);
    }
  }

  void _animateCardOut(int direction) {
    if (_isAnimatingOut) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final startOffset = Offset(_dragOffset, _dragOffset.abs() * 0.1);
    final endOffset = Offset(direction * screenWidth * 1.6, 120.0);

    setState(() => _isAnimatingOut = true);

    _cardFlyAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(
      CurvedAnimation(parent: _cardFlyController, curve: Curves.easeIn),
    );

    _cardFlyController.forward(from: 0).then((_) {
      if (mounted) {
        _scoreWord(direction > 0 ? 1 : -1);
      }
    });
  }

  // --- Ad / Purchase ---

  void _processAdRewardReplay() {
    if (_rewardedAd == null) {
      if (!_isAdLoading) _loadRewardedAd();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Fetching ad from server. Please wait a moment and tap again.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.amber,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isProcessingTransaction = true);

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (mounted) {
          setState(() => widget.settings.adSessionActive = true);
          _resetGameSamePlayers();
        }
      },
    );
  }

  Future<void> _processPurchaseReplay(String packId) async {
    setState(() => _isProcessingTransaction = true);
    try {
      final products = await Purchases.getProducts([packId]);
      if (products.isEmpty) throw Exception('Product not found.');

      final info = await Purchases.purchaseStoreProduct(products.first);
      
      // Capture the immediate result, clear any dev locks, and update UI
      widget.settings.clearDebugRevoke();
      widget.settings.updateAccessFromInfo(info);

      if (mounted) {
        setState(() => _isProcessingTransaction = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Purchase successful!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (mounted) {
        setState(() => _isProcessingTransaction = false);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Store unavailable right now.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessingTransaction = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Store unavailable.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    if (_isWordsLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);

    return Stack(
      children: [
        _buildMainContent(),
        if (_isProcessingTransaction)
          Container(
            color: Colors.black.withAlpha(200),
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.primary.withAlpha(80),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(20),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'CONNECTING',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Securely contacting servers...',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMainContent() {
    switch (_phase) {
      case GamePhase.handoff:
        return _buildHandoffScreen();
      case GamePhase.playing:
        return _buildPlayingScreen();
      case GamePhase.leaderboard:
        return _buildLeaderboardScreen();
      case GamePhase.victory:
        return _buildVictoryScreen();
    }
  }

  // --- Handoff screen ---

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
            ScaleTransition(
              scale: _pulseAnimation,
              child: _actionButton(
                'START ROUND',
                _startTurn,
                theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Playing screen ---

  Widget _buildPlayingScreen() {
    final activeTeam = _playOrder[_currentTeamIndex];
    final theme = Theme.of(context);
    final bool isPanic = _timeLeft <= 10;
    final screenWidth = MediaQuery.of(context).size.width;

    final rotationAngle = (_dragOffset / screenWidth) * 0.26;
    final dragRatio = (_dragOffset / (screenWidth * 0.4)).clamp(-1.0, 1.0);
    final greenAlpha = dragRatio > 0 ? (dragRatio * 180).toInt() : 0;
    final redAlpha = dragRatio < 0 ? (dragRatio.abs() * 180).toInt() : 0;

    Widget card = Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.lerp(
          const Color(0xFF1A1A1A),
          dragRatio > 0
              ? Colors.green.withAlpha(greenAlpha)
              : Colors.red.withAlpha(redAlpha),
          dragRatio.abs(),
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: dragRatio > 0
              ? Colors.green.withAlpha(greenAlpha + 50)
              : dragRatio < 0
                  ? Colors.red.withAlpha(redAlpha + 50)
                  : theme.colorScheme.primary.withAlpha(100),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: dragRatio > 0
                ? Colors.green.withAlpha(40)
                : dragRatio < 0
                    ? Colors.red.withAlpha(40)
                    : theme.colorScheme.primary.withAlpha(20),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FittedBox(
                child: Text(
                  _currentWord,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          if (dragRatio > 0.15)
            Positioned(
              top: 24,
              left: 24,
              child: Opacity(
                opacity: ((dragRatio - 0.15) / 0.85).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: -0.3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'CORRECT',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (dragRatio < -0.15)
            Positioned(
              top: 24,
              right: 24,
              child: Opacity(
                opacity: ((-dragRatio - 0.15) / 0.85).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: 0.3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (_isAnimatingOut) {
      card = AnimatedBuilder(
        animation: _cardFlyController,
        builder: (context, child) {
          final offset = _cardFlyAnimation.value;
          final flyRotation =
              (offset.dx / (screenWidth * 1.5)) * 0.5;
          return Transform.translate(
            offset: offset,
            child: Transform.rotate(angle: flyRotation, child: child),
          );
        },
        child: card,
      );
    } else {
      card = Transform.translate(
        offset: Offset(_dragOffset, _dragOffset.abs() * 0.1),
        child: Transform.rotate(angle: rotationAngle, child: card),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _gameHeader(activeTeam, isPanic, theme),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GestureDetector(
                onHorizontalDragStart: _onDragStart,
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: card,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedOpacity(
                  opacity: dragRatio < 0 ? 1.0 : 0.3,
                  duration: const Duration(milliseconds: 150),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back,
                          color: Colors.redAccent, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: dragRatio > 0 ? 1.0 : 0.3,
                  duration: const Duration(milliseconds: 150),
                  child: const Row(
                    children: [
                      Text(
                        'CORRECT',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward,
                          color: Colors.greenAccent, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // --- Leaderboard screen ---

  Widget _buildLeaderboardScreen() {
    final sortedTeams = List<Team>.from(_playOrder)
      ..sort((a, b) => b.score.compareTo(a.score));
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'SCOREBOARD',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: sortedTeams.length,
                itemBuilder: (context, index) {
                  return _AnimatedLeaderboardTile(
                    team: sortedTeams[index],
                    isFirst: index == 0,
                    rank: index + 1,
                    delay: Duration(milliseconds: index * 150),
                    theme: theme,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _actionButton(
              'NEXT TEAM',
              _setupNextTurn,
              theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  // --- Victory screen ---

  Widget _buildVictoryScreen() {
    final winner = (List<Team>.from(_playOrder)
          ..sort((a, b) => b.score.compareTo(a.score)))
        .first;
    final theme = Theme.of(context);
    final currentPack = availableWordPacks.firstWhere(
      (p) => p.id == widget.settings.selectedPackId,
    );
    final bool hasAccess = !currentPack.effectivelyLocked(widget.settings);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _confettiProgress,
            builder: (context, _) => CustomPaint(
              painter: _ConfettiPainter(
                progress: _confettiProgress.value,
                primaryColor: theme.colorScheme.primary,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedBuilder(
                  animation: _trophyBounce,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -40 * _trophyBounce.value + 40),
                    child: Opacity(
                      opacity: _trophyBounce.value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    size: 100,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'CHAMPIONS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 8,
                    color: Colors.white38,
                  ),
                ),
                AnimatedBuilder(
                  animation: _nameScale,
                  builder: (context, child) => Transform.scale(
                    scale: _nameScale.value,
                    child: Opacity(
                      opacity: _nameScale.value.clamp(0.0, 1.0),
                      child: child,
                    ),
                  ),
                  child: Text(
                    winner.name.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                if (hasAccess) ...[
                  _actionButton(
                    'PLAY AGAIN',
                    _resetGameSamePlayers,
                    theme.colorScheme.primary,
                  ),
                ] else ...[
                  const Text(
                    'SESSION EXPIRED',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _actionButton(
                    'WATCH AD TO REPLAY',
                    _processAdRewardReplay,
                    Colors.white10,
                  ),
                  const SizedBox(height: 12),
                  _actionButton(
                    'BUY PACK \$0.99',
                    () => _processPurchaseReplay(currentPack.id),
                    theme.colorScheme.primary.withAlpha(40),
                  ),
                ],
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text(
                    'EXIT TO MAIN MENU',
                    style: TextStyle(
                      color: Colors.white38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Shared widgets ---

  Widget _actionButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _teamCard(Team team, Player e, Player g, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha(80),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            team.name.toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const Divider(height: 40, color: Colors.white10),
          const Text(
            'DESCRIBING',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          Text(
            e.name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'GUESSING',
            style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          Text(
            g.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
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
          Text(
            '${team.name}: ${team.score}',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: panic ? Colors.red.withAlpha(40) : Colors.white10,
              borderRadius: BorderRadius.circular(20),
              border:
                  panic ? Border.all(color: Colors.red.withAlpha(150)) : null,
            ),
            child: Text(
              '$_timeLeft',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: panic ? Colors.red : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Animated leaderboard tile ---

class _AnimatedLeaderboardTile extends StatefulWidget {
  final Team team;
  final bool isFirst;
  final int rank;
  final Duration delay;
  final ThemeData theme;

  const _AnimatedLeaderboardTile({
    required this.team,
    required this.isFirst,
    required this.rank,
    required this.delay,
    required this.theme,
  });

  @override
  State<_AnimatedLeaderboardTile> createState() =>
      _AnimatedLeaderboardTileState();
}

class _AnimatedLeaderboardTileState extends State<_AnimatedLeaderboardTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideIn;
  late Animation<int> _scoreCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );

    _scoreCount = IntTween(begin: 0, end: widget.team.score).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(60 * (1 - _slideIn.value), 0),
          child: Opacity(
            opacity: _slideIn.value.clamp(0.0, 1.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isFirst
                    ? widget.theme.colorScheme.primary.withAlpha(20)
                    : Colors.white.withAlpha(5),
                borderRadius: BorderRadius.circular(16),
                border: widget.isFirst
                    ? Border.all(color: widget.theme.colorScheme.primary)
                    : Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.isFirst
                          ? Colors.amber.withAlpha(40)
                          : Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#${widget.rank}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: widget.isFirst
                              ? Colors.amber
                              : Colors.white54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.team.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_scoreCount.value}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: widget.isFirst
                          ? widget.theme.colorScheme.primary
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Confetti painter ---

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Random _random = Random(42);

  _ConfettiPainter({required this.progress, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    const particleCount = 60;
    final colors = [
      primaryColor,
      Colors.amber,
      Colors.white,
      Colors.cyanAccent,
      Colors.pinkAccent,
    ];

    for (int i = 0; i < particleCount; i++) {
      final startX = _random.nextDouble() * size.width;
      final speedX = (_random.nextDouble() - 0.5) * 200;
      final speedY = _random.nextDouble() * size.height * 1.2 + 200;
      final rotation = _random.nextDouble() * pi * 4;
      final particleSize = _random.nextDouble() * 8 + 4;
      final color = colors[i % colors.length];

      final x = startX + speedX * progress;
      final y = -20 + speedY * progress;

      if (y > size.height + 20) continue;

      final paint = Paint()
        ..color = color.withAlpha(
          ((1.0 - progress * 0.6) * 220).toInt().clamp(0, 255),
        )
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation * progress);

      if (i % 2 == 0) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: particleSize,
            height: particleSize * 0.5,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, particleSize * 0.4, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}