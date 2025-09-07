import 'package:flutter/material.dart';

class PayoffMatrixDialog extends StatelessWidget {
  const PayoffMatrixDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Payoff Matrix'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Points earned for each outcome:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    _buildTableCell('', isHeader: true),
                    _buildTableCell('Opponent\nCooperates', isHeader: true),
                    _buildTableCell('Opponent\nDefects', isHeader: true),
                  ],
                ),
                TableRow(
                  children: [
                    _buildTableCell('You\nCooperate', isHeader: true),
                    _buildTableCell(
                      '3, 3\n🤝🤝\nReward',
                      color: Colors.green[100],
                    ),
                    _buildTableCell(
                      '0, 5\n🤝⚔️\nSucker',
                      color: Colors.red[100],
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    _buildTableCell('You\nDefect', isHeader: true),
                    _buildTableCell(
                      '5, 0\n⚔️🤝\nTemptation',
                      color: Colors.orange[100],
                    ),
                    _buildTableCell(
                      '1, 1\n⚔️⚔️\nPunishment',
                      color: Colors.grey[200],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Format: (Your points, Opponent\'s points)',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            Text(
              'Temptation > Reward > Punishment > Sucker\n5 > 3 > 1 > 0',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close'),
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, Color? color}) {
    return Container(
      padding: EdgeInsets.all(8),
      color: color,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 12 : 14,
        ),
      ),
    );
  }
}
