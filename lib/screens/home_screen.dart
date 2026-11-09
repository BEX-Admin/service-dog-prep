import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'dog_profile_screen.dart';
import 'training_screen.dart';
import 'weekly_eval_screen.dart';
import 'skill_library_screen.dart';
import 'tricks_screen.dart';
import 'evaluation_screen.dart';
import 'regression_screen.dart';
import 'schedule_screen.dart';
import 'create_dog_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dog = state.currentDog;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.network(
                'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=1200',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xCC1A3A34),
                  Color(0xCC2E7D6F),
                  Color(0xCC1A3A34),
                ],
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/logo.png', height: 140),
                      const SizedBox(height: 8),
                      const Text(
                        'Service Dog Trainer Pro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Help your dog become the best family member and community citizen they can be.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: const Text(
                    'This app helps you train your dog for public access, good citizenship, and a happier life together as a family.\n\nIt is never for protection, guard, personal defense, or attack training. Those skills are incompatible with the public access and community standards we focus on.',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFB45309)),
                  ),
                ),
                const SizedBox(height: 16),
                if (dog != null) ...[
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF1A2A4A),
                        child: Icon(Icons.pets, color: Colors.white),
                      ),
                      title: Text(dog.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text('${dog.breed} • ${dog.age} years\nGoals: ${dog.goals.join(", ")}'),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DogProfileScreen()),
                      ),
                    ),
                  ),
                ] else ...[
                  Card(
                    elevation: 4,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE8A87C),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      title: const Text('Add Your Dog', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Create a profile with goals, temperament, and training focus'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CreateDogScreen()),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _navButton(context, 'Start / Log Training Session', Icons.play_arrow, const TrainingScreen()),
                _navButton(context, 'Schedule & Dashboard', Icons.calendar_today, const ScheduleScreen()),
                _navButton(context, 'Weekly Evaluation', Icons.assessment, const WeeklyEvalScreen()),
                _navButton(context, 'Skill Library (CGC / Urban / Public Access)', Icons.library_books, const SkillLibraryScreen()),
                _navButton(context, 'Initial / Ongoing Evaluation', Icons.fact_check, const EvaluationScreen()),
                _navButton(context, 'Jump Back In / Regression', Icons.restore, const RegressionScreen()),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white70),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TricksScreen()),
                  ),
                  icon: const Icon(Icons.star_outline),
                  label: const Text('Bonus Tricks (Optional)'),
                ),
                const SizedBox(height: 24),
                Text(
                  state.isProfessional
                      ? 'Professional Mode Active'
                      : 'Personal Account (up to 3 dogs)',
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () => state.logout(),
                    icon: const Icon(Icons.logout, color: Colors.white70),
                    label: const Text('Log out', style: TextStyle(color: Colors.white70)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, String label, IconData icon, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A2A4A),
          minimumSize: const Size.fromHeight(50),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
