import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_prisoners_dilema/common/app_bar.dart';
import 'package:the_prisoners_dilema/view/how_to_play_screen.dart';

import '../common/enums.dart';
import '../repository/game_notifier.dart';
import '../widgets/stick_figure_fight.dart';
import 'game_screen.dart';
import 'strategy_guide_screen.dart';
import 'strategy_selection_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(text: "The Classic Prisoner's Dilemma"),
      body: Stack(
        children: [
          // Animated Background with moving Particles and Gradients
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.purple.shade400],
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOutCubicEmphasized,
              color: ref.watch(gameProvider).gameEnded
                  ? Colors.grey
                  : Colors.blueGrey.shade50.withOpacity(0.15),
            ),
          ),
          StickFigureFight(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "🤝 Prisoner's Dilemma ⚔️",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Choose your game mode:',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StrategySelectionScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.computer),
                  label: Text('VS Computer'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(gameProvider.notifier)
                        .setGameMode(GameMode.vsHuman, null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen()),
                    );
                  },
                  icon: Icon(Icons.people),
                  label: Text('VS Human'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HowToPlayScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.how_to_vote),
                  label: Text('How to Play'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StrategyPage()),
                    );
                  },
                  icon: Icon(Icons.library_books),
                  label: Text('Strategy Guide'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                    backgroundColor: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
