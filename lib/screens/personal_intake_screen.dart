import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/dog.dart';

class PersonalIntakeScreen extends StatefulWidget {
  const PersonalIntakeScreen({super.key});

  @override
  State<PersonalIntakeScreen> createState() => _PersonalIntakeScreenState();
}

class _PersonalIntakeScreenState extends State<PersonalIntakeScreen> {
  final _ownerName = TextEditingController();
  final _ownerEmail = TextEditingController();
  final _ownerPhone = TextEditingController();
  final _address = TextEditingController();
  final List<_DogForm> _forms = [_DogForm()];

  void _addDog() {
    if (_forms.length < 3) setState(() => _forms.add(_DogForm()));
  }

  void _removeDog(int index) {
    if (_forms.length > 1) setState(() => _forms.removeAt(index));
  }

  Future<void> _saveAll() async {
    final state = context.read<AppState>();
    final user = state.supabaseService.currentUser;
    for (final form in _forms) {
      if (form.nameController.text.trim().isEmpty) continue;
      final dogData = form.toMap(
        familyName: _ownerName.text.trim(),
        ownerEmail: _ownerEmail.text.trim(),
        ownerPhone: _ownerPhone.text.trim(),
        address: _address.text.trim(),
      );
      if (user != null) {
        dogData['user_id'] = user.id;
        try {
          await state.supabaseService.insertDog(dogData);
        } catch (_) {}
      }
      final dog = Dog(
        id: DateTime.now().millisecondsSinceEpoch.toString() + form.nameController.text,
        name: dogData['name'] as String,
        breed: dogData['breed'] as String? ?? '',
        age: dogData['age'] as int? ?? 0,
        size: dogData['size'] as String? ?? 'Medium',
        temperament: dogData['temperament'] as String? ?? '',
        fears: dogData['fears'] as String? ?? '',
        goals: List<String>.from(dogData['goals'] ?? []),
        familyName: dogData['family_name'] as String? ?? '',
        ownerEmail: dogData['owner_email'] as String? ?? '',
        ownerPhone: dogData['owner_phone'] as String? ?? '',
        address: dogData['address'] as String? ?? '',
        habits: dogData['habits'] as String? ?? '',
        healthNotes: dogData['health_notes'] as String? ?? '',
        preferredTrainingTimes: dogData['preferred_training_times'] as String? ?? 'Flexible',
        trainingPath: dogData['training_path'] as String? ?? 'Happy Pet / Family Manners',
        notes: dogData['notes'] as String? ?? '',
      );
      state.addDog(dog);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Family profile saved')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2A4A),
        foregroundColor: Colors.white,
        title: const Text('Your Family & Dogs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Tell us about your family and up to 3 dogs. A well-trained dog is a happy dog — and a happier family.',
            style: TextStyle(fontSize: 16, color: Color(0xFF1A2A4A), height: 1.4),
          ),
          const SizedBox(height: 20),
          _sectionTitle('About You'),
          TextFormField(controller: _ownerName, decoration: const InputDecoration(labelText: 'Your name / family name')),
          TextFormField(controller: _ownerEmail, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
          TextFormField(controller: _ownerPhone, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone),
          TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'City / area (optional)')),
          const SizedBox(height: 28),
          _sectionTitle('Your Dogs (up to 3)'),
          ...List.generate(_forms.length, (i) => _DogCard(
            form: _forms[i],
            index: i,
            onRemove: () => _removeDog(i),
          )),
          if (_forms.length < 3)
            OutlinedButton.icon(
              onPressed: _addDog,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Dog'),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF1A2A4A), side: const BorderSide(color: Color(0xFFD4AF37), width: 2)),
            ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: _saveAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: const Color(0xFF1A2A4A),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Save Family Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
  );
}

class _DogForm {
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final temperamentController = TextEditingController();
  final fearsController = TextEditingController();
  final goalsController = TextEditingController();
  final habitsController = TextEditingController();
  final healthController = TextEditingController();
  final notesController = TextEditingController();
  String size = 'Medium';
  String trainingPath = 'Happy Pet / Family Manners';

  Map<String, dynamic> toMap({
    required String familyName,
    required String ownerEmail,
    required String ownerPhone,
    required String address,
  }) => {
    'name': nameController.text.trim(),
    'breed': breedController.text.trim(),
    'age': int.tryParse(ageController.text) ?? 0,
    'size': size,
    'temperament': temperamentController.text.trim(),
    'fears': fearsController.text.trim(),
    'goals': goalsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
    'habits': habitsController.text.trim(),
    'health_notes': healthController.text.trim(),
    'notes': notesController.text.trim(),
    'preferred_training_times': 'Flexible',
    'training_path': trainingPath,
    'family_name': familyName,
    'owner_email': ownerEmail,
    'owner_phone': ownerPhone,
    'address': address,
  };
}

class _DogCard extends StatelessWidget {
  final _DogForm form;
  final int index;
  final VoidCallback onRemove;

  const _DogCard({required this.form, required this.index, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Dog ${index + 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
                const Spacer(),
                if (index > 0)
                  IconButton(icon: const Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: onRemove),
              ],
            ),
            TextFormField(controller: form.nameController, decoration: const InputDecoration(labelText: 'Name *')),
            TextFormField(controller: form.breedController, decoration: const InputDecoration(labelText: 'Breed')),
            TextFormField(controller: form.ageController, decoration: const InputDecoration(labelText: 'Age (years)'), keyboardType: TextInputType.number),
            DropdownButtonFormField<String>(
              value: form.size,
              decoration: const InputDecoration(labelText: 'Size'),
              items: ['Small', 'Medium', 'Large', 'Giant'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => form.size = v ?? 'Medium',
            ),
            DropdownButtonFormField<String>(
              value: form.trainingPath,
              decoration: const InputDecoration(labelText: 'Primary training path'),
              items: const [
                'Happy Pet / Family Manners',
                'AKC S.T.A.R. Puppy',
                'AKC CGC / CGCA / CGCU',
                'ADI Public Access / Service Dog',
                'PSD / ESA / Therapy',
                'Trick Dog',
                'NAVHDA / Hunting',
                'European / JGHV',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => form.trainingPath = v ?? form.trainingPath,
            ),
            TextFormField(controller: form.temperamentController, decoration: const InputDecoration(labelText: 'Temperament / personality'), maxLines: 2),
            TextFormField(controller: form.fearsController, decoration: const InputDecoration(labelText: 'Fears, triggers, or things to avoid'), maxLines: 2),
            TextFormField(controller: form.goalsController, decoration: const InputDecoration(labelText: 'Goals (comma separated)', hintText: 'Better walks, CGC, public access...')),
            TextFormField(controller: form.habitsController, decoration: const InputDecoration(labelText: 'Daily routine / habits'), maxLines: 2),
            TextFormField(controller: form.healthController, decoration: const InputDecoration(labelText: 'Health notes (optional)'), maxLines: 2),
            TextFormField(controller: form.notesController, decoration: const InputDecoration(labelText: 'Anything else we should know'), maxLines: 2),
          ],
        ),
      ),
    );
  }
}
