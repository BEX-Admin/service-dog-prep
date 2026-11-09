import 'package:flutter/foundation.dart';
import '../models/dog.dart';
import '../models/training_session.dart';
import '../models/skill.dart';
import '../supabase/supabase_service.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  bool isProfessional = false;
  List<Dog> dogs = [];
  String? currentDogId;
  List<TrainingSession> sessions = [];
  Map<String, double> skillMastery = {};
  final SupabaseService supabaseService = SupabaseService();

  AppState() {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final user = supabaseService.currentUser;
      if (user != null) {
        isLoggedIn = true;
        // Keep professional flag simple for now; can be stored in user metadata later
        notifyListeners();
        await _loadRemoteDogs();
      }
    } catch (e) {
      debugPrint('Session restore failed: $e');
    }
  }

  void login({required bool professional}) {
    isLoggedIn = true;
    isProfessional = professional;
    dogs = [];
    currentDogId = null;
    for (var skill in SkillLibrary.allSkills) {
      skillMastery[skill.id] = 0.0;
    }
    notifyListeners();
    _loadRemoteDogs();
  }

  void removeDog(String id) {
    dogs.removeWhere((d) => d.id == id);
    if (currentDogId == id) {
      currentDogId = dogs.isNotEmpty ? dogs.first.id : null;
    }
    notifyListeners();
    // TODO: also delete from Supabase when user is signed in
  }

  Future<void> _loadRemoteDogs() async {
    try {
      final user = supabaseService.currentUser;
      if (user == null) return;
      final remoteDogs = await supabaseService.getDogs(user.id);
      if (remoteDogs.isNotEmpty) {
        dogs = remoteDogs.map((d) => Dog.fromMap(d)).toList();
        currentDogId = dogs.first.id;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Remote dog load failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await supabaseService.signOut();
    } catch (_) {}
    isLoggedIn = false;
    dogs.clear();
    sessions.clear();
    skillMastery.clear();
    notifyListeners();
  }

  void addDog(Dog dog) {
    dogs.add(dog);
    currentDogId = dog.id;
    notifyListeners();
  }

  Dog? get currentDog => dogs.isEmpty ? null : dogs.firstWhere((d) => d.id == currentDogId, orElse: () => dogs.first);

  void addSessionFeedback(TrainingSession session) async {
    sessions.add(session);
    session.behaviorScores.forEach((skillName, score) {
      final skill = SkillLibrary.allSkills.firstWhere(
        (s) => s.name == skillName,
        orElse: () => SkillLibrary.allSkills.first,
      );
      final current = skillMastery[skill.id] ?? 0.3;
      skillMastery[skill.id] = (current + score) / 2;
    });
    try {
      final user = supabaseService.currentUser;
      if (user != null) {
        await supabaseService.insertSession({
          'dog_id': session.dogId,
          'user_id': user.id,
          'behavior_scores': session.behaviorScores,
          'notes': session.notes,
          'method_used': session.methodUsed,
          'opportunity_errors': session.opportunityErrors,
        });
      }
    } catch (e) {
      debugPrint('Failed to save session: $e');
    }
    notifyListeners();
  }

  List<Skill> get focusSkills {
    return SkillLibrary.allSkills.where((s) => (skillMastery[s.id] ?? 0) < 0.7).take(5).toList();
  }
}
