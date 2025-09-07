import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums.dart';
import '../../../controller/game_notifier.dart';
import 'simple_animated_prisoner.dart';
import 'stick_figure_area.dart';

class EnhancedPrisonerArea extends ConsumerStatefulWidget {
  const EnhancedPrisonerArea({super.key});

  @override
  ConsumerState<EnhancedPrisonerArea> createState() =>
      _EnhancedPrisonerAreaState();
}

class _EnhancedPrisonerAreaState extends ConsumerState<EnhancedPrisonerArea> {
  bool _showGuard = false;

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final hasRound = gameState.history.isNotEmpty;
    final last = hasRound ? gameState.history.last : null;

    // Determine round reaction per player
    int p1 = last?.player1Score ?? 0;
    int p2 = last?.player2Score ?? 0;

    // Check if both players defected to show guard
    final bothDefected = hasRound
        ? (last!.player1Action == GameAction.defect &&
              last.player2Action == GameAction.defect)
        : false;

    // Trigger guard appearance
    if (bothDefected && !_showGuard) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showGuard = true;
        });
        // Hide guard after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showGuard = false;
            });
          }
        });
      });
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade400,
                  Colors.grey.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.48,
            child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  // Prison title bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.security,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PRISON YARD',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Main prisoner area
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Player 1 Animated Prisoner
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PRISONER 1',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SimpleAnimatedPrisoner(
                              isPlayer1: true,
                              lastAction: hasRound ? last!.player1Action : null,
                              outcome: !hasRound
                                  ? RoundOutcome.none
                                  : (p1 > p2
                                        ? RoundOutcome.win
                                        : (p1 < p2
                                              ? RoundOutcome.lose
                                              : RoundOutcome.tie)),
                              isLeading:
                                  gameState.totalPlayer1Score >
                                  gameState.totalPlayer2Score,
                              bothDefected: hasRound
                                  ? (last!.player1Action == GameAction.defect &&
                                        last.player2Action == GameAction.defect)
                                  : false,
                              isMuted: gameState.isMuted,
                            ),
                          ],
                        ),

                        // Prison bars and VS text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Prison bars
                            Stack(
                              children: [
                                Container(
                                  width: 60,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                      width: 2,
                                    ),
                                  ),
                                  child: CustomPaint(
                                    painter: PrisonBarsPainter(),
                                  ),
                                ),
                                // Guard appears here if both defected
                                Container(
                                  width: 60,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                      width: 2,
                                    ),
                                  ),
                                  child: PrisonGuardWidget(
                                    shouldAppear: _showGuard,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Animated VS text
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.95, end: 1.05),
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOut,
                              builder: (context, value, _) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade700,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'VS',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onEnd: () {},
                            ),
                          ],
                        ),

                        // Player 2/Computer Animated Prisoner
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PRISONER 2',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SimpleAnimatedPrisoner(
                              isPlayer1: false,
                              lastAction: hasRound ? last!.player2Action : null,
                              outcome: !hasRound
                                  ? RoundOutcome.none
                                  : (p2 > p1
                                        ? RoundOutcome.win
                                        : (p2 < p1
                                              ? RoundOutcome.lose
                                              : RoundOutcome.tie)),
                              isLeading:
                                  gameState.totalPlayer2Score >
                                  gameState.totalPlayer1Score,
                              bothDefected: hasRound
                                  ? (last!.player1Action == GameAction.defect &&
                                        last.player2Action == GameAction.defect)
                                  : false,
                              isMuted: gameState.isMuted,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Prison floor
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade600, Colors.grey.shade800],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrisonBarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw vertical bars
    for (int i = 1; i < 6; i++) {
      final x = (size.width / 6) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal bars
    for (int i = 1; i < 8; i++) {
      final y = (size.height / 8) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Enhanced prison guard widget that appears occasionally
class PrisonGuardWidget extends StatefulWidget {
  final bool shouldAppear;

  const PrisonGuardWidget({super.key, this.shouldAppear = false});

  @override
  State<PrisonGuardWidget> createState() => _PrisonGuardWidgetState();
}

class _PrisonGuardWidgetState extends State<PrisonGuardWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _bounceController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(covariant PrisonGuardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shouldAppear && !oldWidget.shouldAppear) {
      _slideController.forward();
      _bounceController.repeat(reverse: true);

      // Auto-hide after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _slideController.reverse();
          _bounceController.stop();
        }
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _bounceAnimation,
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.brown.shade700,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 5,
                offset: const Offset(-2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Guard head
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.pink.shade200,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('👮', style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 5),

              // Guard body
              Container(
                width: 30,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.brown.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              const SizedBox(height: 5),

              // Speech bubble
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(
                  'Order!',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
