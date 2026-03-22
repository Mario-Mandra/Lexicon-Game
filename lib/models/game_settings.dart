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

  // Called once at app startup in main.dart
  // Checks local dev bypass first, then syncs with RevenueCat
  Future<void> initializeAccess() async {
    final prefs = await SharedPreferences.getInstance();
    final devAccess = prefs.getBool('dev_access') ?? false;

    if (devAccess) {
      // Dev bypass is active — skip RevenueCat entirely
      isPremium = true;
      unlockedPackIds = ['pop_culture', 'after_dark'];
      return;
    }

    // No dev bypass — sync with RevenueCat normally
    await syncPurchases();
  }

  Future<void> syncPurchases() async {
    try {
      CustomerInfo info = await Purchases.getCustomerInfo();
      _updateAccessFromInfo(info);
    } catch (e) {
      // Fails silently if offline or RevenueCat not yet configured
    }
  }

  void _updateAccessFromInfo(CustomerInfo info) {
    isPremium = info.entitlements.all["premium"]?.isActive == true;

    List<String> unlocked = [];
    info.entitlements.all.forEach((key, entitlement) {
      if (entitlement.isActive && key != 'premium') {
        unlocked.add(key);
      }
    });

    unlockedPackIds = unlocked;
  }

  // Permanently grants full access — survives app restarts
  Future<void> grantDevAccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dev_access', true);
    isPremium = true;
    unlockedPackIds = ['pop_culture', 'after_dark'];
  }

  // Revokes dev access and clears all purchased access
  Future<void> resetAccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dev_access', false);
    isPremium = false;
    unlockedPackIds = [];
    adSessionActive = false;
  }
}