import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

class SupabaseService {
  SupabaseClient get client => supabase;

  Stream<AuthState> get authState => client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async => client.auth.signOut();

  User? get currentUser => client.auth.currentUser;

  Future<List<Map<String, dynamic>>> getDogs(String userId) async {
    final response = await client.from('dogs').select().eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertDog(Map<String, dynamic> dog) async {
    const allowed = {
      'user_id', 'name', 'breed', 'age', 'size', 'temperament', 'fears', 'goals',
      'family_name', 'contact', 'owner_email', 'owner_phone', 'address',
      'habits', 'health_notes', 'preferred_training_times', 'number_of_trainers',
      'training_path', 'notes', 'akc_name', 'akc_number', 'birthdate', 'allergies',
      'city', 'state', 'zip', 'billing_address', 'microchip', 'vet_name',
      'vet_contact', 'bad_habits', 'photos',
    };
    final clean = <String, dynamic>{
      for (final e in dog.entries)
        if (allowed.contains(e.key) && e.value != null) e.key: e.value,
    };
    await client.from('dogs').insert(clean);
  }

  Future<void> updateDog(String id, Map<String, dynamic> dog) async {
    const allowed = {
      'name', 'breed', 'age', 'size', 'temperament', 'fears', 'goals',
      'family_name', 'contact', 'owner_email', 'owner_phone', 'address',
      'habits', 'health_notes', 'preferred_training_times', 'number_of_trainers',
      'training_path', 'notes', 'akc_name', 'akc_number', 'birthdate', 'allergies',
      'city', 'state', 'zip', 'billing_address', 'microchip', 'vet_name',
      'vet_contact', 'bad_habits', 'photos',
    };
    final clean = <String, dynamic>{
      for (final e in dog.entries)
        if (allowed.contains(e.key) && e.value != null) e.key: e.value,
    };
    await client.from('dogs').update(clean).eq('id', id);
  }

  Future<void> insertSession(Map<String, dynamic> session) async {
    await client.from('sessions').insert(session);
  }

  Future<String> uploadDogPhoto(String dogId, String filename, Uint8List bytes) async {
    final path = 'dogs/$dogId/$filename';
    await client.storage.from('dog-photos').uploadBinary(path, bytes);
    return client.storage.from('dog-photos').getPublicUrl(path);
  }
}
