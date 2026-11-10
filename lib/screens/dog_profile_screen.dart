import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/dog.dart';
import 'app_shell.dart';

class DogProfileScreen extends StatefulWidget {
  const DogProfileScreen({super.key});

  @override
  State<DogProfileScreen> createState() => _DogProfileScreenState();
}

class _DogProfileScreenState extends State<DogProfileScreen> {
  late TextEditingController _name;
  late TextEditingController _breed;
  late TextEditingController _birthdate;
  late TextEditingController _temperament;
  late TextEditingController _fears;
  late TextEditingController _goals;
  late TextEditingController _habits;
  late TextEditingController _badHabits;
  late TextEditingController _health;
  late TextEditingController _allergies;
  late TextEditingController _microchip;
  late TextEditingController _vetName;
  late TextEditingController _vetContact;
  late TextEditingController _notes;
  late TextEditingController _akcName;
  late TextEditingController _akcNumber;
  String _trainingPath = 'Happy Pet / Family Manners';
  bool _editing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dog = context.read<AppState>().currentDog;
    if (dog == null) return;
    _name = TextEditingController(text: dog.name);
    _breed = TextEditingController(text: dog.breed);
    _birthdate = TextEditingController(text: dog.birthdate);
    _temperament = TextEditingController(text: dog.temperament);
    _fears = TextEditingController(text: dog.fears);
    _goals = TextEditingController(text: dog.goals.join(', '));
    _habits = TextEditingController(text: dog.habits);
    _badHabits = TextEditingController(text: dog.badHabits);
    _health = TextEditingController(text: dog.healthNotes);
    _allergies = TextEditingController(text: dog.allergies);
    _microchip = TextEditingController(text: dog.microchip);
    _vetName = TextEditingController(text: dog.vetName);
    _vetContact = TextEditingController(text: dog.vetContact);
    _notes = TextEditingController(text: dog.notes);
    _akcName = TextEditingController(text: dog.akcName);
    _akcNumber = TextEditingController(text: dog.akcNumber);
    _notes = TextEditingController(text: dog.notes);
    _trainingPath = dog.trainingPath;
  }

  Future<void> _save() async {
    final state = context.read<AppState>();
    final old = state.currentDog;
    if (old == null) return;
    final updated = Dog(
      id: old.id,
      name: _name.text.trim(),
      breed: _breed.text.trim(),
      age: ageFromBirthdate(_birthdate.text),
      size: old.size,
      temperament: _temperament.text.trim(),
      fears: _fears.text.trim(),
      goals: _goals.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      familyName: old.familyName,
      contact: old.contact,
      ownerEmail: old.ownerEmail,
      ownerPhone: old.ownerPhone,
      address: old.address,
      habits: _habits.text.trim(),
      healthNotes: _health.text.trim(),
      preferredTrainingTimes: old.preferredTrainingTimes,
      numberOfTrainers: old.numberOfTrainers,
      trainingPath: _trainingPath,
      notes: _notes.text.trim(),
      akcName: _akcName.text.trim(),
      akcNumber: _akcNumber.text.trim(),
      birthdate: _birthdate.text.trim(),
      allergies: _allergies.text.trim(),
      city: old.city,
      state: old.state,
      zip: old.zip,
      billingAddress: old.billingAddress,
      microchip: _microchip.text.trim(),
      vetName: _vetName.text.trim(),
      vetContact: _vetContact.text.trim(),
      badHabits: _badHabits.text.trim(),
      photos: old.photos,
    );
    state.removeDog(old.id);
    state.addDog(updated);
    // Persist to Supabase
    try {
      await state.supabaseService.updateDog(old.id, updated.toMap(state.supabaseService.currentUser?.id ?? ''));
    } catch (e) {
      debugPrint('Update failed: $e');
    }
    setState(() => _editing = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dog profile updated')));
  }

  int ageFromBirthdate(String mmddyyyy) {
    final parts = mmddyyyy.split('/');
    if (parts.length != 3 || parts[2].length != 4) return 0;
    final month = int.tryParse(parts[0]) ?? 0;
    final day = int.tryParse(parts[1]) ?? 0;
    final year = int.tryParse(parts[2]) ?? 0;
    if (month < 1 || year < 1900) return 0;
    final now = DateTime.now();
    int age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) age--;
    return age < 0 ? 0 : age;
  }

  @override
  Widget build(BuildContext context) {
    final dog = context.watch<AppState>().currentDog;
    if (dog == null) {
      return AppShell(title: 'Dog Profile', body: const Center(child: Text('No dog selected')));
    }
    return AppShell(
      title: 'Dog Profile',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (dog.photos.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(dog.photos.first, height: 180, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox()),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(dog.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _editing = !_editing),
                child: Text(_editing ? 'Cancel' : 'Edit'),
              ),
            ],
          ),
          if (!_editing) ...[
            _row('Breed', dog.breed),
            _row('AKC name', dog.akcName),
            _row('AKC number', dog.akcNumber),
            _row('Birthdate', dog.birthdate),
            _row('Age', '${dog.age} years'),
            _row('Training path', dog.trainingPath),
            _row('Temperament', dog.temperament),
            _row('Fears', dog.fears),
            _row('Goals', dog.goals.join(', ')),
            _row('Habits', dog.habits),
            _row('Bad habits', dog.badHabits),
            _row('Health', dog.healthNotes),
            _row('Allergies', dog.allergies),
            _row('Microchip', dog.microchip),
            _row('Vet', '${dog.vetName} ${dog.vetContact}'),
          ] else ...[
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
            TextFormField(controller: _breed, decoration: const InputDecoration(labelText: 'Breed')),
            TextFormField(controller: _akcName, decoration: const InputDecoration(labelText: 'AKC registered name')),
            TextFormField(controller: _akcNumber, decoration: const InputDecoration(labelText: 'AKC number')),
            TextFormField(controller: _birthdate, decoration: const InputDecoration(labelText: 'Birthdate (MM/DD/YYYY)')),
            TextFormField(controller: _temperament, decoration: const InputDecoration(labelText: 'Temperament'), maxLines: 2),
            TextFormField(controller: _fears, decoration: const InputDecoration(labelText: 'Fears'), maxLines: 2),
            TextFormField(controller: _goals, decoration: const InputDecoration(labelText: 'Goals (comma separated)')),
            TextFormField(controller: _habits, decoration: const InputDecoration(labelText: 'Habits'), maxLines: 2),
            TextFormField(controller: _badHabits, decoration: const InputDecoration(labelText: 'Bad habits'), maxLines: 2),
            TextFormField(controller: _health, decoration: const InputDecoration(labelText: 'Health notes'), maxLines: 2),
            TextFormField(controller: _allergies, decoration: const InputDecoration(labelText: 'Allergies / food sensitivities'), maxLines: 2),
            TextFormField(controller: _microchip, decoration: const InputDecoration(labelText: 'Microchip number')),
            TextFormField(controller: _vetName, decoration: const InputDecoration(labelText: 'Vet name')),
            TextFormField(controller: _vetContact, decoration: const InputDecoration(labelText: 'Vet phone / email')),
            TextFormField(controller: _notes, decoration: const InputDecoration(labelText: 'Notes'), maxLines: 2),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final source = await showModalBottomSheet<ImageSource>(
                  context: context,
                  builder: (ctx) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Take photo'), onTap: () => Navigator.pop(ctx, ImageSource.camera)),
                        ListTile(leading: const Icon(Icons.photo_library), title: const Text('Choose from gallery'), onTap: () => Navigator.pop(ctx, ImageSource.gallery)),
                      ],
                    ),
                  ),
                );
                if (source == null) return;
                final picker = ImagePicker();
                final picked = await picker.pickImage(source: source, maxWidth: 1600, imageQuality: 80);
                if (picked == null) return;
                final bytes = await picked.readAsBytes();
                final state = context.read<AppState>();
                try {
                  final url = await state.supabaseService.uploadDogPhoto(dog.id, picked.name, bytes);
                  final updated = Dog(
                    id: dog.id, name: dog.name, breed: dog.breed, age: dog.age, size: dog.size,
                    temperament: dog.temperament, fears: dog.fears, goals: dog.goals,
                    photos: [url], familyName: dog.familyName, contact: dog.contact,
                    ownerEmail: dog.ownerEmail, ownerPhone: dog.ownerPhone, address: dog.address,
                    habits: dog.habits, healthNotes: dog.healthNotes, trainingPath: dog.trainingPath,
                    notes: dog.notes, birthdate: dog.birthdate, allergies: dog.allergies,
                    microchip: dog.microchip, vetName: dog.vetName, vetContact: dog.vetContact,
                    badHabits: dog.badHabits,
                  );
                  state.removeDog(dog.id);
                  state.addDog(updated);
                  await state.supabaseService.updateDog(dog.id, updated.toMap(state.supabaseService.currentUser?.id ?? ''));
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo uploaded')));
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
                }
              },
              icon: const Icon(Icons.photo_camera),
              label: const Text('Add / replace photo'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37), foregroundColor: const Color(0xFF1A2A4A)),
              child: const Text('Save changes'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) => ListTile(
    title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A2A4A))),
    subtitle: Text(value.isEmpty ? '—' : value),
  );
}
