import 'package:flutter/material.dart';
import 'app_shell.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _name = TextEditingController();
  final _testimonial = TextEditingController();
  final _suggestion = TextEditingController();
  bool _allowPublic = false;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Testimonials & Suggestions',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Share your experience or tell us how we can improve.',
              style: TextStyle(fontSize: 16, color: Color(0xFF1A2A4A))),
          const SizedBox(height: 20),
          const Text('Testimonial', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          const SizedBox(height: 8),
          TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Your name (as you want it shown)')),
          TextFormField(
            controller: _testimonial,
            decoration: const InputDecoration(labelText: 'Your testimonial', hintText: 'How has training helped your dog and family?'),
            maxLines: 4,
          ),
          CheckboxListTile(
            value: _allowPublic,
            onChanged: (v) => setState(() => _allowPublic = v ?? false),
            title: const Text('Allow us to feature this on the website'),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 20),
          const Text('Suggestion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          const SizedBox(height: 8),
          TextFormField(
            controller: _suggestion,
            decoration: const InputDecoration(labelText: 'Your suggestion', hintText: 'Features, training topics, or anything else'),
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you — we received your feedback')));
              _testimonial.clear();
              _suggestion.clear();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
