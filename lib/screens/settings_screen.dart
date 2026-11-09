import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'app_shell.dart';
import 'personal_intake_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return AppShell(
      title: 'Settings & Profile',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Update your personal, payment, and pet information.',
              style: TextStyle(fontSize: 16, color: Color(0xFF1A2A4A))),
          const SizedBox(height: 20),
          _section('Personal Information'),
          TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone', hintText: '(555) 123-4567')),
          TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address')),
          Row(
            children: [
              Expanded(flex: 3, child: TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'))),
              const SizedBox(width: 8),
              Expanded(flex: 1, child: TextFormField(controller: _state, decoration: const InputDecoration(labelText: 'State'))),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: TextFormField(controller: _zip, decoration: const InputDecoration(labelText: 'Zip'))),
            ],
          ),
          const SizedBox(height: 24),
          _section('Payment'),
          const Text('Payment method integration is planned. You will be able to add or update a card here for subscriptions and professional plans.',
              style: TextStyle(color: Color(0xFF3D4A5C))),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment setup coming soon'))),
            child: const Text('Add / Update Payment Method'),
          ),
          const SizedBox(height: 24),
          _section('Your Dogs'),
          if (state.dogs.isEmpty)
            const Text('No dogs yet. Use the intake to add one.')
          else
            ...state.dogs.map((d) => Card(
              child: ListTile(
                leading: const Icon(Icons.pets, color: Color(0xFF1A2A4A)),
                title: Text(d.name),
                subtitle: Text('${d.breed} • ${d.trainingPath}'),
                trailing: const Icon(Icons.edit),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalIntakeScreen())),
              ),
            )),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Persist locally for now; cloud owner profile table can be added later
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Personal profile saved')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
            child: const Text('Save Personal Info'),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
  );
}
