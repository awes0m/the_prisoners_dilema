import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_prisoners_dilema/common/app_bar.dart';

import '../common/enums.dart';
import '../repository/game_notifier.dart';
import '../models/strategy.dart';
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
      {
        'type': StrategyType.generousTitForTat,
        'name': 'Generous Tit for Tat',
        'difficulty': 'Medium',
      },
      {
        'type': StrategyType.titForTwoTats,
        'name': 'Tit for Two Tats',
        'difficulty': 'Medium',
      },
      {
        'type': StrategyType.suspicious,
        'name': 'Suspicious Tit for Tat',
        'difficulty': 'Hard',
      },
      {'type': StrategyType.generous, 'name': 'Generous', 'difficulty': 'Easy'},
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.purple.shade400],
              ),
            ),
          ),
          GridView.builder(
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

              // Map StrategyType to description from Strategy classes
              String description;
              switch (strategy['type'] as StrategyType) {
                case StrategyType.titForTat:
                  description = TitForTatStrategy().description;
                  break;
                case StrategyType.alwaysCooperate:
                  description = AlwaysCooperateStrategy().description;
                  break;
                case StrategyType.alwaysDefect:
                  description = AlwaysDefectStrategy().description;
                  break;
                case StrategyType.grudger:
                  description = GrudgerStrategy().description;
                  break;
                case StrategyType.random:
                  description = RandomStrategy().description;
                  break;
                case StrategyType.pavlov:
                  description = PavlovStrategy().description;
                  break;
                case StrategyType.generousTitForTat:
                  description = GenerousTitForTatStrategy().description;
                  break;
                case StrategyType.titForTwoTats:
                  description = TitForTwoTatsStrategy().description;
                  break;
                case StrategyType.suspicious:
                  description = SuspiciousTitForTatStrategy().description;
                  break;
                case StrategyType.generous:
                  description = GenerousStrategy().description;
                  break;
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Tooltip(
                  message: description,
                  waitDuration: Duration(milliseconds: 300),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(200),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Center(
                              child: Text(
                                strategy['difficulty'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
