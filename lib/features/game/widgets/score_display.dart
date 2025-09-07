// Performance: Separate score display to avoid unnecessary rebuilds
import 'package:flutter/material.dart';

import '../../../core/enums.dart';

class ScoreDisplay extends StatelessWidget {
  final int totalPlayer1Score;
  final int totalPlayer2Score;
  final GameMode mode;

  const ScoreDisplay({super.key, 
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
