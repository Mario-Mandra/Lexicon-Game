// File: lib/screens/main_menu_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/game_settings.dart';
import 'rules_screen.dart';
import 'game_setup_screen.dart';

class MainMenuScreen extends StatefulWidget {
  final GameSettings settings;

  const MainMenuScreen({super.key, required this.settings});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    _gatherConsent();
  }

  void _gatherConsent() {
    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        ConsentForm.loadAndShowConsentFormIfRequired((loadAndShowError) async {
          // Initialize ads only after the form is resolved or if it wasn't required
          if (await ConsentInformation.instance.canRequestAds()) {
            _initializeAds();
          }
        });
      },
      (FormError error) {
        // If UMP fails (e.g., no internet), it fails silently. 
        // AdMob simply won't serve ads to EU users until consent is gathered.
      },
    );
  }

  void _initializeAds() async {
    await MobileAds.instance.initialize();
    
    // Test device ID ensures you can safely tap ads while developing
    RequestConfiguration adConfig = RequestConfiguration(
      testDeviceIds: ['B13BAB7B27AAEB0B7DE5D8A53A53A649'],
    );
    MobileAds.instance.updateRequestConfiguration(adConfig);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _launchPrivacyPolicy() async {
    final Uri url = Uri.parse(
        'https://doc-hosting.flycricket.io/lexicon-s-privacy-policy/d6d98cd4-d4f4-4245-aaa9-a0b82ce1fe20/privacy');
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch privacy policy');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'LEXICON',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 12,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: theme.colorScheme.primary.withAlpha(150),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'THE ULTIMATE PARTY GAME',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 4,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _MenuButton(
                icon: Icons.play_arrow_rounded,
                title: 'PLAY NOW',
                subtitle: 'Start a new game',
                isPrimary: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GameSetupScreen(settings: widget.settings),
                  ),
                ).then((_) => _refresh()),
              ),
              const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.menu_book_rounded,
                title: 'HOW TO PLAY',
                subtitle: 'Rules and instructions',
                isPrimary: false,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RulesScreen(
                      settings: widget.settings,
                      onUpdate: _refresh,
                    ),
                  ),
                ).then((_) => _refresh()),
              ),
              const Spacer(),
              TextButton(
                onPressed: _launchPrivacyPolicy,
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.white54,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white54,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isPrimary;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary
              ? theme.colorScheme.primary.withAlpha(20)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(24),
          border: isPrimary
              ? Border.all(
                  color: theme.colorScheme.primary.withAlpha(150), width: 2)
              : Border.all(
                  color: theme.colorScheme.primary.withAlpha(20), width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 36,
              color: isPrimary ? theme.colorScheme.primary : Colors.white,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isPrimary
                          ? theme.colorScheme.primary
                          : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}