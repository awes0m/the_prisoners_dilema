import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../common/app_bar.dart';
import '../../../core/enums.dart';
import '../../../controller/game_notifier.dart';
import '../widgets/game_end_confetti.dart';
import '../widgets/score_display.dart';
import 'game_end_screen.dart';
import '../widgets/game_history.dart';
import '../widgets/player_controls.dart';
import '../widgets/enhanced_prisoner_area.dart';
import '../../info/view/how_to_play_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late final AudioPlayer _endSfx;

  @override
  void initState() {
    super.initState();
    _endSfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _endSfx.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Performance: Watch only specific parts of state that affect this widget
    final currentRound = ref.watch(
      gameProvider.select((state) => state.currentRound),
    );
    final gameEnded = ref.watch(
      gameProvider.select((state) => state.gameEnded),
    );
    final isMuted = ref.watch(gameProvider.select((state) => state.isMuted));
    final mode = ref.watch(gameProvider.select((state) => state.mode));
    final totalPlayer1Score = ref.watch(
      gameProvider.select((state) => state.totalPlayer1Score),
    );
    final totalPlayer2Score = ref.watch(
      gameProvider.select((state) => state.totalPlayer2Score),
    );
    final history = ref.watch(gameProvider.select((state) => state.history));

    // Listen for game end to play victory sound (must be inside build for Riverpod)
    ref.listen(gameProvider.select((state) => state.gameEnded), (
      previous,
      gameEnded,
    ) async {
      final wasEnded = previous ?? false;
      if (!wasEnded && gameEnded) {
        if (!isMuted) {
          try {
            await _endSfx.stop();
            await _endSfx.play(AssetSource('sfx/game_complete.wav'));
          } catch (_) {
            // ignore non-critical audio errors
          }
        }
      }
    });

    return Scaffold(
      appBar: CustomAppBar(
        text: 'Round ${currentRound + 1}',
        backgroundColor: Colors.blueGrey.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HowToPlayScreen(),
                ),
              );
            },
            tooltip: 'How-to-play Game Instructions',
          ),
          IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            tooltip: isMuted ? 'Unmute' : 'Mute',
            onPressed: () {
              ref.read(gameProvider.notifier).toggleMute();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Restart Game',
            onPressed: () {
              ref.read(gameProvider.notifier).resetGame();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Animated gradient background for a livelier feel
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 8),
                onEnd: () {},
                builder: (context, value, _) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blueGrey.shade100,
                          Color.lerp(
                            Colors.blueGrey.shade50,
                            Colors.white,
                            value * 0.6,
                          )!,
                          Color.lerp(
                            Colors.orange.shade900,
                            Colors.black38,
                            value * 0.4,
                          )!,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: gameEnded
                  ? Stack(
                      key: const ValueKey('end'),
                      children: const [
                        GameEndScreen(),
                        // Confetti overlay (drawn by GameEndConfetti below)
                      ],
                    )
                  : Column(
                      key: const ValueKey('gameColumn'),
                      children: [
                        // Score Display
                        ScoreDisplay(
                          totalPlayer1Score: totalPlayer1Score,
                          totalPlayer2Score: totalPlayer2Score,
                          mode: mode,
                        ),

                        // Enhanced Prisoner Area with Animations
                        const Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            primary: true,
                            child: EnhancedPrisonerArea(),
                          ),
                        ),

                        // Action Buttons
                        if (!gameEnded)
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: mode == GameMode.vsHuman
                                ? const TwoPlayerControls()
                                : const SinglePlayerControls(),
                          ),

                        // History
                        if (history.isNotEmpty)
                          const SizedBox(
                            height: 120,
                            child: GameHistoryWidget(),
                          ),
                      ],
                    ),
            ),
            // Confetti layer shown when game ends
            if (gameEnded)
              GameEndConfetti(
                winner: totalPlayer1Score == totalPlayer2Score
                    ? Winner.tie
                    : (totalPlayer1Score > totalPlayer2Score
                          ? Winner.p1
                          : Winner.p2),
              ),
          ],
        ),
      ),
    );
  }
}
