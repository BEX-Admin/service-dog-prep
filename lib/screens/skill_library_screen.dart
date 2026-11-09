import 'package:flutter/material.dart';
import '../models/skill.dart';

class SkillLibraryScreen extends StatelessWidget {
  const SkillLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = SkillLibrary.allSkills;
    return Scaffold(
      appBar: AppBar(title: const Text('Skill Library')),
      body: ListView.builder(
        itemCount: skills.length,
        itemBuilder: (context, i) {
          final s = skills[i];
          return ListTile(
            title: Text(s.name),
            subtitle: Text(s.category),
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(s.name),
                content: Text(s.description),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
