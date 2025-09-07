import 'package:flutter/material.dart';

import '../../../core/enums.dart';
import '../viewmodels/confetti_painter.dart';
// Winner-targeted confetti without external packages

class GameEndConfetti extends StatefulWidget {
  final Winner winner;
  const GameEndConfetti({super.key, required this.winner});

  @override
  State<GameEndConfetti> createState() => _GameEndConfettiState();
}

class _GameEndConfettiState extends State<GameEndConfetti>
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
            painter: ConfettiPainter(
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
