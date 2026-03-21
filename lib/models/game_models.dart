// File: lib/models/game_models.dart

class Player {
  String name;
  
  Player({required this.name});
}

class Team {
  String name;
  // We use Player? (with a question mark) because a slot can be empty (null) initially.
  List<Player?> players; 
  int score;

  Team({required this.name, required int capacity}) 
      : players = List.filled(capacity, null, growable: false), // Fixes the size to exactly 2 slots
        score = 0;

  // A quick helper function to check if the team is full
  bool get isFull => !players.contains(null);
}