class TrainingSession {
  final String id;
  final String dogId;
  final DateTime date;
  final Map<String, double> behaviorScores;
  final String notes;
  final String methodUsed;
  final List<String> opportunityErrors;

  TrainingSession({
    required this.id,
    required this.dogId,
    required this.date,
    required this.behaviorScores,
    required this.notes,
    required this.methodUsed,
    required this.opportunityErrors,
  });
}
