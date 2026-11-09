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

  void login({required bool professional}) {
    isLoggedIn = true;
    isProfessional = professional;
    dogs = [
      Dog(
        id: 'demo-1',
        name: 'Demo Dog',
        breed: 'Labrador Retriever',
        age: 2,
        size: 'Large',
        temperament: 'Calm, eager to please',
        fears: 'Loud noises',
        goals: ['CGC', 'Public Access'],
        familyName: 'Demo Family',
        contact: 'demo@example.com',
        habits: 'Enjoys walks, settles well at home',
        healthNotes: 'Healthy, up to date on vaccines',
        preferredTrainingTimes: 'Morning and evening',
        numberOfTrainers: 2,
      ),
    ];
    currentDogId = 'demo-1';
    for (var skill in SkillLibrary.allSkills) {
      skillMastery[skill.id] = 0.3;
    }
    notifyListeners();
    _loadRemoteDogs();
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

  void logout() {
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
