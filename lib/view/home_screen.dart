import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_prisoners_dilema/common/app_bar.dart';
import 'package:the_prisoners_dilema/view/how_to_play_screen.dart';

import '../common/circular_app_icon.dart';
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
    // Performance: Only watch specific parts of game state that affect this screen
    final gameEnded = ref.watch(
      gameProvider.select((state) => state.gameEnded),
    );

    return Scaffold(
      appBar: const CustomAppBar(
        text: "The Classic - Prisoner's Dilemma",
        isHomepage: true,
      ),
      body: Stack(
        children: [
          // Performance: Use const gradient container to avoid rebuilds
          const _BackgroundGradient(),
          // Performance: Optimize animated overlay
          _GameEndedOverlay(gameEnded: gameEnded),
          // Performance: Only show fight animation when needed
          if (!gameEnded) const StickFigureFight(),

          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Icon and Title
                  SizedBox(height: 10),
                  CircularAppIcon(size: 60),
                  SizedBox(height: 10),
                  // Description Text to be organized in a block
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: RichText(
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '🧍Two prisoners must decide🧍‍♂️',

                            children: [
                              TextSpan(
                                text: ' \n🤝 Co-operate',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightGreen.shade500,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: ' OR ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text: ' Betray 🗡️',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade300,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n\nWill you trust your opponent,\nor\n Will you outsmart them? \n',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),

                  Text(
                    'Choose your game mode:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.yellowAccent.shade100,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  // Buttons for navigation
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                      backgroundColor: Colors.green,
                    ),
                  ),
                  SizedBox(height: 15),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      textStyle: TextStyle(fontSize: 16),
                      backgroundColor: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Performance: Separate const widgets to avoid rebuilds
class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.purple.shade200],
        ),
      ),
    );
  }
}

class _GameEndedOverlay extends StatelessWidget {
  final bool gameEnded;

  const _GameEndedOverlay({required this.gameEnded});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Reduced duration
        curve: Curves.easeInOut, // Simpler curve
        color: gameEnded ? Colors.blueGrey : Colors.transparent,
      ),
    );
  }
}
