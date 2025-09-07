import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums.dart';
import '../../../controller/game_notifier.dart';

class SinglePlayerControls extends ConsumerWidget {
  const SinglePlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ref.read(gameProvider.notifier).playRound(GameAction.cooperate);
          },
          icon: Text('🤝', style: TextStyle(fontSize: 20)),
          label: Text('Cooperate'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(gameProvider.notifier).playRound(GameAction.defect);
          },
          icon: Text('⚔️', style: TextStyle(fontSize: 20)),
          label: Text('Defect'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ],
    );
  }
}


class TwoPlayerControls extends ConsumerStatefulWidget {
  const TwoPlayerControls({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TwoPlayerControlsState();
}

class _TwoPlayerControlsState extends ConsumerState<TwoPlayerControls> {
  GameAction? player1Action;
  GameAction? player2Action;

  void _submitActions() {
    if (player1Action != null && player2Action != null) {
      ref.read(gameProvider.notifier).playRound(player1Action!, player2Action!);
      setState(() {
        player1Action = null;
        player2Action = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('Player 1 Choice:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() => player1Action = GameAction.cooperate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: player1Action == GameAction.cooperate
                              ? Colors.green
                              : Colors.grey,
                        ),
                        child: Text('🤝'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => player1Action = GameAction.defect),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: player1Action == GameAction.defect
                              ? Colors.red
                              : Colors.grey,
                        ),
                        child: Text('⚔️'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  Text('Player 2 Choice:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() => player2Action = GameAction.cooperate),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: player2Action == GameAction.cooperate
                              ? Colors.green
                              : Colors.grey,
                        ),
                        child: Text('🤝'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => player2Action = GameAction.defect),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: player2Action == GameAction.defect
                              ? Colors.red
                              : Colors.grey,
                        ),
                        child: Text('⚔️'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: player1Action != null && player2Action != null ? _submitActions : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: Text('Submit Round'),
        ),
      ],
    );
  }
}
