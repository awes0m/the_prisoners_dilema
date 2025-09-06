// Game Logic Provider
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/enums.dart';
import '../models/models.dart';
import '../models/strategy.dart';

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState());

  void setGameMode(GameMode mode, StrategyType? strategy) {
    state = GameState(mode: mode, computerStrategy: strategy);
  }

  void resetGame() {
    state = GameState(
      mode: state.mode,
      computerStrategy: state.computerStrategy,
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
      default:
        return TitForTatStrategy();
    }
  }

  Map<String, int> _calculatePayoff(GameAction player1Action, GameAction player2Action) {
    if (player1Action == GameAction.cooperate && player2Action == GameAction.cooperate) {
      return {'player1': 3, 'player2': 3}; // Mutual cooperation
    } else if (player1Action == GameAction.defect && player2Action == GameAction.defect) {
      return {'player1': 1, 'player2': 1}; // Mutual defection
    } else if (player1Action == GameAction.cooperate && player2Action == GameAction.defect) {
      return {'player1': 0, 'player2': 5}; // Player 1 exploited
    } else {
      return {'player1': 5, 'player2': 0}; // Player 2 exploited
    }
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

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
