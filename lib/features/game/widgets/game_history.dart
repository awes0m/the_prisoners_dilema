import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums.dart';
import '../../../controller/game_notifier.dart';

class GameHistoryWidget extends ConsumerWidget {
  const GameHistoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    ScrollController scrollController = ScrollController();

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Expanded(
        child: Scrollbar(
          interactive: true,
          controller: scrollController,
          thickness: 8,
          radius: const Radius.circular(5.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            itemCount: gameState.history.length,
            itemBuilder: (context, index) {
              final result = gameState.history[index];
              return Container(
                margin: EdgeInsets.only(right: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'R${index + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          result.player1Action == GameAction.cooperate
                              ? '🤝'
                              : '⚔️',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(' vs ', style: TextStyle(fontSize: 10)),
                        Text(
                          result.player2Action == GameAction.cooperate
                              ? '🤝'
                              : '⚔️',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Text(
                      '${result.player1Score}-${result.player2Score}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
