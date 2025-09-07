
// Performance: Separate const widgets to avoid rebuilds
import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.purple.shade200],
        ),
      ),
    );
  }
}

class GameEndedOverlay extends StatelessWidget {
  final bool gameEnded;

  const GameEndedOverlay({super.key, required this.gameEnded});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Reduced duration
        curve: Curves.easeInOut, // Simpler curve
        color: gameEnded ? Colors.blueGrey : Colors.transparent,
      ),
    );
  }
}
