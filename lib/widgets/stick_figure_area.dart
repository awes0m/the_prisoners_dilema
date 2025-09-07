import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import '../common/enums.dart';
import '../repository/game_notifier.dart';

// Respect mute toggle
bool _shouldPlay(WidgetRef ref) => !ref.read(gameProvider).isMuted;

// Shared audio player for short SFX
final AudioPlayer _sfx = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

Future<void> _playSfx(String assetPath) async {
  try {
    // Avoid overlapping sounds
    await _sfx.stop();
    await _sfx.play(AssetSource(assetPath));
  } catch (_) {
    // Swallow errors; non-critical UX feature
  }
}

class StickFigureArea extends ConsumerWidget {
  const StickFigureArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final hasRound = gameState.history.isNotEmpty;
    final last = hasRound ? gameState.history.last : null;

    // Determine round reaction per player
    int p1 = last?.player1Score ?? 0;
    int p2 = last?.player2Score ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Player 1 Stick Figure
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StickFigure(
                isPlayer1: true,
                lastAction: hasRound ? last!.player1Action : null,
                outcome: !hasRound
                    ? RoundOutcome.none
                    : (p1 > p2
                          ? RoundOutcome.win
                          : (p1 < p2 ? RoundOutcome.lose : RoundOutcome.tie)),
                isLeading:
                    gameState.totalPlayer1Score > gameState.totalPlayer2Score,
                bothDefected: hasRound
                    ? (last!.player1Action == GameAction.defect &&
                          last.player2Action == GameAction.defect)
                    : false,
                isMuted: gameState.isMuted,
              ),
              const SizedBox(height: 10),
              const Text(
                'Player 1',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // VS Text with subtle breathing animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.95, end: 1.05),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, value, _) {
              return Transform.scale(
                scale: value,
                child: Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 2,
                  ),
                ),
              );
            },
            onEnd: () {},
          ),

          // Player 2/Computer Stick Figure
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StickFigure(
                isPlayer1: false,
                lastAction: hasRound ? last!.player2Action : null,
                outcome: !hasRound
                    ? RoundOutcome.none
                    : (p2 > p1
                          ? RoundOutcome.win
                          : (p2 < p1 ? RoundOutcome.lose : RoundOutcome.tie)),
                isLeading:
                    gameState.totalPlayer2Score > gameState.totalPlayer1Score,
                bothDefected: hasRound
                    ? (last!.player1Action == GameAction.defect &&
                          last.player2Action == GameAction.defect)
                    : false,
                isMuted: gameState.isMuted,
              ),
              const SizedBox(height: 10),
              Text(
                gameState.mode == GameMode.vsComputer ? 'Computer' : 'Player 2',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum RoundOutcome { none, win, lose, tie }

class StickFigure extends StatefulWidget {
  final bool isPlayer1;
  final GameAction? lastAction;
  final RoundOutcome outcome;
  final bool isLeading; // for subtle glow if leading
  final bool bothDefected; // trigger swoop animation when both defect
  final bool isMuted; // respect mute toggle for SFX

  const StickFigure({
    super.key,
    required this.isPlayer1,
    this.lastAction,
    this.outcome = RoundOutcome.none,
    this.isLeading = false,
    this.bothDefected = false,
    this.isMuted = false,
  });

  @override
  State<StickFigure> createState() => _StickFigureState();
}

class _StickFigureState extends State<StickFigure>
    with TickerProviderStateMixin {
  late AnimationController pulseController; // cooperate bounce
  late AnimationController shakeController; // defect shake
  late AnimationController emojiController; // emoji pop
  late AnimationController swoopController; // both defect swoop

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    emojiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    swoopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void didUpdateWidget(covariant StickFigure oldWidget) {
    super.didUpdateWidget(oldWidget);
    final actionChanged =
        widget.lastAction != null && widget.lastAction != oldWidget.lastAction;
    if (actionChanged) {
      if (widget.lastAction == GameAction.cooperate) {
        pulseController
          ..reset()
          ..forward();
        if (!widget.isMuted) {
          _playSfx('sfx/chime.mp3');
        }
      } else if (widget.lastAction == GameAction.defect) {
        shakeController
          ..reset()
          ..forward();
        if (!widget.isMuted) {
          _playSfx('sfx/disagree.wav');
        }
      }
      // Emoji reaction always triggers on new action
      emojiController
        ..reset()
        ..forward();

      // Trigger swoop if both defect
      if (widget.bothDefected) {
        swoopController
          ..reset()
          ..forward();
      }
    }
  }

  @override
  void dispose() {
    pulseController.dispose();
    shakeController.dispose();
    emojiController.dispose();
    swoopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isPlayer1 ? Colors.blue : Colors.red;

    final pulse = Tween(
      begin: 1.0,
      end: 1.12,
    ).chain(CurveTween(curve: Curves.elasticOut)).animate(pulseController);

    final shake = Tween(
      begin: -6.0,
      end: 6.0,
    ).chain(CurveTween(curve: Curves.elasticInOut)).animate(shakeController);

    final emojiOpacity = Tween(
      begin: 0.0,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(emojiController);

    final emojiOffset = Tween(
      begin: const Offset(0, 0.0),
      end: const Offset(0, -0.8),
    ).chain(CurveTween(curve: Curves.easeOut)).animate(emojiController);

    final glowColor = widget.isLeading
        ? (widget.isPlayer1 ? Colors.blueAccent : Colors.redAccent)
        : (widget.outcome == RoundOutcome.win
              ? Colors.greenAccent
              : (widget.outcome == RoundOutcome.lose
                    ? Colors.redAccent
                    : Colors.transparent));

    // Choose emoji per outcome/action
    String emoji;
    if (widget.outcome == RoundOutcome.win) {
      emoji = '🎉';
    } else if (widget.outcome == RoundOutcome.lose) {
      emoji = '😵';
    } else if (widget.lastAction == GameAction.cooperate) {
      emoji = '😊';
    } else if (widget.lastAction == GameAction.defect) {
      emoji = '😠';
    } else {
      emoji = '';
    }

    return AnimatedBuilder(
      animation: Listenable.merge([
        pulseController,
        shakeController,
        emojiController,
        swoopController,
      ]),
      builder: (context, child) {
        final scale = 1.0 * (pulseController.isAnimating ? pulse.value : 1.0);
        final dx = shakeController.isAnimating ? shake.value : 0.0;

        // Swoop towards center if both defected (lean in slightly)
        final swoop = Tween(begin: 0.0, end: widget.isPlayer1 ? 10.0 : -10.0)
            .chain(CurveTween(curve: Curves.easeOutCubic))
            .animate(swoopController);

        return Container(
          width: 120,
          height: 140,
          decoration: BoxDecoration(
            boxShadow: [
              if (glowColor != Colors.transparent)
                BoxShadow(
                  color: glowColor.withOpacity(0.35),
                  blurRadius: 18,
                  spreadRadius: 4,
                ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Floating emoji reaction
              if (emoji.isNotEmpty)
                Positioned(
                  top: 0,
                  left: 45,
                  child: FadeTransition(
                    opacity: emojiOpacity,
                    child: SlideTransition(
                      position: emojiOffset,
                      child: Text(emoji, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              // Figure
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(
                    dx + (widget.bothDefected ? swoop.value : 0),
                    0,
                  ),
                  child: Transform.rotate(
                    angle: widget.bothDefected
                        ? (widget.isPlayer1 ? -0.06 : 0.06) *
                              (swoopController.value)
                        : 0,
                    child: Transform.scale(
                      scale: scale,
                      child: CustomPaint(
                        painter: StickFigurePainter(
                          action: widget.lastAction,
                          color: color,
                          outcome: widget.outcome,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class StickFigurePainter extends CustomPainter {
  final GameAction? action;
  final Color color;
  final RoundOutcome outcome;

  StickFigurePainter({
    this.action,
    required this.color,
    this.outcome = RoundOutcome.none,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Head
    final headCenter = Offset(center.dx, center.dy - 35);
    canvas.drawCircle(headCenter, 15, paint);

    // Simple facial expression depending on action/outcome
    final mouthPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Eyes
    canvas.drawCircle(
      Offset(headCenter.dx - 5, headCenter.dy - 4),
      1.2,
      mouthPaint,
    );
    canvas.drawCircle(
      Offset(headCenter.dx + 5, headCenter.dy - 4),
      1.2,
      mouthPaint,
    );

    // Mouth
    if (outcome == RoundOutcome.win || action == GameAction.cooperate) {
      // smile
      final smileRect = Rect.fromCircle(
        center: Offset(headCenter.dx, headCenter.dy + 2),
        radius: 6,
      );
      canvas.drawArc(smileRect, 0, 3.14, false, mouthPaint);
    } else if (outcome == RoundOutcome.lose || action == GameAction.defect) {
      // frown
      final frownRect = Rect.fromCircle(
        center: Offset(headCenter.dx, headCenter.dy + 8),
        radius: 6,
      );
      canvas.drawArc(frownRect, 3.14, 3.14, false, mouthPaint);
    } else {
      // neutral
      canvas.drawLine(
        Offset(headCenter.dx - 5, headCenter.dy + 6),
        Offset(headCenter.dx + 5, headCenter.dy + 6),
        mouthPaint,
      );
    }

    // Body
    canvas.drawLine(
      Offset(center.dx, center.dy - 20),
      Offset(center.dx, center.dy + 20),
      paint,
    );

    // Arms based on action
    if (action == GameAction.cooperate) {
      // Cooperative gesture - arms open
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx - 25, center.dy - 5),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx + 25, center.dy - 5),
        paint,
      );
    } else if (action == GameAction.defect) {
      // Defective gesture - arms crossed/pointing
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx - 20, center.dy + 5),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx + 20, center.dy + 5),
        paint,
      );
    } else {
      // Default arms
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx - 20, center.dy),
        paint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx + 20, center.dy),
        paint,
      );
    }

    // Legs
    canvas.drawLine(
      Offset(center.dx, center.dy + 20),
      Offset(center.dx - 15, center.dy + 45),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 20),
      Offset(center.dx + 15, center.dy + 45),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
