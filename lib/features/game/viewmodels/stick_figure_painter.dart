import 'package:flutter/material.dart';

import '../../../core/enums.dart';
import '../widgets/stick_figure_area.dart';

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
