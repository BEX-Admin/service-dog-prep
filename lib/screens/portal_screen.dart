import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'app_shell.dart';
import 'personal_intake_screen.dart';
import 'professional_intake_screen.dart';
import 'home_screen.dart';

class PortalScreen extends StatelessWidget {
  const PortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isPro = state.isProfessional;
    final dog = state.currentDog;
    final heroImage = (dog != null && dog.photos.isNotEmpty) ? dog.photos.first : null;

    return AppShell(
      title: isPro ? 'Professional Portal' : 'Your Portal',
      body: ListView(
        children: [
          // Hero with dog photo or placeholder
          SizedBox(
            height: 320,
            child: Stack(
              fit: StackFit.expand,
              children: [
                heroImage != null
                    ? Image.network(heroImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder())
                    : _placeholder(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.55)],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  bottom: 24,
                  right: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dog?.name ?? 'Your Dog',
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 8, color: Colors.black54)]),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Service Dog Trainer Pro System',
                        style: TextStyle(color: Color(0xFFD4AF37), fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A well-trained dog is a happy dog.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Train your family member to the discipline of a service dog — happier at home, confident in the community, and ready for whatever path you choose.',
                  style: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF3D4A5C)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => isPro ? const ProfessionalIntakeScreen() : const PersonalIntakeScreen()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF1A2A4A),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  ),
                  child: const Text('Tell us about your dog', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
                  child: const Text('Go to training tools', style: TextStyle(color: Color(0xFF1A2A4A))),
                ),
                const SizedBox(height: 32),
                const Text('From our partners', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
                const SizedBox(height: 8),
                const Text(
                  'Sponsor spots for trainers, vets, food, and gear coming soon. Your dog’s portal will feature recommendations tailored to their training path.',
                  style: TextStyle(color: Color(0xFF3D4A5C)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    color: const Color(0xFF1A2A4A),
    child: Center(child: Image.asset('assets/branding/boykin-badge.png', height: 140)),
  );
}
