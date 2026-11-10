import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'auth_screen.dart';
import 'public_pages.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> _heroImages = [
    'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=1600',
    'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=1600',
    'https://images.unsplash.com/photo-1530281700549-e82e7bf110d6?w=1600',
    'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=1600',
    'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=1600',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        final next = (_currentPage + 1) % _heroImages.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToAuth() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  void _showSection(String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFF1A2A4A),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Image.asset('assets/branding/boykin-badge.png', height: 64, fit: BoxFit.contain),
                const SizedBox(width: 12),
                const Text(
                  'Service Dog Trainer Pro',
                  style: TextStyle(color: Color(0xFFD4AF37), fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (isWide) ...[
                  _navButton('Home', () {}),
                  _navButton('About', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()))),
                  _navButton('Training', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingTypesPage()))),
                  _navButton('Professional', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfessionalPage()))),
                  _navButton('Resources', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesPage()))),
                  _navButton('Contact', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactPage()))),
                ] else
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onSelected: (v) {
                      if (v == 'Login') _goToAuth();
                      if (v == 'About') Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
                      if (v == 'Training') Navigator.push(context, MaterialPageRoute(builder: (_) => const TrainingTypesPage()));
                      if (v == 'Professional') Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfessionalPage()));
                      if (v == 'Resources') Navigator.push(context, MaterialPageRoute(builder: (_) => const ResourcesPage()));
                      if (v == 'Contact') Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactPage()));
                    },
                    itemBuilder: (_) => const [
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
                  onPressed: _goToAuth,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF1A2A4A),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Hero + content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero
                  if (!isWide) ...[
                    // Mobile: logo block above carousel
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      color: const Color(0xFF1A2A4A),
                      child: Column(
                        children: [
                          Image.asset('assets/logo.png', height: 160),
                          const SizedBox(height: 12),
                          const Text('We Love Dogs.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          const Text('A well-trained dog is a happy dog.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _goToAuth,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
                            child: const Text('Get Started — Log In'),
                          ),
                        ],
                      ),
                    ),
                    // Carousel
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemCount: _heroImages.length,
                        itemBuilder: (_, i) => Image.network(_heroImages[i], fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A2A4A))),
                      ),
                    ),
                    // Testimonials below
                    Container(
                      height: 280,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(12)),
                      child: ListView(
                        padding: const EdgeInsets.all(12),
                        children: [
                          const Text('What families & trainers say', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          _testimonial('“My dog is calmer and happier than ever. We can actually enjoy walks together.”', 'Sarah & Max'),
                          _testimonial('“The Professional Edition finally gave me one place to track every dog and share progress with owners.”', 'James, CPDT'),
                          _testimonial('“Training no longer feels like a chore. It’s something we look forward to.”', 'The Chen Family'),
                          _testimonial('“We finally feel confident taking our dog everywhere — stores, restaurants, travel.”', 'The Patel Family'),
                          _testimonial('“Clear reports and suggestions make it easy to keep owners engaged between sessions.”', 'Maria, Trainer'),
                        ],
                      ),
                    ),
                  ] else ...[
                  // Desktop hero overlay
                  SizedBox(
                    height: 520,
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: (i) => setState(() => _currentPage = i),
                          itemCount: _heroImages.length,
                          itemBuilder: (_, i) => Image.network(
                            _heroImages[i],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF1A2A4A)),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.15),
                                Colors.black.withOpacity(0.55),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: isWide
                              ? Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 420),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/logo.png', height: 280),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'We Love Dogs.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 48,
                                                  fontWeight: FontWeight.bold,
                                                  shadows: [Shadow(blurRadius: 8, color: Colors.black54)],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'A well-trained dog is\na Happy Dog!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFFD4AF37),
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.w600,
                                                  shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              ElevatedButton(
                                                onPressed: _goToAuth,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFD4AF37),
                                                  foregroundColor: const Color(0xFF1A2A4A),
                                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                                child: const Text('Get Started — Log In'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.45),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: ListView(
                                          padding: const EdgeInsets.all(12),
                                          children: [
                                            const Text('What families & trainers say', style: TextStyle(color: Color(0xFFD4AF37), fontSize: 22, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 12),
                                            _testimonial('“My dog is calmer and happier than ever. We can actually enjoy walks together.”', 'Sarah & Max'),
                                            _testimonial('“The Professional Edition finally gave me one place to track every dog and share progress with owners.”', 'James, CPDT'),
                                            _testimonial('“Training no longer feels like a chore. It’s something we look forward to.”', 'The Chen Family'),
                                            _testimonial('“We finally feel confident taking our dog everywhere — stores, restaurants, travel.”', 'The Patel Family'),
                                            _testimonial('“Clear reports and suggestions make it easy to keep owners engaged between sessions.”', 'Maria, Trainer'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/logo.png', height: 100),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'We Love Dogs.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 8, color: Colors.black54)]),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'A well-trained dog is a happy dog.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Color(0xFFD4AF37), fontSize: 22, fontWeight: FontWeight.w600, shadows: [Shadow(blurRadius: 6, color: Colors.black54)]),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _goToAuth,
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
                                      child: const Text('Get Started — Log In'),
                                    ),
                                  ],
                                ),
                        ),
                        // dots
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_heroImages.length, (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == i ? const Color(0xFFD4AF37) : Colors.white54,
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],

                  // Marketing section
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text(
                          'Happy Dogs. Happy Families. Confident Community Members.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A)),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Whether you want a well-mannered family pet, a good citizen, or a service dog ready for public access, we help you build the relationship and skills that make every day better for both of you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Color(0xFF3D4A5C), height: 1.5),
                        ),
                        const SizedBox(height: 40),
                        Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          alignment: WrapAlignment.center,
                          children: [
                            _featureCard(Icons.favorite, 'Dogs Are Family', 'We treat training as building trust and joy, not control. Happy dogs thrive when they understand and feel safe.'),
                            _featureCard(Icons.verified, 'Proven Standards', 'Train to the same standards used for CGC, Urban CGC, and public access — so your dog can go anywhere with you.'),
                            _featureCard(Icons.groups, 'For Owners & Pros', 'Personal tools for families and a full Professional Edition for trainers who want consistency, documentation, and better client communication.'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sponsor / product teaser
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Text(
                          'Recommended Products & Partners',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A)),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'We carefully recommend foods, gear, and tools that support happy, well-trained dogs. Sponsor spots available for brands that share our values.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF3D4A5C)),
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () => _showSection('Products', 'Coming soon — curated recommendations for treats, harnesses, enrichment, and more.'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1A2A4A),
                            side: const BorderSide(color: Color(0xFFD4AF37), width: 2),
                          ),
                          child: const Text('See Recommended Products'),
                        ),
                      ],
                    ),
                  ),

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
                            _footerLink('Privacy Policy', () => _showSection('Privacy', 'We respect your data. Full privacy policy coming soon.')),
                            _footerLink('Terms', () => _showSection('Terms', 'Terms of use coming soon.')),
                            _footerLink('Contact', () => _showSection('Contact', 'hello@servicedogtrainerpro.com')),
                            _footerLink('Help / FAQ', () => _showSection('FAQ', 'Frequently asked questions coming soon.')),
                            _footerLink('Blog', () => _showSection('Blog', 'Training tips and stories coming soon.')),
                            _footerLink('Suggestions', () => _showSection('Suggestions', 'We’d love your ideas — contact us anytime.')),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '© 2026 Service Dog Trainer Pro. We love dogs. A well-trained dog is a happy dog.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
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

  Widget _navButton(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15)),
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: Color(0xFFD4AF37))),
    );
  }

  Widget _featureCard(IconData icon, String title, String body) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: const Color(0xFFD4AF37)),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
              const SizedBox(height: 8),
              Text(body, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF3D4A5C))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _testimonial(String quote, String author) {
    return Card(
      color: const Color(0xFF243656),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quote, style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic, fontSize: 16, height: 1.4)),
            const SizedBox(height: 10),
            Text(author, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
