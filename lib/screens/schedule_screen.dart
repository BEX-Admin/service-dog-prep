import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule & Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Upcoming Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const ListTile(title: Text('Morning walk & focus work'), subtitle: Text('Tomorrow 8:00 AM')),
          const ListTile(title: Text('Public access practice'), subtitle: Text('Saturday 10:00 AM')),
          const SizedBox(height: 16),
          const Text('Recent Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...state.sessions.take(5).map((s) => ListTile(
            title: Text(s.date.toString().substring(0, 16)),
            subtitle: Text(s.notes),
          )),
        ],
      ),
    );
  }
}
