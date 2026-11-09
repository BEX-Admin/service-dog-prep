import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/training_session.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final Map<String, double> _scores = {
    'Loose Leash Walking': 0.8,
    'Sit/Down/Stay': 0.7,
    'Ignore Food': 0.5,
    'Reaction to Stranger': 0.9,
  };
  String _method = 'Food Rewards';
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training Session')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Rate success on key behaviors (0-1):'),
          ..._scores.keys.map((skill) => Column(
            children: [
              Text(skill),
              Slider(
                value: _scores[skill]!,
                onChanged: (v) => setState(() => _scores[skill] = v),
              ),
            ],
          )),
          DropdownButton<String>(
            value: _method,
            items: ['Food Rewards', 'Play', 'Praise', 'Toys', 'Choke Chain (Discouraged)', 'E-Collar (Discouraged)']
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => setState(() => _method = v!),
          ),
          if (_method.contains('Discouraged'))
            const Text(
              'Aversive methods are discouraged. Science shows positive reinforcement is equally or more effective with better welfare. Alternatives recommended.',
              style: TextStyle(color: Colors.orange),
            ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Session notes / opportunity errors'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final session = TrainingSession(
                id: DateTime.now().toString(),
                dogId: context.read<AppState>().currentDogId ?? '',
                date: DateTime.now(),
                behaviorScores: Map.from(_scores),
                notes: _notesController.text,
                methodUsed: _method,
                opportunityErrors: _notesController.text.split(',').map((e) => e.trim()).toList(),
              );
              context.read<AppState>().addSessionFeedback(session);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Session logged. Next session will adapt focus.')),
              );
              Navigator.pop(context);
            },
            child: const Text('Save Session & Adapt Plan'),
          ),
        ],
      ),
    );
  }
}
