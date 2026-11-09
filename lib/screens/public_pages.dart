import 'package:flutter/material.dart';
import 'auth_screen.dart';

class PublicPageScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final String actionLabel;
  final VoidCallback? onAction;

  const PublicPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actionLabel = 'Get Started — Log In',
    this.onAction,
  });

  void _goToAuth(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: Column(
        children: [
          // Shared header
          Container(
            color: const Color(0xFF1A2A4A),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  child: Image.asset('assets/logo.png', height: 52),
                ),
                const SizedBox(width: 12),
                const Text('Service Dog Trainer Pro', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                if (isWide) ...[
                  _nav(context, 'Home', () => Navigator.of(context).popUntil((r) => r.isFirst)),
                  _nav(context, 'About', () => _push(context, const AboutPage())),
                  _nav(context, 'Training', () => _push(context, const TrainingTypesPage())),
                  _nav(context, 'Professional', () => _push(context, const ProfessionalPage())),
                  _nav(context, 'Resources', () => _push(context, const ResourcesPage())),
                  _nav(context, 'Contact', () => _push(context, const ContactPage())),
                ] else
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (v) {
                      if (v == 'Login') _goToAuth(context);
                      if (v == 'Home') Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'Home', child: Text('Home')),
                      PopupMenuItem(value: 'About', child: Text('About')),
                      PopupMenuItem(value: 'Training', child: Text('Training')),
                      PopupMenuItem(value: 'Professional', child: Text('Professional')),
                      PopupMenuItem(value: 'Resources', child: Text('Resources')),
                      PopupMenuItem(value: 'Contact', child: Text('Contact')),
                      PopupMenuItem(value: 'Login', child: Text('Log In')),
                    ],
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _goToAuth(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
                  child: const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    color: const Color(0xFF1A2A4A),
                    child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: body,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: onAction ?? () => _goToAuth(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: const Color(0xFF1A2A4A),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text(actionLabel),
                  ),
                  const SizedBox(height: 40),
                  // Footer
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF0F1C30),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _footerLink(context, 'Privacy Policy'),
                            _footerLink(context, 'Terms'),
                            _footerLink(context, 'Contact'),
                            _footerLink(context, 'Help / FAQ'),
                            _footerLink(context, 'Blog'),
                            _footerLink(context, 'Suggestions'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('© 2026 Service Dog Trainer Pro. We love dogs. A well-trained dog is a happy dog.',
                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _nav(BuildContext context, String label, VoidCallback onTap) {
    return TextButton(onPressed: onTap, child: Text(label, style: const TextStyle(color: Colors.white)));
  }

  Widget _footerLink(BuildContext context, String label) {
    return TextButton(
      onPressed: () => _showSimple(context, label),
      child: Text(label, style: const TextStyle(color: Color(0xFFD4AF37))),
    );
  }

  void _showSimple(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: const Text('Full page coming soon. Contact us at hello@servicedogtrainerpro.com'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'About Us',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Why we created this', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('Dogs are family. We built Service Dog Trainer Pro so every family can train their dog to the same standards used for well-trained service dogs — making life together happier, safer, and more confident.', style: TextStyle(fontSize: 16, height: 1.5)),
          SizedBox(height: 20),
          Text('A well-trained dog is a happy dog', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('When a dog understands what is expected and feels successful, anxiety drops and joy rises. That is the heart of everything we do.', style: TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
      actionLabel: 'Start Your Dog’s Journey',
    );
  }
}

class TrainingTypesPage extends StatelessWidget {
  const TrainingTypesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Types of Training',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Happy Pet & Family Manners', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 6),
          Text('Everyday skills that make home and community life smoother for everyone.'),
          SizedBox(height: 16),
          Text('Service Dog & Public Access (ADI standards)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 6),
          Text('Train to the discipline and reliability expected of assistance dogs.'),
          SizedBox(height: 16),
          Text('Good Citizen, S.T.A.R. Puppy, CGCA / CGCU', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 6),
          Text('AKC programs from puppy socialization through urban real-world manners.'),
          SizedBox(height: 16),
          Text('PSD, ESA & Therapy Animals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 6),
          Text('Specialized support for psychiatric service dogs, emotional support animals, and therapy dogs.'),
          SizedBox(height: 16),
          Text('Hunting & Field Standards', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 6),
          Text('NAVHDA, AKC Hunt Tests, AHDC, and European/JGHV foundations.'),
        ],
      ),
      actionLabel: 'Choose a Training Path',
    );
  }
}

class ProfessionalPage extends StatelessWidget {
  const ProfessionalPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Professional Edition',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Built for trainers and training businesses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 12),
          Text('• Consistent training methods across every dog and handler\n• Clear documentation of progress\n• Opportunities for improvement identified automatically\n• Easy communication with owners via reports and suggestions\n• One program fee covers the first dog — then scale as you grow', style: TextStyle(fontSize: 16, height: 1.6)),
          SizedBox(height: 20),
          Text('Unlimited dogs, owner records, and professional reports.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
      actionLabel: 'Start Professional Trial',
    );
  }
}

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Resources',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recommended products, find a trainer, blog, FAQ, and suggestions.', style: TextStyle(fontSize: 16, height: 1.5)),
          SizedBox(height: 16),
          Text('We partner with brands that support happy, well-trained dogs. Sponsor spots available.', style: TextStyle(fontSize: 16)),
        ],
      ),
      actionLabel: 'Explore Resources',
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Contact',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('We would love to hear from you.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 12),
          Text('Email: hello@servicedogtrainerpro.com', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text('Whether you are a pet parent or a professional trainer, we are here to help.', style: TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
      actionLabel: 'Send a Message',
    );
  }
}
