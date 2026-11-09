import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class WeeklyEvalScreen extends StatelessWidget {
  const WeeklyEvalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final focus = state.focusSkills;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Evaluation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('This week\'s focus areas:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...focus.map((s) => ListTile(
            title: Text(s.name),
            subtitle: Text('Mastery: ${(state.skillMastery[s.id] ?? 0).toStringAsFixed(1)}'),
          )),
          const SizedBox(height: 16),
          const Text('Keep sessions short and positive. Next week will re-evaluate based on your logs.'),
        ],
      ),
    );
  }
}
