class WorkoutSession {
  const WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.workoutName,
    required this.startedAt,
    required this.durationSeconds,
    required this.completedRounds,
    required this.completedSets,
    required this.wasCompleted,
  });

  final String id;
  final String workoutId;
  final String workoutName;
  final DateTime startedAt;
  final int durationSeconds;
  final int completedRounds;
  final int completedSets;
  final bool wasCompleted;
}

class DailySessionTotal {
  const DailySessionTotal({
    required this.date,
    required this.completedSessions,
    required this.durationSeconds,
  });

  final DateTime date;
  final int completedSessions;
  final int durationSeconds;
}
