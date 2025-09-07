// Strategy Interface and Implementations
import 'dart:math';

import 'enums.dart';
import 'game_models.dart';

abstract class Strategy {
  String get name;
  String get description;
  GameAction getNextAction(List<GameResult> history, bool isPlayer1);
}

class AlwaysCooperateStrategy implements Strategy {
  @override
  String get name => "Always Cooperate (Angel)";

  @override
  String get description =>
      "Always chooses to cooperate, regardless of opponent's actions. Very trusting but vulnerable to exploitation.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    return GameAction.cooperate;
  }
}

class AlwaysDefectStrategy implements Strategy {
  @override
  String get name => "Always Defect (Devil)";

  @override
  String get description =>
      "Always chooses to defect. Exploits cooperative opponents but performs poorly against other defectors.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    return GameAction.defect;
  }
}

class TitForTatStrategy implements Strategy {
  @override
  String get name => "Tit for Tat";

  @override
  String get description =>
      "Cooperates first, then copies opponent's last move. Simple, forgiving, and highly successful in tournaments.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    if (history.isEmpty) return GameAction.cooperate;

    final lastResult = history.last;
    final opponentLastAction = isPlayer1
        ? lastResult.player2Action
        : lastResult.player1Action;
    return opponentLastAction;
  }
}

class GrudgerStrategy implements Strategy {
  @override
  String get name => "Grudger";

  @override
  String get description =>
      "Cooperates until opponent defects once, then defects forever. Unforgiving but effective against exploiters.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    for (final result in history) {
      final opponentAction = isPlayer1
          ? result.player2Action
          : result.player1Action;
      if (opponentAction == GameAction.defect) {
        return GameAction.defect;
      }
    }
    return GameAction.cooperate;
  }
}

class RandomStrategy implements Strategy {
  final Random _random = Random();

  @override
  String get name => "Random";

  @override
  String get description =>
      "Randomly chooses between cooperation and defection with 50% probability each.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    return _random.nextBool() ? GameAction.cooperate : GameAction.defect;
  }
}

class PavlovStrategy implements Strategy {
  @override
  String get name => "Pavlov (Win-Stay, Lose-Shift)";

  @override
  String get description =>
      "Repeats last action if it was rewarding, changes if it wasn't. Adapts based on payoff received.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    if (history.isEmpty) return GameAction.cooperate;

    final lastResult = history.last;
    final myLastAction = isPlayer1
        ? lastResult.player1Action
        : lastResult.player2Action;
    final myLastScore = isPlayer1
        ? lastResult.player1Score
        : lastResult.player2Score;

    // If last score was good (3 or 5 points), repeat the action
    // If last score was bad (0 or 1 points), switch action
    if (myLastScore >= 3) {
      return myLastAction;
    } else {
      return myLastAction == GameAction.cooperate
          ? GameAction.defect
          : GameAction.cooperate;
    }
  }
}

// Additional Strategy Implementations for completeness
class GenerousTitForTatStrategy implements Strategy {
  final Random _random = Random();

  @override
  String get name => "Generous Tit for Tat";

  @override
  String get description =>
      "Like Tit for Tat but occasionally forgives defections to break revenge cycles.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    if (history.isEmpty) return GameAction.cooperate;

    final lastResult = history.last;
    final opponentLastAction = isPlayer1
        ? lastResult.player2Action
        : lastResult.player1Action;

    // If opponent cooperated, cooperate
    if (opponentLastAction == GameAction.cooperate) {
      return GameAction.cooperate;
    }

    // If opponent defected, usually defect but sometimes forgive (10% chance)
    return _random.nextDouble() < 0.1
        ? GameAction.cooperate
        : GameAction.defect;
  }
}

class TitForTwoTatsStrategy implements Strategy {
  @override
  String get name => "Tit for Two Tats";

  @override
  String get description =>
      "Only retaliates after opponent defects twice in a row. More forgiving than Tit for Tat.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    if (history.length < 2) return GameAction.cooperate;

    final lastResult = history.last;
    final secondLastResult = history[history.length - 2];

    final opponentLastAction = isPlayer1
        ? lastResult.player2Action
        : lastResult.player1Action;
    final opponentSecondLastAction = isPlayer1
        ? secondLastResult.player2Action
        : secondLastResult.player1Action;

    // Only defect if opponent defected in both of the last two rounds
    if (opponentLastAction == GameAction.defect &&
        opponentSecondLastAction == GameAction.defect) {
      return GameAction.defect;
    }

    return GameAction.cooperate;
  }
}

class SuspiciousTitForTatStrategy implements Strategy {
  @override
  String get name => "Suspicious Tit for Tat";

  @override
  String get description =>
      "Like Tit for Tat but starts with defection instead of cooperation.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    if (history.isEmpty) return GameAction.defect; // Start with defection

    final lastResult = history.last;
    final opponentLastAction = isPlayer1
        ? lastResult.player2Action
        : lastResult.player1Action;
    return opponentLastAction; // Copy opponent's last move
  }
}

class GenerousStrategy implements Strategy {
  final Random _random = Random();

  @override
  String get name => "Generous";

  @override
  String get description =>
      "Cooperates most of the time but occasionally defects randomly to test opponent.";

  @override
  GameAction getNextAction(List<GameResult> history, bool isPlayer1) {
    // 90% cooperation, 10% defection
    return _random.nextDouble() < 0.9
        ? GameAction.cooperate
        : GameAction.defect;
  }
}
