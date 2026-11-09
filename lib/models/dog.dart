class Dog {
  final String id;
  final String name;
  final String breed;
  final int age;
  final String size;
  final String temperament;
  final String fears;
  final List<String> goals;
  final List<String> photos;
  final String familyName;
  final String contact;
  final String habits;
  final String healthNotes;
  final String preferredTrainingTimes;
  final int numberOfTrainers;

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.size,
    required this.temperament,
    required this.fears,
    required this.goals,
    this.photos = const [],
    this.familyName = '',
    this.contact = '',
    this.habits = '',
    this.healthNotes = '',
    this.preferredTrainingTimes = 'Evenings',
    this.numberOfTrainers = 1,
  });

  factory Dog.fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age'] ?? 0,
      size: map['size'] ?? '',
      temperament: map['temperament'] ?? '',
      fears: map['fears'] ?? '',
      goals: List<String>.from(map['goals'] ?? []),
      familyName: map['family_name'] ?? '',
      contact: map['contact'] ?? '',
      habits: map['habits'] ?? '',
      healthNotes: map['health_notes'] ?? '',
      preferredTrainingTimes: map['preferred_training_times'] ?? '',
      numberOfTrainers: map['number_of_trainers'] ?? 1,
    );
  }

  Map<String, dynamic> toMap(String userId) => {
        'user_id': userId,
        'name': name,
        'breed': breed,
        'age': age,
        'size': size,
        'temperament': temperament,
        'fears': fears,
        'goals': goals,
        'family_name': familyName,
        'contact': contact,
        'habits': habits,
        'health_notes': healthNotes,
        'preferred_training_times': preferredTrainingTimes,
        'number_of_trainers': numberOfTrainers,
      };
}
