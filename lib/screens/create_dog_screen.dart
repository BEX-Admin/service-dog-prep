import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/dog.dart';

class CreateDogScreen extends StatefulWidget {
  const CreateDogScreen({super.key});

  @override
  State<CreateDogScreen> createState() => _CreateDogScreenState();
}

class _CreateDogScreenState extends State<CreateDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _temperamentController = TextEditingController();
  final _fearsController = TextEditingController();
  final _goalsController = TextEditingController();
  final _familyController = TextEditingController();
  final _contactController = TextEditingController();
  final _habitsController = TextEditingController();
  final _healthController = TextEditingController();
  String _size = 'Medium';
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final state = context.read<AppState>();
      final user = state.supabaseService.currentUser;
      final dogData = {
        'name': _nameController.text.trim(),
        'breed': _breedController.text.trim(),
        'age': int.tryParse(_ageController.text) ?? 0,
        'size': _size,
        'temperament': _temperamentController.text.trim(),
        'fears': _fearsController.text.trim(),
        'goals': _goalsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
        'family_name': _familyController.text.trim(),
        'contact': _contactController.text.trim(),
        'habits': _habitsController.text.trim(),
        'health_notes': _healthController.text.trim(),
        'preferred_training_times': 'Flexible',
        'number_of_trainers': 1,
      };
      if (user != null) {
        dogData['user_id'] = user.id;
        await state.supabaseService.insertDog(dogData);
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
        contact: dogData['contact'] as String,
        habits: dogData['habits'] as String,
        healthNotes: dogData['health_notes'] as String,
      );
      state.addDog(dog);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Your Dog')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Dog Name *'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: 'Breed'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age (years)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _size,
              decoration: const InputDecoration(labelText: 'Size'),
              items: ['Small', 'Medium', 'Large', 'Giant']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _size = v ?? 'Medium'),
            ),
            TextFormField(
              controller: _temperamentController,
              decoration: const InputDecoration(labelText: 'Temperament'),
              maxLines: 2,
            ),
            TextFormField(
              controller: _fearsController,
              decoration: const InputDecoration(labelText: 'Fears / Triggers'),
              maxLines: 2,
            ),
            TextFormField(
              controller: _goalsController,
              decoration: const InputDecoration(
                labelText: 'Goals (comma separated)',
                hintText: 'CGC, Public Access, Urban CGC',
              ),
            ),
            TextFormField(
              controller: _familyController,
              decoration: const InputDecoration(labelText: 'Family Name'),
            ),
            TextFormField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
            ),
            TextFormField(
              controller: _habitsController,
              decoration: const InputDecoration(labelText: 'Habits'),
              maxLines: 2,
            ),
            TextFormField(
              controller: _healthController,
              decoration: const InputDecoration(labelText: 'Health Notes'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            _saving
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _save,
                    child: const Text('Save Dog'),
                  ),
          ],
        ),
      ),
    );
  }
}
