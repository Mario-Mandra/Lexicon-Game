// File: lib/screens/wordpack_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
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
  State<WordpackSelectionScreen> createState() =>
      _WordpackSelectionScreenState();
}

class _WordpackSelectionScreenState extends State<WordpackSelectionScreen> {
  bool _isProcessingTransaction = false;

  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;

  // TODO: Replace with real ad unit ID before release
  final String _rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
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

  void _processAdReward() {
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
          setState(() {
            widget.settings.adSessionActive = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ad completed! Packs temporarily unlocked.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
      },
    );
  }

  Future<void> _processPurchase(String packId) async {
    setState(() => _isProcessingTransaction = true);
    try {
      final products = await Purchases.getProducts([packId]);
      if (products.isEmpty) throw Exception('Product not found in store.');

      // Capture the immediate result, clear any dev locks, and update UI
      final info = await Purchases.purchaseStoreProduct(products.first);
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

  Future<void> _processPremiumPurchase() async {
    setState(() => _isProcessingTransaction = true);
    try {
      final products = await Purchases.getProducts(['premium_unlock']);
      if (products.isEmpty) throw Exception('Product not found in store.');

      // Capture the immediate result, clear any dev locks, and update UI
      final info = await Purchases.purchaseStoreProduct(products.first);
      widget.settings.clearDebugRevoke();
      widget.settings.updateAccessFromInfo(info);

      if (mounted) {
        setState(() => _isProcessingTransaction = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Welcome to Premium!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.amber,
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

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final availablePacks = availableWordPacks
        .where((p) => !p.effectivelyLocked(widget.settings))
        .toList();
    final lockedPacks = availableWordPacks
        .where((p) => p.effectivelyLocked(widget.settings))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('CHOOSE WORDPACK', style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    if (availablePacks.isNotEmpty) ...[
                      _sectionHeader('AVAILABLE'),
                      ...availablePacks.map(
                        (pack) => _buildPackTile(context, pack, theme, false),
                      ),
                    ],
                    if (lockedPacks.isNotEmpty) ...[
                      const SizedBox(height: 32),
                      _sectionHeader('LOCKED'),
                      ...lockedPacks.map(
                        (pack) => _buildPackTile(context, pack, theme, true),
                      ),
                    ],
                  ],
                ),
              ),
              if (!widget.settings.isPremium) _buildPremiumBanner(theme),
            ],
          ),
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
      ),
    );
  }

  Widget _buildPremiumBanner(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          top: BorderSide(color: Colors.amber.withAlpha(100), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
              SizedBox(width: 12),
              Text(
                'LEXICON PREMIUM',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _premiumBullet('Get full access to all special packs'),
          _premiumBullet('Create your own custom wordpacks'),
          _premiumBullet('Remove all ads permanently'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _processPremiumPurchase,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: const Text(
              'BUY FOR \$7.99',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: Colors.amber.withAlpha(200),
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
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
        style: const TextStyle(
          color: Colors.white38,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPackTile(
    BuildContext context,
    WordPack pack,
    ThemeData theme,
    bool isLocked,
  ) {
    final isSelected = pack.id == widget.currentPackId;
    final isCustom = pack.id == 'custom';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(20)
            : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withAlpha(20),
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
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.white54,
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
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.white,
                          ),
                        ),
                        Text(
                          pack.subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected && !isLocked)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                ],
              ),
              if (isLocked) ...[
                const SizedBox(height: 16),
                if (pack.requiresPremium)
                  _premiumBadge()
                else
                  Row(
                    children: [
                      Expanded(
                        child: _actionBtn(
                          'WATCH AD',
                          Icons.play_circle_outline,
                          Colors.white10,
                          _processAdReward,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _actionBtn(
                          'BUY \$0.99',
                          Icons.shopping_bag_outlined,
                          theme.colorScheme.primary,
                          () => _processPurchase(pack.id),
                        ),
                      ),
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
          Text(
            'PREMIUM ONLY',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: label == 'BUY \$0.99'
              ? null
              : Border.all(color: Colors.white24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CustomPackEditorScreen(),
          ),
        ),
        icon: const Icon(Icons.edit, size: 18),
        label: const Text('EDIT WORDS'),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.primary.withAlpha(30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}