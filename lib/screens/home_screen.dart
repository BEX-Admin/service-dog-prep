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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final dog = state.currentDog;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo.jpg', height: 36),
            const SizedBox(width: 12),
            const Text('Service Dog Trainer Pro', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D6F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => state.logout(),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D6F), Color(0xFFE8A87C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Train with Confidence',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Prepare your dog for public access, CGC, and real-world service work.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Text(
              'This app is exclusively for preparing dogs for public-access manners and assistance dog behaviors.\n\nIt is NOT for protection, guard, or attack training.',
              style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFB45309)),
            ),
          ),
          const SizedBox(height: 20),
          if (dog != null) ...[
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF2E7D6F),
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
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8A87C),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                title: const Text('Add Your Dog', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Create a profile with goals, temperament, and training focus'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create Dog form coming next')),
                  );
                },
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
              side: const BorderSide(color: Color(0xFF2E7D6F)),
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TricksScreen()),
            ),
            icon: const Icon(Icons.star_outline, color: Color(0xFF2E7D6F)),
            label: const Text('Bonus Tricks (Optional)', style: TextStyle(color: Color(0xFF2E7D6F))),
          ),
          const SizedBox(height: 24),
          Text(
            state.isProfessional
                ? 'Professional Mode Active'
                : 'Personal Account (up to 3 dogs)',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
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
          backgroundColor: const Color(0xFF2E7D6F),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
