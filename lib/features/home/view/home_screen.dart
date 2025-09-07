import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core and common imports
import '../../../common/common.dart';
import '../../../core/core.dart';

// game imports
import '../../../controller/game_notifier.dart';
import '../../game/widgets/stick_figure_fight.dart';
import '../../game/view/game_screen.dart';
import '../../info/view/how_to_play_screen.dart';
import '../../info/view/strategy_guide_screen.dart';
import '../../game/view/strategy_selection_screen.dart';

// widgets
import 'widgets/background.dart';

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
          const BackgroundGradient(),
          // Performance: Optimize animated overlay
          GameEndedOverlay(gameEnded: gameEnded),
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
                        text: '🧍Two prisoners must decide🧍‍♂️',
                        children: [
                          TextSpan(
                            text: ' \nCo-operate ',
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
                            text: '🤝 OR 🗡️',
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
                            text: ' Betray',
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
                                '\n\nWill you trust your opponent, or outsmart them? \n',
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
                  // vs Computer -- Strategy Selection
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
                  // vs Human -- Game Screen
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
                  // Info Buttons
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
