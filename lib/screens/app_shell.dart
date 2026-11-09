import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'home_screen.dart';
import 'personal_intake_screen.dart';
import 'professional_intake_screen.dart';
import 'training_screen.dart';
import 'schedule_screen.dart';
import 'weekly_eval_screen.dart';
import 'skill_library_screen.dart';
import 'settings_screen.dart';
import 'feedback_screen.dart';
import 'dog_profile_screen.dart';

class AppShell extends StatelessWidget {
  final String title;
  final Widget body;
  const AppShell({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2A4A),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/branding/boykin-badge.png', height: 36),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<AppState>().logout();
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
            child: const Text('Log out', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
      drawer: isWide ? null : Drawer(child: _NavList(state: state)),
      body: Row(
        children: [
          if (isWide)
            Container(
              width: 240,
              color: const Color(0xFF1A2A4A),
              child: _NavList(state: state, dark: true),
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(child: body),
                Container(
                  width: double.infinity,
                  color: const Color(0xFF0F1C30),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: const Text(
                    '© 2026 Service Dog Trainer Pro. A well-trained dog is a happy dog.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavList extends StatelessWidget {
  final AppState state;
  final bool dark;
  const _NavList({required this.state, this.dark = false});

  @override
  Widget build(BuildContext context) {
    final color = dark ? Colors.white : const Color(0xFF1A2A4A);
    final items = <_NavItem>[
      _NavItem('Home', Icons.home, const HomeScreen()),
      _NavItem(state.isProfessional ? 'Pro Intake' : 'Tell us about your dog', Icons.pets,
          state.isProfessional ? const ProfessionalIntakeScreen() : const PersonalIntakeScreen()),
      _NavItem('Dog Profile', Icons.account_circle, const DogProfileScreen()),
      _NavItem('Training', Icons.play_arrow, const TrainingScreen()),
      _NavItem('Schedule', Icons.calendar_today, const ScheduleScreen()),
      _NavItem('Reports / Weekly Eval', Icons.assessment, const WeeklyEvalScreen()),
      _NavItem('Skill Library', Icons.library_books, const SkillLibraryScreen()),
      _NavItem('Settings & Profile', Icons.settings, const SettingsScreen()),
      _NavItem('Testimonials & Suggestions', Icons.rate_review, const FeedbackScreen()),
    ];
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        if (dark)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Menu', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
          ),
        ...items.map((item) => ListTile(
          leading: Icon(item.icon, color: dark ? const Color(0xFFD4AF37) : const Color(0xFF1A2A4A)),
          title: Text(item.label, style: TextStyle(color: color)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => item.page));
            if (!dark) Navigator.pop(context);
          },
        )),
      ],
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final Widget page;
  _NavItem(this.label, this.icon, this.page);
}
