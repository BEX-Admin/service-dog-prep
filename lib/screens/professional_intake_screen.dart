import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/dog.dart';

class ProfessionalIntakeScreen extends StatefulWidget {
  const ProfessionalIntakeScreen({super.key});

  @override
  State<ProfessionalIntakeScreen> createState() => _ProfessionalIntakeScreenState();
}

class _ProfessionalIntakeScreenState extends State<ProfessionalIntakeScreen> {
  final _companyController = TextEditingController();
  final _trainerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Professional Intake')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Trainer / Company Contact', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
          const SizedBox(height: 8),
          TextFormField(controller: _companyController, decoration: const InputDecoration(labelText: 'Company / Business Name')),
          TextFormField(controller: _trainerNameController, decoration: const InputDecoration(labelText: 'Lead Trainer Name')),
          TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
          TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Dogs in Training', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProDogFormScreen())),
                icon: const Icon(Icons.add),
                label: const Text('Add Dog'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (state.dogs.isEmpty)
            const Card(child: ListTile(title: Text('No dogs yet — add your first client dog')))
          else
            ...state.dogs.map((dog) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.pets)),
                    title: Text(dog.name),
                    subtitle: Text('${dog.breed} • ${dog.familyName}\nPath: ${dog.trainingPath}'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProDogDetailScreen(dog: dog))),
                  ),
                )),
          const SizedBox(height: 24),
          const Text('Owner Communication & Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Generate progress reports and send suggestions to owners from each dog’s detail page.'),
        ],
      ),
    );
  }
}

class ProDogFormScreen extends StatefulWidget {
  const ProDogFormScreen({super.key});

  @override
  State<ProDogFormScreen> createState() => _ProDogFormScreenState();
}

class _ProDogFormScreenState extends State<ProDogFormScreen> {
  final _name = TextEditingController();
  final _breed = TextEditingController();
  final _age = TextEditingController();
  final _ownerName = TextEditingController();
  final _ownerEmail = TextEditingController();
  final _ownerPhone = TextEditingController();
  final _address = TextEditingController();
  final _temperament = TextEditingController();
  final _fears = TextEditingController();
  final _goals = TextEditingController();
  final _health = TextEditingController();
  final _notes = TextEditingController();
  String _size = 'Medium';
  String _path = 'ADI Public Access';

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    final state = context.read<AppState>();
    final user = state.supabaseService.currentUser;
    final dogData = {
      'name': _name.text.trim(),
      'breed': _breed.text.trim(),
      'age': int.tryParse(_age.text) ?? 0,
      'size': _size,
      'temperament': _temperament.text.trim(),
      'fears': _fears.text.trim(),
      'goals': _goals.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      'family_name': _ownerName.text.trim(),
      'owner_email': _ownerEmail.text.trim(),
      'owner_phone': _ownerPhone.text.trim(),
      'address': _address.text.trim(),
      'contact': _ownerPhone.text.trim(),
      'health_notes': _health.text.trim(),
      'notes': _notes.text.trim(),
      'training_path': _path,
      'preferred_training_times': 'Flexible',
      'number_of_trainers': 1,
    };
    if (user != null) {
      dogData['user_id'] = user.id;
      try {
        await state.supabaseService.insertDog(dogData);
      } catch (_) {}
    }
    final dog = Dog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: dogData['name'] as String,
      breed: dogData['breed'] as String,
      age: dogData['age'] as int,
      size: dogData['size'] as String,
      temperament: dogData['temperament'] as String,
      fears: dogData['fears'] as String,
      goals: List<String>.from(dogData['goals'] as List),
      familyName: dogData['family_name'] as String,
      ownerEmail: dogData['owner_email'] as String,
      ownerPhone: dogData['owner_phone'] as String,
      address: dogData['address'] as String,
      contact: dogData['contact'] as String,
      healthNotes: dogData['health_notes'] as String,
      notes: dogData['notes'] as String,
      trainingPath: dogData['training_path'] as String,
    );
    state.addDog(dog);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Client Dog')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Dog Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Dog Name *')),
          TextFormField(controller: _breed, decoration: const InputDecoration(labelText: 'Breed')),
          TextFormField(controller: _age, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
          DropdownButtonFormField<String>(
            value: _size,
            decoration: const InputDecoration(labelText: 'Size'),
            items: ['Small', 'Medium', 'Large', 'Giant'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _size = v ?? 'Medium'),
          ),
          TextFormField(controller: _temperament, decoration: const InputDecoration(labelText: 'Temperament'), maxLines: 2),
          TextFormField(controller: _fears, decoration: const InputDecoration(labelText: 'Fears / Triggers'), maxLines: 2),
          TextFormField(controller: _goals, decoration: const InputDecoration(labelText: 'Goals (comma separated)')),
          DropdownButtonFormField<String>(
            value: _path,
            decoration: const InputDecoration(labelText: 'Training Path / Standard'),
            items: const [
              'ADI Public Access',
              'AKC S.T.A.R. Puppy',
              'AKC CGC / CGCA / CGCU',
              'Trick Dog / Therapy',
              'NAVHDA',
              'AKC Hunt Tests',
              'AHDC',
              'JGHV / European',
              'Happy Pet / Family Manners',
            ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _path = v ?? _path),
          ),
          const SizedBox(height: 16),
          const Text('Owner Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextFormField(controller: _ownerName, decoration: const InputDecoration(labelText: 'Owner / Family Name')),
          TextFormField(controller: _ownerEmail, decoration: const InputDecoration(labelText: 'Owner Email')),
          TextFormField(controller: _ownerPhone, decoration: const InputDecoration(labelText: 'Owner Phone')),
          TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address / Location')),
          TextFormField(controller: _health, decoration: const InputDecoration(labelText: 'Health Notes'), maxLines: 2),
          TextFormField(controller: _notes, decoration: const InputDecoration(labelText: 'Trainer Notes'), maxLines: 3),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A), padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Save Dog'),
          ),
        ],
      ),
    );
  }
}

class ProDogDetailScreen extends StatelessWidget {
  final Dog dog;
  const ProDogDetailScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(dog.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${dog.breed} • ${dog.age} years • ${dog.size}', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Owner: ${dog.familyName}', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Email: ${dog.ownerEmail}'),
          Text('Phone: ${dog.ownerPhone}'),
          Text('Address: ${dog.address}'),
          const SizedBox(height: 12),
          Text('Training Path: ${dog.trainingPath}'),
          Text('Goals: ${dog.goals.join(", ")}'),
          Text('Temperament: ${dog.temperament}'),
          Text('Fears: ${dog.fears}'),
          Text('Health: ${dog.healthNotes}'),
          Text('Notes: ${dog.notes}'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OwnerReportScreen(dog: dog))),
            icon: const Icon(Icons.description),
            label: const Text('Create Owner Report / Communication'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
          ),
        ],
      ),
    );
  }
}

class OwnerReportScreen extends StatefulWidget {
  final Dog dog;
  const OwnerReportScreen({super.key, required this.dog});

  @override
  State<OwnerReportScreen> createState() => _OwnerReportScreenState();
}

class _OwnerReportScreenState extends State<OwnerReportScreen> {
  final _progress = TextEditingController();
  final _suggestions = TextEditingController();
  final _nextSteps = TextEditingController();

  void _generate() {
    final report = '''
Progress Report for ${widget.dog.name}
Owner: ${widget.dog.familyName}

Progress:
${_progress.text}

Suggestions for Home Practice:
${_suggestions.text}

Next Steps:
${_nextSteps.text}

— Service Dog Trainer Pro
''';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Ready'),
        content: SingleChildScrollView(child: Text(report)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          TextButton(
            onPressed: () {
              // In a full version this would email or store the report
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report saved (demo). Email integration coming soon.')));
              Navigator.pop(ctx);
            },
            child: const Text('Save / Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report for ${widget.dog.name}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Document progress and communicate clearly with the owner.', style: TextStyle(fontSize: 15)),
          const SizedBox(height: 16),
          TextFormField(controller: _progress, decoration: const InputDecoration(labelText: 'Progress Summary'), maxLines: 4),
          TextFormField(controller: _suggestions, decoration: const InputDecoration(labelText: 'Suggestions for Owner'), maxLines: 4),
          TextFormField(controller: _nextSteps, decoration: const InputDecoration(labelText: 'Next Steps / Opportunities'), maxLines: 3),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _generate,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A), padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }
}
