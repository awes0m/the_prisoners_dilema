import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums.dart';
import '../../../controller/game_notifier.dart';

/// Displays the game end screen with final scores and options to play again or go back to main menu.
class GameEndScreen extends ConsumerWidget {
  const GameEndScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Game Over!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            gameState.winner == "Tie" ? "It's a Tie!" : "${gameState.winner} Wins!",
            style: TextStyle(
              fontSize: 24,
              color: gameState.winner == "Player 1" 
                ? Colors.blue 
                : gameState.winner == "Tie" 
                  ? Colors.grey 
                  : Colors.red,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text('Final Scores:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Player 1'),
                        Text('${gameState.totalPlayer1Score}', 
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    Column(
                      children: [
                        Text(gameState.mode == GameMode.vsComputer ? 'Computer' : 'Player 2'),
                        Text('${gameState.totalPlayer2Score}', 
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(gameProvider.notifier).resetGame();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: Text('Play Again'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  backgroundColor: Colors.grey,
                ),
                child: Text('Main Menu'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
