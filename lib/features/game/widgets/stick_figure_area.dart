import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/audio_manager.dart';
import '../../../core/enums.dart';
import '../../../controller/game_notifier.dart';
import '../viewmodels/stick_figure_painter.dart';

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
        audioManager.playSfx('sfx/chime.mp3', widget.isMuted);
      } else if (widget.lastAction == GameAction.defect) {
        shakeController
          ..reset()
          ..forward();
        audioManager.playSfx('sfx/disagree.wav', widget.isMuted);
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
                  color: glowColor.withValues(alpha: 0.35),
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
