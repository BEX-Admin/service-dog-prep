import 'package:flutter/material.dart';

class RegressionScreen extends StatelessWidget {
  const RegressionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jump Back In / Regression')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('If training was paused or behavior regressed:'),
          SizedBox(height: 12),
          Text('• Review recent external factors (health, schedule changes, stress)'),
          Text('• Re-test foundation skills'),
          Text('• Shorten sessions and rebuild confidence'),
          Text('• Focus on opportunity errors from the last successful period'),
          SizedBox(height: 16),
          Text('This helps the dog re-enter the program without frustration.'),
        ],
      ),
    );
  }
}
