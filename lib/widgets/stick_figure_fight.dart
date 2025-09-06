import 'dart:math';

import 'package:flutter/material.dart';

class StickFigureFight extends StatefulWidget {
  @override
  _StickFigureFightState createState() => _StickFigureFightState();
}

class _StickFigureFightState extends State<StickFigureFight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: FightPainter(_controller),
      size: Size.infinite,
    );
  }
}

class FightPainter extends CustomPainter {
  final Animation<double> animation;

  FightPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // Figure 1
    final figure1X = size.width * 0.25;
    final figure1Y = size.height * 0.5;
    drawStickFigure(canvas, paint, figure1X, figure1Y, animation.value, true);

    // Figure 2
    final figure2X = size.width * 0.75;
    final figure2Y = size.height * 0.5;
    drawStickFigure(canvas, paint, figure2X, figure2Y, animation.value, false);
  }

  void drawStickFigure(Canvas canvas, Paint paint, double x, double y,
      double animationValue, bool isFigure1) {
    // Head
    canvas.drawCircle(Offset(x, y - 50), 20, paint);

    // Body
    canvas.drawLine(Offset(x, y - 30), Offset(x, y + 30), paint);

    // Arms
    final armAngle = sin(animationValue * 2 * pi);
    final armY = y - 10;
    if (isFigure1) {
      // Right Arm (attacking)
      canvas.drawLine(
          Offset(x, armY), Offset(x + 30, armY - 30 * armAngle), paint);
      // Sword
      drawSword(canvas, paint, x + 30, armY - 30 * armAngle);
      // Left Arm (defending)
      canvas.drawLine(Offset(x, armY), Offset(x - 20, armY + 10), paint);
    } else {
      // Left Arm (attacking)
      canvas.drawLine(
          Offset(x, armY), Offset(x - 30, armY - 30 * armAngle), paint);
      // Sword
      drawSword(canvas, paint, x - 30, armY - 30 * armAngle);
      // Right Arm (defending)
      canvas.drawLine(Offset(x, armY), Offset(x + 20, armY + 10), paint);
    }

    // Legs
    canvas.drawLine(Offset(x, y + 30), Offset(x - 20, y + 70), paint);
    canvas.drawLine(Offset(x, y + 30), Offset(x + 20, y + 70), paint);
  }

  void drawSword(Canvas canvas, Paint paint, double x, double y) {
    final swordPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3;
    final handlePaint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 4;

    // Blade
    canvas.drawLine(Offset(x, y), Offset(x + 40, y - 40), swordPaint);
    // Handle
    canvas.drawLine(Offset(x - 5, y + 5), Offset(x + 5, y - 5), handlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}