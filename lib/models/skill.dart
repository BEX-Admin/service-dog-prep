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
    Skill(
      id: 'cgc-1',
      name: 'Accepting a Friendly Stranger',
      description: 'Dog allows a friendly stranger to approach and speak to the handler in a natural, everyday situation.',
      category: 'CGC',
      criteria: ['Dog remains calm', 'Does not show aggression or excessive fear'],
      trainingTips: 'Practice with different people in various settings.',
    ),
    Skill(
      id: 'cgc-2',
      name: 'Sitting Politely for Petting',
      description: 'Dog allows a friendly stranger to touch it while it is out with its handler.',
      category: 'CGC',
      criteria: ['Dog sits or stands calmly', 'Accepts petting without jumping or mouthing'],
      trainingTips: 'Reward calm behavior during handling.',
    ),
    Skill(
      id: 'public-1',
      name: 'Public Access Walking',
      description: 'Dog walks calmly on leash in public environments without pulling.',
      category: 'PublicAccess',
      criteria: ['Loose leash', 'Ignores distractions'],
      trainingTips: 'Start in low-distraction areas and build up.',
    ),
  ];
}
