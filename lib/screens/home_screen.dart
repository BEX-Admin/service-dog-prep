import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'app_shell.dart';
import 'dog_profile_screen.dart';
import 'training_screen.dart';
import 'weekly_eval_screen.dart';
import 'skill_library_screen.dart';
import 'tricks_screen.dart';
import 'evaluation_screen.dart';
import 'regression_screen.dart';
import 'schedule_screen.dart';
import 'create_dog_screen.dart';
import 'personal_intake_screen.dart';
import 'professional_intake_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dog = state.currentDog;

    return AppShell(
      title: 'Service Dog Trainer Pro',
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
                  Color(0xCC1A2A4A),
                  Color(0xCC243656),
                  Color(0xCC1A2A4A),
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
                    color: const Color(0xFFFFF9F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD4AF37)),
                  ),
                  child: const Text(
                    'This app helps you train your dog for public access, good citizenship, and a happier life together as a family.\n\nIt is never for protection, guard, personal defense, or attack training. Those skills are incompatible with the public access and community standards we focus on.',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A2A4A)),
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
                        backgroundColor: Color(0xFFD4AF37),
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                      title: Text(state.isProfessional ? 'Professional Intake' : 'Add / Manage Your Dogs', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(state.isProfessional ? 'Trainer contact, unlimited dogs, owner reports' : 'One page for up to 3 family dogs'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => state.isProfessional ? const ProfessionalIntakeScreen() : const PersonalIntakeScreen()),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                if (state.dogs.isNotEmpty) ...[
                  const Text('Your Dogs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...state.dogs.map((d) => Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: d.photos.isNotEmpty
                          ? CircleAvatar(backgroundImage: NetworkImage(d.photos.first))
                          : const Icon(Icons.pets, color: Color(0xFF1A2A4A)),
                      title: Text(d.name),
                      subtitle: Text('${d.breed} • ${d.trainingPath}${d.birthdate.isNotEmpty ? ' • ${d.birthdate}' : ''}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          context.read<AppState>().removeDog(d.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${d.name} removed')));
                        },
                      ),
                      onTap: () {
                        context.read<AppState>().currentDogId = d.id;
                        context.read<AppState>().notifyListeners();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DogProfileScreen()));
                      },
                    ),
                  )),
                  const SizedBox(height: 8),
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
