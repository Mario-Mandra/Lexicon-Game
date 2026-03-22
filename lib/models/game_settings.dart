// File: lib/models/game_settings.dart

import 'package:purchases_flutter/purchases_flutter.dart';

class GameSettings {
  int targetScore;
  int roundDurationSeconds;
  int totalPlayers;
  String selectedPackId;
  String language;
  
  // Debug/Logic Flags
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

  void resetAccess() {
    isPremium = false;
    unlockedPackIds = [];
    adSessionActive = false;
  }

  // --- REVENUECAT PRODUCTION INTEGRATION ---
  
  Future<void> syncPurchases() async {
    try {
      CustomerInfo info = await Purchases.getCustomerInfo();
      _updateAccessFromInfo(info);
    } catch (e) {
      // Fails silently if offline or not fully set up in the console yet
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
}