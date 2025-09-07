import 'package:flutter/material.dart';
import '../../../common/common.dart';

import '../../../core/strategy_list.dart';
import '../../game/widgets/pay_off_matrix.dart';

class StrategyPage extends StatelessWidget {
  const StrategyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Strategy Guide',
        backgroundColor: Colors.green[800],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: strategies.length,
        itemBuilder: (context, index) {
          final strategy = strategies[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ExpansionTile(
              title: Text(
                strategy['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                strategy['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Behavior:', strategy['behavior']),
                      SizedBox(height: 8),
                      _buildInfoRow('Strength:', strategy['strength']),
                      SizedBox(height: 8),
                      _buildInfoRow('Weakness:', strategy['weakness']),
                      SizedBox(height: 8),
                      _buildInfoRow('Example:', strategy['example']),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => PayoffMatrixDialog(),
          );
        },
        label: Text('Payoff Matrix'),
        icon: Icon(Icons.table_chart),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(width: 8),
        Expanded(child: Text(value, style: TextStyle(fontSize: 14))),
      ],
    );
  }
}
