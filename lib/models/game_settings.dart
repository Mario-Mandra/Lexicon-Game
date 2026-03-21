// File: lib/models/game_settings.dart

class GameSettings {
  int targetScore;
  int roundDurationSeconds;
  int totalPlayers;
  String selectedPackId;
  String language;
  
  // Debug/Logic Flags
  bool isPremium;
  List<String> unlockedPackIds; // Tracks individually bought packs
  bool adSessionActive;         // Tracks if a reward ad was watched for this session

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
}