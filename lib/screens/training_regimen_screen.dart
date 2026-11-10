import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/skill.dart';
import 'app_shell.dart';

class TrainingRegimenScreen extends StatelessWidget {
  const TrainingRegimenScreen({super.key});

  List<Skill> _skillsForPath(String path) {
    final p = path.toLowerCase();
    if (p.contains('service') || p.contains('adi') || p.contains('public access')) {
      return SkillLibrary.allSkills.where((s) => s.category == 'ADI').toList();
    }
    if (p.contains('cgc') || p.contains('good citizen') || p.contains('urban')) {
      return SkillLibrary.allSkills.where((s) => s.category.contains('CGC')).toList();
    }
    if (p.contains('star') || p.contains('puppy')) {
      return SkillLibrary.allSkills.where((s) => s.category.contains('STAR')).toList();
    }
    if (p.contains('therapy')) {
      return SkillLibrary.allSkills.where((s) => s.category.contains('Therapy')).toList();
    }
    if (p.contains('trick')) {
      return SkillLibrary.allSkills.where((s) => s.category.contains('Trick')).toList();
    }
    if (p.contains('navhda') || p.contains('hunt') || p.contains('field') || p.contains('jghv')) {
      return SkillLibrary.allSkills.where((s) =>
          s.category.contains('NAVHDA') || s.category.contains('Hunt') || s.category.contains('AHDC') || s.category.contains('JGHV')).toList();
    }
    // Default happy pet / family manners — foundational skills
    return SkillLibrary.allSkills.where((s) =>
        s.category.contains('CGC') || s.category.contains('STAR') || s.category == 'ADI').take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dog = state.currentDog;
    final path = dog?.trainingPath ?? 'Happy Pet / Family Manners';
    final skills = _skillsForPath(path);

    return AppShell(
      title: 'Training Plan',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(dog == null ? 'No dog selected' : '${dog.name} — $path',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          const SizedBox(height: 8),
          const Text('Progressive skills for this path. Complete sessions to build mastery.',
              style: TextStyle(color: Color(0xFF3D4A5C))),
          const SizedBox(height: 20),
          if (skills.isEmpty)
            const Text('No skills matched this path yet. Choose a training path on the intake.')
          else
            ...skills.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              final mastery = state.skillMastery[s.id] ?? 0.0;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1A2A4A),
                    child: Text('${i + 1}', style: const TextStyle(color: Color(0xFFD4AF37))),
                  ),
                  title: Text(s.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(value: mastery, color: const Color(0xFFD4AF37), backgroundColor: Colors.grey.shade300),
                      Text('${(mastery * 100).round()}% mastery', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(s.name),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.description),
                            const SizedBox(height: 12),
                            const Text('Criteria', style: TextStyle(fontWeight: FontWeight.bold)),
                            ...s.criteria.map((c) => Text('• $c')),
                            const SizedBox(height: 12),
                            const Text('Tips', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(s.trainingTips),
                          ],
                        ),
                      ),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
