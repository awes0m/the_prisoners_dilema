import 'package:flutter/material.dart';

import '../../../core/enums.dart';

class ConfettiPainter extends CustomPainter {
  final double progress; // 0..1
  final Winner winner;
  ConfettiPainter({required this.progress, required this.winner});

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
      if (winner == Winner.tie) {
        startXBias = size.width * t;
      } else if (winner == Winner.p1) {
        // Left-biased
        startXBias = size.width * (t * 0.6);
      } else {
        // Right-biased
        startXBias = size.width * (0.4 + t * 0.6);
      }

      final fall = progress * (size.height + 100);
      final y = -50 + fall + (i % 7) * 12.0;
      final x = startXBias + (i % 5 - 2) * 10.0;

      paint.color = colors[i % colors.length].withValues(
        alpha: 1 - (progress * 0.25),
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
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.winner != winner;
}
