// File: lib/models/game_settings.dart
class GameSettings {
  int targetScore;
  int roundDurationSeconds;
  int totalPlayers;
  String selectedPackId;
  String language;

  GameSettings({
    this.targetScore = 30,
    this.roundDurationSeconds = 60,
    this.totalPlayers = 4,
    this.selectedPackId = 'generic', // Matches our new word_bank IDs
    this.language = 'ro',
  });
}