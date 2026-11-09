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
    await client.from('dogs').insert(dog);
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
