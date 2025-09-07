// Game Models

import '../common/enums.dart';

class GameResult {
  final int player1Score;
  final int player2Score;
  final GameAction player1Action;
  final GameAction player2Action;

  GameResult({
    required this.player1Score,
    required this.player2Score,
    required this.player1Action,
    required this.player2Action,
  });
}

class GameState {
  final List<GameResult> history;
  final int totalPlayer1Score;
  final int totalPlayer2Score;
  final GameMode mode;
  final StrategyType? computerStrategy;
  final int currentRound;
  final bool gameEnded;
  final String? winner;
  final bool isMuted; // UX: mute sounds

  GameState({
    this.history = const [],
    this.totalPlayer1Score = 0,
    this.totalPlayer2Score = 0,
    this.mode = GameMode.vsComputer,
    this.computerStrategy,
    this.currentRound = 0,
    this.gameEnded = false,
    this.winner,
    this.isMuted = false,
  });

  GameState copyWith({
    List<GameResult>? history,
    int? totalPlayer1Score,
    int? totalPlayer2Score,
    GameMode? mode,
    StrategyType? computerStrategy,
    int? currentRound,
    bool? gameEnded,
    String? winner,
    bool? isMuted,
  }) {
    return GameState(
      history: history ?? this.history,
      totalPlayer1Score: totalPlayer1Score ?? this.totalPlayer1Score,
      totalPlayer2Score: totalPlayer2Score ?? this.totalPlayer2Score,
      mode: mode ?? this.mode,
      computerStrategy: computerStrategy ?? this.computerStrategy,
      currentRound: currentRound ?? this.currentRound,
      gameEnded: gameEnded ?? this.gameEnded,
      winner: winner ?? this.winner,
      isMuted: isMuted ?? this.isMuted,
    );
  }
}
