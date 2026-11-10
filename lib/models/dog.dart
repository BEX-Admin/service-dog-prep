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
  final String ownerEmail;
  final String ownerPhone;
  final String address;
  final String habits;
  final String healthNotes;
  final String preferredTrainingTimes;
  final int numberOfTrainers;
  final String trainingPath; // e.g. ADI Public Access, AKC CGC, NAVHDA, etc.
  final String notes;
  final String akcName;
  final String akcNumber;
  final String birthdate;
  final String allergies;
  final String city;
  final String state;
  final String zip;
  final String billingAddress;
  final String microchip;
  final String vetName;
  final String vetContact;
  final String badHabits;

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
    this.ownerEmail = '',
    this.ownerPhone = '',
    this.address = '',
    this.habits = '',
    this.healthNotes = '',
    this.preferredTrainingTimes = 'Flexible',
    this.numberOfTrainers = 1,
    this.trainingPath = 'Happy Pet / Family Manners',
    this.notes = '',
    this.akcName = '',
    this.akcNumber = '',
    this.birthdate = '',
    this.allergies = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.billingAddress = '',
    this.microchip = '',
    this.vetName = '',
    this.vetContact = '',
    this.badHabits = '',
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
      photos: List<String>.from(map['photos'] ?? []),
      familyName: map['family_name'] ?? '',
      contact: map['contact'] ?? '',
      ownerEmail: map['owner_email'] ?? '',
      ownerPhone: map['owner_phone'] ?? '',
      address: map['address'] ?? '',
      habits: map['habits'] ?? '',
      healthNotes: map['health_notes'] ?? '',
      preferredTrainingTimes: map['preferred_training_times'] ?? '',
      numberOfTrainers: map['number_of_trainers'] ?? 1,
      trainingPath: map['training_path'] ?? 'Happy Pet / Family Manners',
      notes: map['notes'] ?? '',
      akcName: map['akc_name'] ?? '',
      akcNumber: map['akc_number'] ?? '',
      birthdate: map['birthdate'] ?? '',
      allergies: map['allergies'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zip: map['zip'] ?? '',
      billingAddress: map['billing_address'] ?? '',
      microchip: map['microchip'] ?? '',
      vetName: map['vet_name'] ?? '',
      vetContact: map['vet_contact'] ?? '',
      badHabits: map['bad_habits'] ?? '',
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
        'photos': photos,
        'family_name': familyName,
        'contact': contact,
        'owner_email': ownerEmail,
        'owner_phone': ownerPhone,
        'address': address,
        'habits': habits,
        'health_notes': healthNotes,
        'preferred_training_times': preferredTrainingTimes,
        'number_of_trainers': numberOfTrainers,
        'training_path': trainingPath,
        'notes': notes,
        'akc_name': akcName,
        'akc_number': akcNumber,
        'birthdate': birthdate,
        'allergies': allergies,
        'city': city,
        'state': state,
        'zip': zip,
        'billing_address': billingAddress,
        'microchip': microchip,
        'vet_name': vetName,
        'vet_contact': vetContact,
        'bad_habits': badHabits,
      };
}
