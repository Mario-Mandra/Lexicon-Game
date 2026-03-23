// File: lib/models/game_settings.dart

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSettings {
  int targetScore;
  int roundDurationSeconds;
  int totalPlayers;
  String selectedPackId;
  String language;

  bool isPremium;
  List<String> unlockedPackIds;
  bool adSessionActive;

  // Debug flag to hide real purchases so you can test the "Buy" button again
  bool _debugRevokedAccess = false;

  // Your RevenueCat entitlement identifier
  static const String _premiumEntitlement = 'Not a Studio App Studio Pro';
  static const String _devAccessKey = 'dev_access';

  GameSettings({
    this.targetScore = 30,
    this.roundDurationSeconds = 60,
    this.totalPlayers = 4,
    this.selectedPackId = 'generic',
    this.language = 'ro',
    this.isPremium = false,
    this.unlockedPackIds = const [],
    this.adSessionActive = false,
  });

  // Called once on app launch
  Future<void> initializeAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final devAccess = prefs.getBool(_devAccessKey) ?? false;

    if (devAccess) {
      isPremium = true;
      unlockedPackIds = ['pop_culture', 'after_dark'];
      return;
    }

    await syncPurchases();
  }

  Future<void> syncPurchases() async {
    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      updateAccessFromInfo(info);
    } catch (e) {
      // Fails silently if offline or RevenueCat unreachable
    }
  }

  void updateAccessFromInfo(CustomerInfo info) {
    if (_debugRevokedAccess) {
      isPremium = false;
      unlockedPackIds = [];
      return;
    }

    // Checks BOTH the explicit entitlement AND the raw product.
    // This ensures lifetime products work even if the entitlement link breaks.
    isPremium = info.entitlements.active.containsKey(_premiumEntitlement) ||
                info.allPurchasedProductIdentifiers.contains('premium_unlock');

    List<String> unlocked = info.allPurchasedProductIdentifiers.toList();
    
    info.entitlements.active.forEach((key, entitlement) {
      if (key != _premiumEntitlement && !unlocked.contains(key)) {
        unlocked.add(key);
      }
    });

    unlockedPackIds = unlocked;
  }

  Future<void> grantDevAccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_devAccessKey, true);
    _debugRevokedAccess = false;
    isPremium = true;
    unlockedPackIds = ['pop_culture', 'after_dark'];
  }

  Future<void> resetAccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_devAccessKey, false);
    
    // Hides real RevenueCat purchases temporarily so you can test the UI
    _debugRevokedAccess = true; 
    
    isPremium = false;
    unlockedPackIds = [];
    adSessionActive = false;
  }

  void clearDebugRevoke() {
    _debugRevokedAccess = false;
  }
}