import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/app_bar.dart';
import '../common/enums.dart';
import '../repository/game_notifier.dart';
import 'game_end_screen.dart';
import '../widgets/game_history.dart';
import '../widgets/player_controls.dart';
import '../widgets/stick_figure_area.dart';
import 'how_to_play_screen.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Round ${gameState.currentRound + 1}',
        backgroundColor: Colors.blue[800],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HowToPlayScreen()),
              );
            },
            child: Text('ℹ️ Game Rules', style: TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Restart Game',
            onPressed: () {
              ref.read(gameProvider.notifier).resetGame();
            },
          ),
        ],
      ),
      body: gameState.gameEnded
          ? GameEndScreen()
          : Column(
              children: [
                // Score Display
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Player 1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${gameState.totalPlayer1Score}',
                            style: TextStyle(fontSize: 24, color: Colors.blue),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            gameState.mode == GameMode.vsComputer
                                ? 'Computer'
                                : 'Player 2',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${gameState.totalPlayer2Score}',
                            style: TextStyle(fontSize: 24, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Stick Figures and Animation Area
                SingleChildScrollView(
                  child: Expanded(child: StickFigureArea()),
                ),

                // Action Buttons
                if (!gameState.gameEnded)
                  Container(
                    padding: EdgeInsets.all(16),
                    child: gameState.mode == GameMode.vsHuman
                        ? TwoPlayerControls()
                        : SinglePlayerControls(),
                  ),

                // History
                if (gameState.history.isNotEmpty)
                  SizedBox(height: 120, child: GameHistoryWidget()),
              ],
            ),
    );
  }
}
