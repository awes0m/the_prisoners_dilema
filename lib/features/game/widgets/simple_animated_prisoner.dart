import 'package:flutter/material.dart';

import '../../../common/audio_manager.dart';
import '../../../core/enums.dart';
import 'stick_figure_area.dart';

class SimpleAnimatedPrisoner extends StatefulWidget {
  final bool isPlayer1;
  final GameAction? lastAction;
  final RoundOutcome outcome;
  final bool isLeading;
  final bool bothDefected;
  final bool isMuted;

  const SimpleAnimatedPrisoner({
    super.key,
    required this.isPlayer1,
    this.lastAction,
    this.outcome = RoundOutcome.none,
    this.isLeading = false,
    this.bothDefected = false,
    this.isMuted = false,
  });

  @override
  State<SimpleAnimatedPrisoner> createState() => _SimpleAnimatedPrisonerState();
}

class _SimpleAnimatedPrisonerState extends State<SimpleAnimatedPrisoner>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _shakeController;
  late AnimationController _emotionController;
  late AnimationController _glowController;
  late AnimationController _breathingController;
  late AnimationController _leanController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<Offset> _emotionSlideAnimation;
  late Animation<double> _emotionOpacityAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _leanAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _emotionController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _leanController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _shakeAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
    );

    _emotionSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, -1.5),
        ).animate(
          CurvedAnimation(parent: _emotionController, curve: Curves.easeOut),
        );

    _emotionOpacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _emotionController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _breathingAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _leanAnimation = Tween<double>(
      begin: 0.0,
      end: widget.isPlayer1 ? -0.1 : 0.1,
    ).animate(CurvedAnimation(parent: _leanController, curve: Curves.easeOut));

    // Start breathing animation
    _breathingController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant SimpleAnimatedPrisoner oldWidget) {
    super.didUpdateWidget(oldWidget);

    final actionChanged =
        widget.lastAction != null && widget.lastAction != oldWidget.lastAction;

    if (actionChanged) {
      _triggerActionAnimation();
      _triggerEmotionAnimation();

      if (widget.bothDefected) {
        _triggerLeanAnimation();
      }
    }

    if (widget.isLeading != oldWidget.isLeading ||
        widget.outcome != oldWidget.outcome) {
      _triggerGlowAnimation();
    }
  }

  void _triggerActionAnimation() {
    if (widget.lastAction == GameAction.cooperate) {
      _bounceController.reset();
      _bounceController.forward();
      audioManager.playSfx('sfx/chime.mp3', widget.isMuted);
    } else if (widget.lastAction == GameAction.defect) {
      _shakeController.reset();
      _shakeController.forward();
      audioManager.playSfx('sfx/disagree.wav', widget.isMuted);
    }
  }

  void _triggerEmotionAnimation() {
    _emotionController.reset();
    _emotionController.forward();
  }

  void _triggerGlowAnimation() {
    _glowController.reset();
    _glowController.forward();
  }

  void _triggerLeanAnimation() {
    _leanController.reset();
    _leanController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _leanController.reverse();
        }
      });
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _shakeController.dispose();
    _emotionController.dispose();
    _glowController.dispose();
    _breathingController.dispose();
    _leanController.dispose();
    super.dispose();
  }

  String _getEmoji() {
    if (widget.outcome == RoundOutcome.win) {
      return '🎉';
    } else if (widget.outcome == RoundOutcome.lose) {
      return '😵';
    } else if (widget.lastAction == GameAction.cooperate) {
      return '😊';
    } else if (widget.lastAction == GameAction.defect) {
      return '😠';
    }
    return '';
  }

  Color _getGlowColor() {
    if (widget.isLeading) {
      return widget.isPlayer1 ? Colors.blueAccent : Colors.redAccent;
    } else if (widget.outcome == RoundOutcome.win) {
      return Colors.greenAccent;
    } else if (widget.outcome == RoundOutcome.lose) {
      return Colors.redAccent;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final prisonerColor = widget.isPlayer1 ? Colors.blue : Colors.red;
    final emoji = _getEmoji();
    final glowColor = _getGlowColor();

    return AnimatedBuilder(
      animation: Listenable.merge([
        _bounceController,
        _shakeController,
        _emotionController,
        _glowController,
        _breathingController,
        _leanController,
      ]),
      builder: (context, child) {
        final scale =
            _breathingAnimation.value *
            (_bounceController.isAnimating ? _bounceAnimation.value : 1.0);
        final dx = _shakeController.isAnimating ? _shakeAnimation.value : 0.0;
        final rotation = _leanController.isAnimating
            ? _leanAnimation.value
            : 0.0;

        return Container(
          width: 120,
          height: 140,
          decoration: BoxDecoration(
            boxShadow: glowColor != Colors.transparent
                ? [
                    BoxShadow(
                      color: glowColor.withValues(
                        alpha: 0.4 * _glowAnimation.value,
                      ),
                      blurRadius: 20,
                      spreadRadius: 6,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Floating emoji
              if (emoji.isNotEmpty)
                Positioned(
                  top: 10,
                  left: 45,
                  child: SlideTransition(
                    position: _emotionSlideAnimation,
                    child: FadeTransition(
                      opacity: _emotionOpacityAnimation,
                      child: Text(emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                ),

              // Animated prisoner
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(dx, 0),
                  child: Transform.rotate(
                    angle: rotation,
                    child: Transform.scale(
                      scale: scale,
                      child: CustomPaint(
                        painter: AnimatedPrisonerPainter(
                          action: widget.lastAction,
                          color: prisonerColor,
                          outcome: widget.outcome,
                          animationProgress: _bounceController.value,
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

class AnimatedPrisonerPainter extends CustomPainter {
  final GameAction? action;
  final Color color;
  final RoundOutcome outcome;
  final double animationProgress;

  AnimatedPrisonerPainter({
    this.action,
    required this.color,
    this.outcome = RoundOutcome.none,
    this.animationProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Prison uniform body (filled rectangle)
    final uniformPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final uniformRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 5),
        width: 35,
        height: 50,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(uniformRect, uniformPaint);

    // Prison stripes
    final stripePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2;

    for (int i = 0; i < 4; i++) {
      final y = center.dy - 15 + (i * 10);
      canvas.drawLine(
        Offset(center.dx - 15, y),
        Offset(center.dx + 15, y),
        stripePaint,
      );
    }

    // Head with prison cap
    final headCenter = Offset(center.dx, center.dy - 35);

    // Head
    final headPaint = Paint()
      ..color = Colors.pink.shade200
      ..style = PaintingStyle.fill;
    canvas.drawCircle(headCenter, 18, headPaint);

    // Prison cap
    final capPaint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: headCenter, radius: 18),
      -3.14,
      3.14,
      false,
      capPaint,
    );

    // Facial expression
    final facePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Eyes
    canvas.drawCircle(
      Offset(headCenter.dx - 6, headCenter.dy - 4),
      1.5,
      Paint()..color = Colors.black,
    );
    canvas.drawCircle(
      Offset(headCenter.dx + 6, headCenter.dy - 4),
      1.5,
      Paint()..color = Colors.black,
    );

    // Mouth based on action/outcome
    if (outcome == RoundOutcome.win || action == GameAction.cooperate) {
      // Smile
      final smileRect = Rect.fromCircle(
        center: Offset(headCenter.dx, headCenter.dy + 4),
        radius: 8,
      );
      canvas.drawArc(smileRect, 0, 3.14, false, facePaint);
    } else if (outcome == RoundOutcome.lose || action == GameAction.defect) {
      // Frown
      final frownRect = Rect.fromCircle(
        center: Offset(headCenter.dx, headCenter.dy + 12),
        radius: 8,
      );
      canvas.drawArc(frownRect, 3.14, 3.14, false, facePaint);
    } else {
      // Neutral
      canvas.drawLine(
        Offset(headCenter.dx - 6, headCenter.dy + 8),
        Offset(headCenter.dx + 6, headCenter.dy + 8),
        facePaint,
      );
    }

    // Arms with handcuffs
    final armPaint = Paint()
      ..color = Colors.pink.shade200
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    if (action == GameAction.cooperate) {
      // Open arms gesture
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx - 30, center.dy - 5),
        armPaint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx + 30, center.dy - 5),
        armPaint,
      );
    } else if (action == GameAction.defect) {
      // Crossed arms (defensive)
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx - 25, center.dy + 5),
        armPaint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx + 25, center.dy + 5),
        armPaint,
      );
    } else {
      // Default arms
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx - 22, center.dy),
        armPaint,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - 10),
        Offset(center.dx + 22, center.dy),
        armPaint,
      );
    }

    // Handcuffs
    final handcuffPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(center.dx - 22, center.dy), 4, handcuffPaint);
    canvas.drawCircle(Offset(center.dx + 22, center.dy), 4, handcuffPaint);
    canvas.drawLine(
      Offset(center.dx - 22, center.dy),
      Offset(center.dx + 22, center.dy),
      handcuffPaint,
    );

    // Legs with shackles
    final legPaint = Paint()
      ..color = Colors.pink.shade200
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(center.dx, center.dy + 20),
      Offset(center.dx - 18, center.dy + 50),
      legPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 20),
      Offset(center.dx + 18, center.dy + 50),
      legPaint,
    );

    // Ankle shackles
    final shacklePaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(center.dx - 18, center.dy + 45), 3, shacklePaint);
    canvas.drawCircle(Offset(center.dx + 18, center.dy + 45), 3, shacklePaint);
    canvas.drawLine(
      Offset(center.dx - 18, center.dy + 45),
      Offset(center.dx + 18, center.dy + 45),
      shacklePaint,
    );

    // Prison number on chest
    final numberPaint = TextPainter(
      text: TextSpan(
        text: action == GameAction.cooperate ? '001' : '666',
        style: TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    numberPaint.layout();
    numberPaint.paint(
      canvas,
      Offset(center.dx - numberPaint.width / 2, center.dy - 5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
