import 'package:flutter/material.dart';

import '../../../common/app_bar.dart';
import 'strategy_guide_screen.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'How to Play',
        backgroundColor: Colors.orange[800],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage
                        ? Colors.orange
                        : Colors.grey[300],
                  ),
                );
              }),
            ),
          ),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildIntroPage(),
                _buildBasicRulesPage(),
                _buildPayoffPage(),
                _buildStrategyIntroPage(),
                _buildGameModesPage(),
                _buildTipsPage(),
              ],
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  child: Text('Previous'),
                ),
                Text('${_currentPage + 1} of $_totalPages'),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _totalPages - 1) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    _currentPage == _totalPages - 1 ? 'Got It!' : 'Next',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.psychology, size: 80, color: Colors.orange),
          SizedBox(height: 20),
          Text(
            'Welcome to the Prisoner\'s Dilemma!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'The Prisoner\'s Dilemma is one of the most famous problems in game theory. It explores the tension between cooperation and self-interest.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Text(
                  '🏛️ The Story',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Two prisoners are arrested and held separately. They can either cooperate with each other (stay silent) or defect (betray the other). The outcome depends on what both choose!',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicRulesPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '🎯 Basic Rules',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildRuleCard(
            icon: '🤝',
            title: 'Cooperate',
            description:
                'Work together with your opponent. This shows trust and can lead to mutual benefit.',
            color: Colors.green,
          ),
          SizedBox(height: 20),
          _buildRuleCard(
            icon: '⚔️',
            title: 'Defect',
            description:
                'Betray your opponent for personal gain. This might get you more points but at their expense.',
            color: Colors.red,
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.yellow[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.orange, size: 30),
                SizedBox(height: 10),
                Text(
                  'Key Insight',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Both players choose simultaneously without knowing what the other will do. This creates the dilemma!',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoffPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '📊 How Scoring Works',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'Points are awarded based on both players\' choices:',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildOutcomeCard(
            '🤝 🤝',
            'Both Cooperate',
            '3 points each',
            'The "reward" - mutual benefit',
            Colors.green[100]!,
          ),
          SizedBox(height: 15),
          _buildOutcomeCard(
            '⚔️ ⚔️',
            'Both Defect',
            '1 point each',
            'The "punishment" - mutual loss',
            Colors.grey[300]!,
          ),
          SizedBox(height: 15),
          _buildOutcomeCard(
            '🤝 ⚔️',
            'You Cooperate, Opponent Defects',
            '0 vs 5 points',
            'You\'re the "sucker"',
            Colors.red[100]!,
          ),
          SizedBox(height: 15),
          _buildOutcomeCard(
            '⚔️ 🤝',
            'You Defect, Opponent Cooperates',
            '5 vs 0 points',
            'The "temptation" to betray',
            Colors.orange[100]!,
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              '🎲 The Dilemma: While mutual cooperation gives good points (3,3), you\'re tempted to defect for even more (5), but risk getting nothing if you both defect (1,1)!',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyIntroPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '🧠 Strategy Matters!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            'In repeated games, your strategy determines long-term success:',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildStrategyPreviewCard(
            'Tit for Tat',
            'Start nice, then copy opponent',
            '✅ Simple and effective\n❌ Can get stuck in revenge cycles',
            Colors.blue[100]!,
          ),
          SizedBox(height: 15),
          _buildStrategyPreviewCard(
            'Always Cooperate',
            'Trust everyone, always',
            '✅ Maximizes mutual cooperation\n❌ Easily exploited',
            Colors.green[100]!,
          ),
          SizedBox(height: 15),
          _buildStrategyPreviewCard(
            'Grudger',
            'Cooperate until betrayed once',
            '✅ Punishes defectors\n❌ Never forgives',
            Colors.red[100]!,
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StrategyPage()),
              );
            },
            icon: Icon(Icons.library_books),
            label: Text('View All Strategies'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildGameModesPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '🎮 Game Modes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildModeCard(
            icon: Icons.computer,
            title: 'VS Computer',
            description:
                'Play against AI with different strategies. Great for learning and testing your approach!',
            features: [
              '• Choose from 10 AI strategies',
              '• Different difficulty levels',
              '• Learn strategy patterns',
            ],
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          _buildModeCard(
            icon: Icons.people,
            title: 'VS Human',
            description:
                'Play with a friend locally. Both players choose their moves on the same device.',
            features: [
              '• Local multiplayer',
              '• Secret simultaneous choices',
              '• Perfect for discussions!',
            ],
            color: Colors.purple,
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Column(
              children: [
                Text(
                  '🏆 Win Conditions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'First to 50 points wins, or highest score after 20 rounds!',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            '💡 Pro Tips',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          _buildTipCard(
            '🤔',
            'Think Long-term',
            'One betrayal might win a round, but it can cost you the game if your opponent retaliates.',
          ),
          _buildTipCard(
            '🔄',
            'Watch Patterns',
            'Pay attention to your opponent\'s strategy. Are they copying you? Always defecting? Adjust accordingly!',
          ),
          _buildTipCard(
            '🕊️',
            'Be Forgiving',
            'Sometimes cooperating after being betrayed can break cycles of mutual defection.',
          ),
          _buildTipCard(
            '⚖️',
            'Balance Risk',
            'Pure cooperation is exploitable, but pure defection often backfires. Find the right balance!',
          ),
          _buildTipCard(
            '📚',
            'Study Strategies',
            'Check out the Strategy Guide to understand different approaches and their strengths/weaknesses.',
          ),
          SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange[400]!, Colors.orange[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.play_arrow, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'Ready to Play?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Now you know the rules! Start with VS Computer to practice, then challenge your friends.',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleCard({
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(icon, style: TextStyle(fontSize: 40)),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOutcomeCard(
    String icons,
    String title,
    String points,
    String description,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icons, style: TextStyle(fontSize: 24)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      points,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyPreviewCard(
    String name,
    String behavior,
    String analysis,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            behavior,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Text(analysis, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> features,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 30),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(description, style: TextStyle(fontSize: 14)),
          SizedBox(height: 12),
          ...features.map(
            (feature) => Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: Text(
                feature,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String icon, String title, String description) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: TextStyle(fontSize: 24)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(description, style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
