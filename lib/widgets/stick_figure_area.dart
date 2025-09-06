import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/enums.dart';
import '../repository/game_notifier.dart';

class StickFigureArea extends ConsumerWidget {
  const StickFigureArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Player 1 Stick Figure
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StickFigure(
                isPlayer1: true,
                lastAction: gameState.history.isNotEmpty
                    ? gameState.history.last.player1Action
                    : null,
              ),
              SizedBox(height: 10),
              Text(
                'Player 1',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // VS Text
          Text(
            'VS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),

          // Player 2/Computer Stick Figure
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StickFigure(
                isPlayer1: false,
                lastAction: gameState.history.isNotEmpty
                    ? gameState.history.last.player2Action
                    : null,
              ),
              SizedBox(height: 10),
              Text(
                gameState.mode == GameMode.vsComputer ? 'Computer' : 'Player 2',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StickFigure extends StatefulWidget {
  final bool isPlayer1;
  final GameAction? lastAction;

  const StickFigure({super.key, required this.isPlayer1, this.lastAction});

  @override
  State<StickFigure> createState() => _StickFigureState();
}

class _StickFigureState extends State<StickFigure>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(StickFigure oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lastAction != oldWidget.lastAction &&
        widget.lastAction != null) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_animation.value * 0.2),
          child: SizedBox(
            width: 100,
            height: 120,
            child: CustomPaint(
              painter: StickFigurePainter(
                action: widget.lastAction,
                color: widget.isPlayer1 ? Colors.blue : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class StickFigurePainter extends CustomPainter {
  final GameAction? action;
  final Color color;

  StickFigurePainter({this.action, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Head
    canvas.drawCircle(Offset(center.dx, center.dy - 35), 15, paint);

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

      // Draw handshake symbol
      final textPainter = TextPainter(
        text: TextSpan(text: '🤝', style: TextStyle(fontSize: 20)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(center.dx - 10, center.dy - 60));
    } else if (action == GameAction.defect) {
      // Defective gesture - arms crossed or pointing
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

      // Draw sword symbol
      final textPainter = TextPainter(
        text: TextSpan(text: '⚔️', style: TextStyle(fontSize: 20)),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(center.dx - 10, center.dy - 60));
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
