import 'package:flutter/material.dart';

class TricksScreen extends StatelessWidget {
  const TricksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bonus Tricks')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Optional fun after training sessions:'),
          SizedBox(height: 12),
          Text('• Spin'),
          Text('• High five'),
          Text('• Play bow'),
          Text('• Weave between legs'),
          SizedBox(height: 16),
          Text('Tricks are never required for the training plan.'),
        ],
      ),
    );
  }
}
