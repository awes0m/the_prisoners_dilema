import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_prisoners_dilema/common/app_bar.dart';

import '../common/enums.dart';
import '../repository/game_notifier.dart';
import 'game_screen.dart';
import 'strategy_guide_screen.dart';

class StrategySelectionScreen extends ConsumerWidget {
  const StrategySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strategies = [
      {
        'type': StrategyType.titForTat,
        'name': 'Tit for Tat',
        'difficulty': 'Medium',
      },
      {
        'type': StrategyType.alwaysCooperate,
        'name': 'Always Cooperate',
        'difficulty': 'Easy',
      },
      {
        'type': StrategyType.alwaysDefect,
        'name': 'Always Defect',
        'difficulty': 'Easy',
      },
      {'type': StrategyType.grudger, 'name': 'Grudger', 'difficulty': 'Hard'},
      {'type': StrategyType.random, 'name': 'Random', 'difficulty': 'Medium'},
      {'type': StrategyType.pavlov, 'name': 'Pavlov', 'difficulty': 'Hard'},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Choose AI Strategy',
        backgroundColor: Colors.blue[800],
        actions: [
          TextButton.icon(
            icon: Icon(Icons.games_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StrategyPage()),
              );
            },
            label: Text(
              'Strategy Guide',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (MediaQuery.of(context).size.width > 600) ? 3 : 2,
          childAspectRatio: 7 / 4,
          mainAxisSpacing: 16,
        ),
        itemCount: strategies.length,
        itemBuilder: (context, index) {
          final strategy = strategies[index];
          Color difficultyColor = strategy['difficulty'] == 'Easy'
              ? Colors.green
              : strategy['difficulty'] == 'Medium'
              ? Colors.orange
              : Colors.red;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              margin: EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  ref
                      .read(gameProvider.notifier)
                      .setGameMode(
                        GameMode.vsComputer,
                        strategy['type'] as StrategyType,
                      );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
                child: GridTile(
                  header: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(200),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Center(
                        child: Text(
                          strategy['difficulty'] as String,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: difficultyColor,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        strategy['name'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
