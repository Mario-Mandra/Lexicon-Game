// File: lib/screens/game_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
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

  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;

  final String _rewardedAdUnitId = 'ca-app-pub-3836287958039986/4233855759';

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    widget.settings.syncPurchases().then((_) {
      if (mounted) setState(() {});
    });
  }

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
              if (mounted) setState(() => _isProcessing = false);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadRewardedAd();
              if (mounted) setState(() => _isProcessing = false);
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

  @override
  void dispose() {
    _rewardedAd?.dispose();
    widget.settings.adSessionActive = false;
    super.dispose();
  }

  void _processAd() {
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

    setState(() => _isProcessing = true);

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (mounted) {
          setState(() {
            widget.settings.adSessionActive = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ad completed! Pack unlocked for this session.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _processPurchase(String packId) async {
    setState(() => _isProcessing = true);
    try {
      final products = await Purchases.getProducts([packId]);
      if (products.isEmpty) throw Exception('Product not found in store.');

      final info = await Purchases.purchaseStoreProduct(products.first);
      
      // Capture the immediate result, clear any dev locks, and update UI
      widget.settings.clearDebugRevoke();
      widget.settings.updateAccessFromInfo(info);

      if (mounted) {
        setState(() => _isProcessing = false);
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
        setState(() => _isProcessing = false);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Store unavailable right now.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Store unavailable.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
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
                _buildPackLangSelectors(
                  context,
                  theme,
                  currentPack,
                  availableLanguages,
                  isLocked,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      _sliderCard(
                          title: 'TOTAL PLAYERS',
                          display: '${widget.settings.totalPlayers}',
                          val: widget.settings.totalPlayers.toDouble(),
                          min: 2,
                          max: 10,
                          divisions: 4,
                          onChanged: (v) => setState(
                            () => widget.settings.totalPlayers = (v.round() ~/ 2) * 2,
                        ),
                      ),
                      _sliderCard(
                        title: 'TARGET SCORE',
                        display: '${widget.settings.targetScore} PTS',
                        val: widget.settings.targetScore.toDouble(),
                        min: 10,
                        max: 100,
                        divisions: 9,
                        onChanged: (v) => setState(
                          () => widget.settings.targetScore = v.toInt(),
                        ),
                      ),
                      _sliderCard(
                        title: 'ROUND TIME',
                        display: '${widget.settings.roundDurationSeconds} SEC',
                        val: widget.settings.roundDurationSeconds.toDouble(),
                        min: 15,
                        max: 120,
                        divisions: 7,
                        onChanged: (v) => setState(
                          () => widget.settings.roundDurationSeconds = v.toInt(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (!isLocked)
                  _lobbyButton(theme)
                else
                  _transactionButtons(theme, currentPack.id),
              ],
            ),
          ),
          if (_isProcessing)
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
      ),
    );
  }

  Widget _buildPackLangSelectors(
    BuildContext context,
    ThemeData theme,
    WordPack currentPack,
    List<String> availableLanguages,
    bool isLocked,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: InkWell(
            onTap: () async {
              final id = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => WordpackSelectionScreen(
                    currentPackId: widget.settings.selectedPackId,
                    settings: widget.settings,
                  ),
                ),
              );
              if (id != null) {
                setState(() {
                  widget.settings.selectedPackId = id;
                  final newPack =
                      availableWordPacks.firstWhere((p) => p.id == id);
                  if (!newPack.localizedWords
                      .containsKey(widget.settings.language)) {
                    widget.settings.language =
                        newPack.localizedWords.keys.first;
                  }
                });
              } else {
                // Ensure UI updates if returning from selection screen after a purchase
                setState(() {}); 
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isLocked
                      ? Colors.amber.withAlpha(150)
                      : theme.colorScheme.primary.withAlpha(80),
                  width: isLocked ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'WORDPACK',
                        style: TextStyle(fontSize: 10, color: Colors.white54),
                      ),
                      if (isLocked)
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.lock, size: 10, color: Colors.amber),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentPack.title,
                    style: TextStyle(
                      color: isLocked
                          ? Colors.amber
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LANG',
                  style: TextStyle(fontSize: 10, color: Colors.white54),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.settings.language,
                    isExpanded: true,
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    items: availableLanguages
                        .map(
                          (l) => DropdownMenuItem(
                            value: l,
                            child: Text(
                              languageNames[l] ?? l.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1, // Add this
                              overflow: TextOverflow.ellipsis, // Add this to fix the crash
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => widget.settings.language = v!),
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
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamSetupScreen(settings: widget.settings),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        shadowColor: theme.colorScheme.primary.withAlpha(100),
      ),
      child: const Text(
        'NEXT: LOBBY',
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }

  Widget _transactionButtons(ThemeData theme, String packId) {
    if (packId == 'custom') {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.amber.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.withAlpha(50)),
        ),
        child: const Center(
          child: Text(
            'PREMIUM ONLY',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _processAd,
            icon: const Icon(Icons.play_circle_outline, size: 18),
            label: const Text(
              'WATCH AD',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.white24),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _processPurchase(packId),
            icon: const Icon(Icons.shopping_bag_outlined, size: 18),
            label: const Text(
              'BUY \$0.99',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: theme.colorScheme.primary.withAlpha(100),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sliderCard({
    required String title,
    required String display,
    required double val,
    required double min,
    required double max,
    required int divisions,
    required Function(double) onChanged,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(20)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white38,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            display,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          Slider(
            value: val,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: theme.colorScheme.primary,
            inactiveColor: theme.colorScheme.primary.withAlpha(40),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}