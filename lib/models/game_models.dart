// File: lib/models/game_models.dart

class Player {
  String name;

  Player({required this.name});
}

class Team {
  String name;
  List<Player?> players;
  int score;

  Team({required this.name, required int capacity})
      : players = List.filled(capacity, null, growable: false),
        score = 0;

  bool get isFull => !players.contains(null);
}