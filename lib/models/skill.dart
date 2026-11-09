class Skill {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> criteria;
  final String trainingTips;

  Skill({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.criteria,
    required this.trainingTips,
  });
}

class SkillLibrary {
  static final List<Skill> allSkills = [
    // ADI Public Access / Assistance Dog standards
    Skill(
      id: 'adi-1',
      name: 'ADI Public Access – Controlled Walking',
      description: 'Dog walks calmly beside the handler in public without pulling, lunging, or excessive sniffing.',
      category: 'ADI',
      criteria: ['Loose leash', 'Stays close', 'Ignores distractions'],
      trainingTips: 'Build duration and distraction gradually in real environments.',
    ),
    Skill(
      id: 'adi-2',
      name: 'ADI Public Access – Settling in Public',
      description: 'Dog settles quietly under a table, at feet, or in a designated space for extended periods.',
      category: 'ADI',
      criteria: ['Calm down-stay', 'No barking or whining', 'Remains settled when handler is seated'],
      trainingTips: 'Practice in cafes, waiting rooms, and transit.',
    ),
    // AKC S.T.A.R. Puppy
    Skill(
      id: 'star-1',
      name: 'AKC S.T.A.R. Puppy – Socialization Basics',
      description: 'Puppy accepts handling, different people, and novel environments calmly.',
      category: 'AKC STAR',
      criteria: ['Allows gentle handling', 'Meets people politely', 'Recovers from mild startles'],
      trainingTips: 'Positive exposures starting as early as 8 weeks.',
    ),
    // AKC CGC / Advanced / Urban
    Skill(
      id: 'cgc-1',
      name: 'AKC CGC – Accepting a Friendly Stranger',
      description: 'Dog allows a friendly stranger to approach and speak to the handler naturally.',
      category: 'AKC CGC',
      criteria: ['Remains calm', 'No aggression or excessive fear'],
      trainingTips: 'Practice with varied people in everyday settings.',
    ),
    Skill(
      id: 'cgca-1',
      name: 'AKC CGCA – Advanced Manners',
      description: 'Dog demonstrates reliable obedience and manners in community settings.',
      category: 'AKC CGCA',
      criteria: ['Reliable recall', 'Polite greeting', 'Stays when asked'],
      trainingTips: 'Proof in real community environments.',
    ),
    Skill(
      id: 'cgcu-1',
      name: 'AKC CGCU – Urban CGC',
      description: 'Dog handles elevators, traffic noise, crowded sidewalks, and urban distractions calmly.',
      category: 'AKC CGCU',
      criteria: ['Calm in elevators', 'Ignores traffic noise', 'Navigates crowds'],
      trainingTips: 'Systematic urban exposure with positive reinforcement.',
    ),
    // Trick Dog & Therapy
    Skill(
      id: 'trick-1',
      name: 'AKC Trick Dog – Foundation Tricks',
      description: 'Dog performs a variety of fun, handler-directed tricks with clear communication.',
      category: 'Trick Dog',
      criteria: ['Responds to cues', 'Enjoys the interaction', 'Reliable in familiar settings'],
      trainingTips: 'Use shaping and capture for engagement.',
    ),
    Skill(
      id: 'therapy-1',
      name: 'Therapy Dog Temperament',
      description: 'Dog remains calm, gentle, and appropriate for bedside or therapeutic visits.',
      category: 'Therapy Dog',
      criteria: ['Calm around people', 'Accepts handling', 'No jumping or mouthing'],
      trainingTips: 'Focus on settle and gentle greeting.',
    ),
    // Hunting / Field standards
    Skill(
      id: 'navhda-1',
      name: 'NAVHDA Natural Ability Foundations',
      description: 'Dog shows pointing, tracking, searching, water work, and basic obedience against a fixed standard.',
      category: 'NAVHDA',
      criteria: ['Natural ability expression', 'Cooperation with handler', 'Calm evaluation demeanor'],
      trainingTips: 'Expose to field, water, and tracking early with positive association.',
    ),
    Skill(
      id: 'akc-hunt-1',
      name: 'AKC Hunt Test – Junior Level',
      description: 'Dog meets objective retrieval and marking benchmarks under simulated hunting conditions.',
      category: 'AKC Hunt Tests',
      criteria: ['Reliable retrieve', 'Marks falls', 'Handles water entry'],
      trainingTips: 'Build steady marking and delivery.',
    ),
    Skill(
      id: 'ahdc-1',
      name: 'AHDC Hunting Instincts / Progression',
      description: 'Pass-fail progression from raw instinct (HID) through apprentice, trained, and master levels.',
      category: 'AHDC',
      criteria: ['Instinct expression', 'Control', 'Finished work'],
      trainingTips: 'Follow structured progression with clear criteria.',
    ),
    Skill(
      id: 'jghv-1',
      name: 'JGHV / European Utility Foundations',
      description: 'Multi-subject field, water, and track work aligned with VGP-style evaluations.',
      category: 'European / JGHV',
      criteria: ['Field work', 'Water work', 'Track work', 'Obedience'],
      trainingTips: 'Systematic multi-discipline preparation.',
    ),
    // Happy Pet / Family
    Skill(
      id: 'family-1',
      name: 'Happy Pet – Loose Leash Walking',
      description: 'Dog walks politely on leash so walks are enjoyable for everyone.',
      category: 'Happy Pet',
      criteria: ['Loose leash most of the time', 'Checks in with handler'],
      trainingTips: 'Reward position and engagement frequently.',
    ),
  ];

  static List<String> get categories => allSkills.map((s) => s.category).toSet().toList();
}
