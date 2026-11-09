import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'personal_intake_screen.dart';
import 'professional_intake_screen.dart';
import 'home_screen.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isPro = state.isProfessional;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2A4A),
        foregroundColor: Colors.white,
        title: Text(isPro ? 'Professional Portal' : 'Personal Portal'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
            child: const Text('Go to App', style: TextStyle(color: Color(0xFFD4AF37))),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/branding/boykin-badge.png', height: 120),
                const SizedBox(height: 16),
                Text(
                  isPro ? 'Welcome, Trainer' : 'Welcome to Service Dog Trainer Pro',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  isPro
                      ? 'Set up your company contact and start adding dogs and owner reports.'
                      : 'A well-trained dog is a happy dog. Let’s get to know your family member.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Color(0xFF3D4A5C)),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => isPro ? const ProfessionalIntakeScreen() : const PersonalIntakeScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF1A2A4A),
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Tell us about your dog'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
                  child: const Text('Skip for now', style: TextStyle(color: Color(0xFF1A2A4A))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
