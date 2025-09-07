import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../common/app_bar.dart';
import '../common/enums.dart';
import '../repository/game_notifier.dart';
import 'game_end_screen.dart';
import '../widgets/game_history.dart';
import '../widgets/player_controls.dart';
import '../widgets/stick_figure_area.dart';
import 'how_to_play_screen.dart';

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
    final currentRound = ref.watch(gameProvider.select((state) => state.currentRound));
    final gameEnded = ref.watch(gameProvider.select((state) => state.gameEnded));
    final isMuted = ref.watch(gameProvider.select((state) => state.isMuted));
    final mode = ref.watch(gameProvider.select((state) => state.mode));
    final totalPlayer1Score = ref.watch(gameProvider.select((state) => state.totalPlayer1Score));
    final totalPlayer2Score = ref.watch(gameProvider.select((state) => state.totalPlayer2Score));
    final history = ref.watch(gameProvider.select((state) => state.history));

    // Listen for game end to play victory sound (must be inside build for Riverpod)
    ref.listen(gameProvider.select((state) => state.gameEnded), (previous, gameEnded) async {
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
        backgroundColor: Colors.blue[800],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HowToPlayScreen()),
              );
            },
            child: const Text(
              'ℹ️ Game Rules',
              style: TextStyle(color: Colors.white),
            ),
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
      body: Stack(
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
                      _ScoreDisplay(
                        totalPlayer1Score: totalPlayer1Score,
                        totalPlayer2Score: totalPlayer2Score,
                        mode: mode,
                      ),

                      // Stick Figures and Animation Area
                      const Expanded(child: StickFigureArea()),

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
                        const SizedBox(height: 120, child: GameHistoryWidget()),
                    ],
                  ),
          ),
          // Confetti layer shown when game ends
          if (gameEnded)
            _GameEndConfetti(
              winner: totalPlayer1Score == totalPlayer2Score
                  ? _Winner.tie
                  : (totalPlayer1Score > totalPlayer2Score
                        ? _Winner.p1
                        : _Winner.p2),
            ),
        ],
      ),
    );
  }
}

// Winner-targeted confetti without external packages
enum _Winner { p1, p2, tie }

class _GameEndConfetti extends StatefulWidget {
  final _Winner winner;
  const _GameEndConfetti({required this.winner});

  @override
  State<_GameEndConfetti> createState() => _GameEndConfettiState();
}

class _GameEndConfettiState extends State<_GameEndConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _ConfettiPainter(
              progress: controller.value,
              winner: widget.winner,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress; // 0..1
  final _Winner winner;
  _ConfettiPainter({required this.progress, required this.winner});

  final List<Color> colors = const [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Emit more pieces from winner side
    int pieces = 140;
    for (int i = 0; i < pieces; i++) {
      final t = i / pieces;

      // Winner side bias
      double startXBias;
      if (winner == _Winner.tie) {
        startXBias = size.width * t;
      } else if (winner == _Winner.p1) {
        // Left-biased
        startXBias = size.width * (t * 0.6);
      } else {
        // Right-biased
        startXBias = size.width * (0.4 + t * 0.6);
      }

      final fall = progress * (size.height + 100);
      final y = -50 + fall + (i % 7) * 12.0;
      final x = startXBias + (i % 5 - 2) * 10.0;

      paint.color = colors[i % colors.length].withOpacity(
        1 - (progress * 0.25),
      );
      final w = 4.0 + (i % 3) * 2.0;
      final h = 8.0 + (i % 4) * 2.0;

      final rect = Rect.fromCenter(center: Offset(x, y), width: w, height: h);
      final r = RRect.fromRectAndRadius(rect, const Radius.circular(1.6));
      canvas.save();
      final angle = (i * 0.45 + progress * 14);
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(angle);
      canvas.translate(-rect.center.dx, -rect.center.dy);
      canvas.drawRRect(r, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.winner != winner;
}

// Performance: Separate score display to avoid unnecessary rebuilds
class _ScoreDisplay extends StatelessWidget {
  final int totalPlayer1Score;
  final int totalPlayer2Score;
  final GameMode mode;

  const _ScoreDisplay({
    required this.totalPlayer1Score,
    required this.totalPlayer2Score,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              const Text(
                'Player 1',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalPlayer1Score',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                mode == GameMode.vsComputer ? 'Computer' : 'Player 2',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$totalPlayer2Score',
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
