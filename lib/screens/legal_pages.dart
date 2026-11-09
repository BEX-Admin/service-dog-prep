import 'package:flutter/material.dart';
import 'public_pages.dart';

class ContactFormPage extends StatefulWidget {
  const ContactFormPage({super.key});

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Contact Us',
      actionLabel: 'Send Message',
      onAction: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message received. We will reply to your email.')));
        _message.clear();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('We would love to hear from you.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          const SizedBox(height: 8),
          const Text('Email: hello@servicedogtrainerpro.com', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Your name')),
          TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
          TextFormField(controller: _message, decoration: const InputDecoration(labelText: 'Message'), maxLines: 5),
        ],
      ),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Privacy Policy',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Last updated: November 2026', style: TextStyle(color: Color(0xFF3D4A5C))),
          SizedBox(height: 16),
          Text('What we collect', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('Account information (name, email, phone), dog profiles (name, breed, training notes, photos you upload), and usage data needed to provide the service.'),
          SizedBox(height: 16),
          Text('How we use it', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('To provide training tools, generate reports for owners and trainers, improve the product, and communicate with you about your account. We do not sell your personal information.'),
          SizedBox(height: 16),
          Text('Your choices', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('You may update or delete your profile and dog records at any time from Settings. Contact hello@servicedogtrainerpro.com to request account deletion or a copy of your data.'),
          SizedBox(height: 16),
          Text('This is a working policy for the current beta. A full legal review will be completed before paid launch.'),
        ],
      ),
    );
  }
}

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Terms of Use',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('By using Service Dog Trainer Pro you agree to these terms.', style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          Text('Service description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('The app helps owners and trainers plan and track positive, relationship-based training. It is not a substitute for professional veterinary or behavioral advice, and it does not certify a dog as a service dog.'),
          SizedBox(height: 16),
          Text('Prohibited use', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('This app is never for protection, guard, personal defense, or attack training. Those skills are incompatible with the public access and community standards we support.'),
          SizedBox(height: 16),
          Text('Accounts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          SizedBox(height: 8),
          Text('You are responsible for the accuracy of the information you enter and for keeping your login credentials secure.'),
          SizedBox(height: 16),
          Text('Full legal terms will be published before paid launch. Questions: hello@servicedogtrainerpro.com'),
        ],
      ),
    );
  }
}

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PublicPageScaffold(
      title: 'Training Disclaimer',
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Service Dog Trainer Pro is an educational and tracking tool. It does not guarantee any training outcome or public-access certification.', style: TextStyle(fontSize: 16, height: 1.5)),
          SizedBox(height: 16),
          Text('Always consult a qualified trainer or veterinarian for dogs with aggression, anxiety, or health concerns. We focus exclusively on positive, relationship-based methods.'),
          SizedBox(height: 16),
          Text('This app is never for protection, guard, personal defense, or attack training.'),
        ],
      ),
    );
  }
}
