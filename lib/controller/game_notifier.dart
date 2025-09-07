// Game Logic Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/core.dart';

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState());

  void setGameMode(GameMode mode, StrategyType? strategy) {
    state = GameState(
      mode: mode,
      computerStrategy: strategy,
      isMuted: state.isMuted,
    );
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  void resetGame() {
    state = GameState(
      mode: state.mode,
      computerStrategy: state.computerStrategy,
      isMuted: state.isMuted,
    );
  }

  Strategy _getStrategy(StrategyType type) {
    switch (type) {
      case StrategyType.alwaysCooperate:
        return AlwaysCooperateStrategy();
      case StrategyType.alwaysDefect:
        return AlwaysDefectStrategy();
      case StrategyType.titForTat:
        return TitForTatStrategy();
      case StrategyType.grudger:
        return GrudgerStrategy();
      case StrategyType.random:
        return RandomStrategy();
      case StrategyType.pavlov:
        return PavlovStrategy();
      case StrategyType.generousTitForTat:
        return GenerousTitForTatStrategy();
      case StrategyType.titForTwoTats:
        return TitForTwoTatsStrategy();
      case StrategyType.suspicious:
        return SuspiciousTitForTatStrategy();
      case StrategyType.generous:
        return GenerousStrategy();
    }
  }

  // Performance: Use const map for faster lookups
  static const Map<String, Map<String, int>> _payoffMatrix = {
    'cooperate_cooperate': {'player1': 3, 'player2': 3},
    'defect_defect': {'player1': 1, 'player2': 1},
    'cooperate_defect': {'player1': 0, 'player2': 5},
    'defect_cooperate': {'player1': 5, 'player2': 0},
  };

  Map<String, int> _calculatePayoff(
    GameAction player1Action,
    GameAction player2Action,
  ) {
    final key = '${player1Action.name}_${player2Action.name}';
    return _payoffMatrix[key] ?? {'player1': 0, 'player2': 0};
  }

  void playRound(GameAction player1Action, [GameAction? player2Action]) {
    GameAction finalPlayer2Action;

    if (state.mode == GameMode.vsComputer && state.computerStrategy != null) {
      final strategy = _getStrategy(state.computerStrategy!);
      finalPlayer2Action = strategy.getNextAction(state.history, false);
    } else {
      finalPlayer2Action = player2Action ?? GameAction.cooperate;
    }

    final payoff = _calculatePayoff(player1Action, finalPlayer2Action);
    final result = GameResult(
      player1Score: payoff['player1']!,
      player2Score: payoff['player2']!,
      player1Action: player1Action,
      player2Action: finalPlayer2Action,
    );

    final newHistory = [...state.history, result];
    final newPlayer1Total = state.totalPlayer1Score + result.player1Score;
    final newPlayer2Total = state.totalPlayer2Score + result.player2Score;
    final newRound = state.currentRound + 1;

    // Check win condition (first to 50 points or after 20 rounds)
    bool gameEnded = false;
    String? winner;

    if (newPlayer1Total >= 50 || newPlayer2Total >= 50 || newRound >= 20) {
      gameEnded = true;
      if (newPlayer1Total > newPlayer2Total) {
        winner = "Player 1";
      } else if (newPlayer2Total > newPlayer1Total) {
        winner = state.mode == GameMode.vsComputer ? "Computer" : "Player 2";
      } else {
        winner = "Tie";
      }
    }

    state = state.copyWith(
      history: newHistory,
      totalPlayer1Score: newPlayer1Total,
      totalPlayer2Score: newPlayer2Total,
      currentRound: newRound,
      gameEnded: gameEnded,
      winner: winner,
    );
  }
}
