import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/dog.dart';

String formatUsPhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';
  final d = digits.length > 10 ? digits.substring(0, 10) : digits;
  if (d.length <= 3) return '($d';
  if (d.length <= 6) return '(${d.substring(0, 3)}) ${d.substring(3)}';
  return '(${d.substring(0, 3)}) ${d.substring(3, 6)}-${d.substring(6)}';
}

String formatBirthdate(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';
  final d = digits.length > 8 ? digits.substring(0, 8) : digits;
  if (d.length <= 2) return d;
  if (d.length <= 4) return '${d.substring(0, 2)}/${d.substring(2)}';
  return '${d.substring(0, 2)}/${d.substring(2, 4)}/${d.substring(4)}';
}



class UsPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final d = digits.length > 10 ? digits.substring(0, 10) : digits;
    String formatted;
    if (d.isEmpty) formatted = '';
    else if (d.length <= 3) formatted = '($d';
    else if (d.length <= 6) formatted = '(${d.substring(0, 3)}) ${d.substring(3)}';
    else formatted = '(${d.substring(0, 3)}) ${d.substring(3, 6)}-${d.substring(6)}';
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

class BirthdateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final d = digits.length > 8 ? digits.substring(0, 8) : digits;
    String formatted;
    if (d.isEmpty) formatted = '';
    else if (d.length <= 2) formatted = d;
    else if (d.length <= 4) formatted = '${d.substring(0, 2)}/${d.substring(2)}';
    else formatted = '${d.substring(0, 2)}/${d.substring(2, 4)}/${d.substring(4)}';
    return TextEditingValue(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

int ageFromBirthdate(String mmddyyyy) {
  final parts = mmddyyyy.split('/');
  if (parts.length != 3 || parts[2].length != 4) return 0;
  final month = int.tryParse(parts[0]) ?? 0;
  final day = int.tryParse(parts[1]) ?? 0;
  final year = int.tryParse(parts[2]) ?? 0;
  if (month < 1 || month > 12 || day < 1 || year < 1900) return 0;
  final now = DateTime.now();
  int age = now.year - year;
  if (now.month < month || (now.month == month && now.day < day)) age--;
  return age < 0 ? 0 : age;
}


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
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _zip = TextEditingController();
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
      String dogId = DateTime.now().millisecondsSinceEpoch.toString() + form.nameController.text;
      if (user != null) {
        dogData['user_id'] = user.id;
        try {
          final inserted = await state.supabaseService.insertDog(dogData);
          if (inserted != null && inserted['id'] != null) {
            dogId = inserted['id'].toString();
          }
        } catch (e) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cloud save failed: $e')));
        }
      }
      final dog = Dog(
        id: dogId,
        name: dogData['name'] as String,
        breed: dogData['breed'] as String? ?? '',
        age: dogData['age'] as int? ?? 0,
        size: dogData['size'] as String? ?? 'Medium',
        temperament: dogData['temperament'] as String? ?? '',
        fears: dogData['fears'] as String? ?? '',
        goals: List<String>.from(dogData['goals'] ?? []),
        photos: List<String>.from(dogData['photos'] ?? []),
        familyName: dogData['family_name'] as String? ?? '',
        ownerEmail: dogData['owner_email'] as String? ?? '',
        ownerPhone: dogData['owner_phone'] as String? ?? '',
        address: dogData['address'] as String? ?? '',
        habits: dogData['habits'] as String? ?? '',
        healthNotes: dogData['health_notes'] as String? ?? '',
        preferredTrainingTimes: dogData['preferred_training_times'] as String? ?? 'Flexible',
        trainingPath: dogData['training_path'] as String? ?? 'Happy Pet / Family Manners',
        notes: dogData['notes'] as String? ?? '',
        akcName: dogData['akc_name'] as String? ?? '',
        akcNumber: dogData['akc_number'] as String? ?? '',
        birthdate: dogData['birthdate'] as String? ?? '',
        allergies: dogData['allergies'] as String? ?? '',
        microchip: dogData['microchip'] as String? ?? '',
        vetName: dogData['vet_name'] as String? ?? '',
        vetContact: dogData['vet_contact'] as String? ?? '',
        badHabits: dogData['bad_habits'] as String? ?? '',
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
          TextFormField(
            controller: _ownerPhone,
            decoration: const InputDecoration(labelText: 'Phone', hintText: '(555) 123-4567'),
            keyboardType: TextInputType.phone,
            inputFormatters: [UsPhoneFormatter()],
          ),
          TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address')),
          Row(
            children: [
              Expanded(flex: 3, child: TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'))),
              const SizedBox(width: 8),
              Expanded(flex: 1, child: TextFormField(controller: _state, decoration: const InputDecoration(labelText: 'State'))),
              const SizedBox(width: 8),
              Expanded(flex: 2, child: TextFormField(controller: _zip, decoration: const InputDecoration(labelText: 'Zip'), keyboardType: TextInputType.number)),
            ],
          ),
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
  final akcNameController = TextEditingController();
  final akcNumberController = TextEditingController();
  final breedController = TextEditingController();
  final ageController = TextEditingController();
  final birthdateController = TextEditingController();
  final allergiesController = TextEditingController();
  final microchipController = TextEditingController();
  final vetNameController = TextEditingController();
  final vetContactController = TextEditingController();
  String? photoUrl;
  final temperamentController = TextEditingController();
  final fearsController = TextEditingController();
  final goalsController = TextEditingController();
  final habitsController = TextEditingController();
  final badHabitsController = TextEditingController();
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
    'akc_name': akcNameController.text.trim(),
    'akc_number': akcNumberController.text.trim(),
    'breed': breedController.text.trim(),
    'age': int.tryParse(ageController.text) ?? 0,
    'birthdate': birthdateController.text.trim(),
    'allergies': allergiesController.text.trim(),
    'microchip': microchipController.text.trim(),
    'vet_name': vetNameController.text.trim(),
    'vet_contact': vetContactController.text.trim(),
    'photos': photoUrl != null ? [photoUrl] : [],
    'size': size,
    'temperament': temperamentController.text.trim(),
    'fears': fearsController.text.trim(),
    'goals': goalsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
    'habits': habitsController.text.trim(),
    'bad_habits': badHabitsController.text.trim(),
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
            TextFormField(controller: form.akcNameController, decoration: const InputDecoration(labelText: 'AKC registered name (if any)')),
            TextFormField(controller: form.akcNumberController, decoration: const InputDecoration(labelText: 'AKC number (if registered)')),
            TextFormField(
              controller: form.birthdateController,
              decoration: const InputDecoration(labelText: 'Birthdate (MM/DD/YYYY)', hintText: 'MM/DD/YYYY'),
              keyboardType: TextInputType.number,
              inputFormatters: [BirthdateFormatter()],
              onChanged: (v) {
                final age = ageFromBirthdate(v);
                if (age > 0) form.ageController.text = age.toString();
              },
            ),
            _BreedField(controller: form.breedController),
            TextFormField(controller: form.ageController, decoration: const InputDecoration(labelText: 'Age (calculated from birthdate)'), readOnly: true),
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
                'AKC S.T.A.R. Puppy (early socialization)',
                'AKC Canine Good Citizen (CGC) and Advanced / Urban',
                'Assistance Dogs International Public Access / Service Dog',
                'Psychiatric Service Dog (PSD)',
                'Emotional Support Animal (ESA)',
                'Therapy Dog',
                'Trick Dog',
                'Hunting dog standards (NAVHDA, AKC Hunt Tests)',
                'European / JGHV field standards',
              ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => form.trainingPath = v ?? form.trainingPath,
            ),
            TextFormField(controller: form.temperamentController, decoration: const InputDecoration(labelText: 'Temperament / personality'), maxLines: 2),
            TextFormField(controller: form.fearsController, decoration: const InputDecoration(labelText: 'Fears, triggers, or things to avoid'), maxLines: 2),
            TextFormField(controller: form.goalsController, decoration: const InputDecoration(labelText: 'Goals (comma separated)', hintText: 'Better walks, CGC, public access...')),
            TextFormField(controller: form.habitsController, decoration: const InputDecoration(labelText: 'Daily routine / habits'), maxLines: 2),
            TextFormField(controller: form.badHabitsController, decoration: const InputDecoration(labelText: 'Bad habits (chewing, destructive when alone, howling, etc.)'), maxLines: 2),
            TextFormField(controller: form.healthController, decoration: const InputDecoration(labelText: 'Health notes (optional)'), maxLines: 2),
            TextFormField(controller: form.allergiesController, decoration: const InputDecoration(labelText: 'Allergies / food sensitivities'), maxLines: 2),
            TextFormField(controller: form.microchipController, decoration: const InputDecoration(labelText: 'Microchip number')),
            TextFormField(controller: form.vetNameController, decoration: const InputDecoration(labelText: 'Veterinarian name')),
            TextFormField(controller: form.vetContactController, decoration: const InputDecoration(labelText: 'Vet phone / email')),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final source = await showModalBottomSheet<ImageSource>(
                  context: context,
                  builder: (ctx) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_camera),
                          title: const Text('Take photo'),
                          onTap: () => Navigator.pop(ctx, ImageSource.camera),
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Choose from gallery'),
                          onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                        ),
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
                final dogId = form.nameController.text.trim().isEmpty ? 'new' : form.nameController.text.trim();
                try {
                  final url = await state.supabaseService.uploadDogPhoto(dogId, picked.name, bytes);
                  form.photoUrl = url;
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo uploaded')));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
                  }
                }
              },
              icon: const Icon(Icons.photo_camera),
              label: Text(form.photoUrl == null ? 'Add dog photo' : 'Photo added — tap to replace'),
            ),
            TextFormField(controller: form.notesController, decoration: const InputDecoration(labelText: 'Anything else we should know'), maxLines: 2),
          ],
        ),
      ),
    );
  }
}

class _BreedField extends StatefulWidget {
  final TextEditingController controller;
  const _BreedField({required this.controller});
  @override
  State<_BreedField> createState() => _BreedFieldState();
}

class _BreedFieldState extends State<_BreedField> {
  static const _breeds = [
    'Labrador Retriever', 'Golden Retriever', 'German Shepherd', 'French Bulldog', 'Poodle',
    'Bulldog', 'Beagle', 'Rottweiler', 'German Shorthaired Pointer', 'Dachshund',
    'Pembroke Welsh Corgi', 'Australian Shepherd', 'Yorkshire Terrier', 'Boxer', 'Cavalier King Charles Spaniel',
    'Doberman Pinscher', 'Great Dane', 'Miniature Schnauzer', 'Siberian Husky', 'Bernese Mountain Dog',
    'Shih Tzu', 'Boston Terrier', 'Pomeranian', 'Havanese', 'Shetland Sheepdog',
    'Brittany', 'English Springer Spaniel', 'Cocker Spaniel', 'Border Collie', 'Maltese',
    'Boykin Spaniel', 'Vizsla', 'Weimaraner', 'Portuguese Water Dog', 'Standard Schnauzer',
    'Mixed Breed', 'Other',
  ];
  String _query = '';
  bool _isMix = false;

  @override
  Widget build(BuildContext context) {
    final matches = _query.isEmpty
        ? _breeds
        : _breeds.where((b) => b.toLowerCase().contains(_query.toLowerCase())).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          decoration: const InputDecoration(labelText: 'Breed (search AKC & international)', hintText: 'Start typing...'),
          onChanged: (v) => setState(() => _query = v),
        ),
        if (_query.isNotEmpty && matches.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 140),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
            child: ListView(
              shrinkWrap: true,
              children: matches.take(8).map((b) => ListTile(
                dense: true,
                title: Text(b),
                onTap: () {
                  if (b == 'Mixed Breed') {
                    setState(() {
                      _isMix = true;
                      widget.controller.text = 'Mixed: ';
                      _query = '';
                    });
                  } else if (b == 'Other') {
                    setState(() {
                      widget.controller.text = 'Other: ';
                      _query = '';
                    });
                  } else {
                    setState(() {
                      widget.controller.text = b;
                      _query = '';
                    });
                  }
                },
              )).toList(),
            ),
          ),
        if (_isMix) ...[
          const SizedBox(height: 4),
          const Text('Enter up to 3 breeds in the mix (optional)', style: TextStyle(fontSize: 12, color: Colors.grey)),
          TextFormField(decoration: const InputDecoration(labelText: 'Mix breed 1')),
          TextFormField(decoration: const InputDecoration(labelText: 'Mix breed 2')),
          TextFormField(decoration: const InputDecoration(labelText: 'Mix breed 3')),
        ],
      ],
    );
  }
}
