import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class EvaluationScreen extends StatelessWidget {
  const EvaluationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dog = context.watch<AppState>().currentDog;
    return Scaffold(
      appBar: AppBar(title: const Text('Initial / Ongoing Evaluation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (dog != null) ...[
            Text('Dog: ${dog.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Goals: ${dog.goals.join(", ")}'),
            Text('Breed notes: ${dog.breed}'),
            const SizedBox(height: 16),
          ],
          const Text('Evaluation covers: goal progress, breed strengths/weaknesses, time available, health, and challenges.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Evaluation'),
          ),
        ],
      ),
    );
  }
}
