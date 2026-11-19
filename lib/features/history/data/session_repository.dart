import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../domain/workout_session.dart';

class SessionRepository {
  SessionRepository(this._box);

  final Box<String> _box;

  Future<List<WorkoutSession>> list() async {
    final sessions = _box.values.map(_decode).toList()
      ..sort((left, right) => right.startedAt.compareTo(left.startedAt));
    return List<WorkoutSession>.unmodifiable(sessions);
  }

  Future<void> recordCompleted(WorkoutSession session) async {
    if (!session.wasCompleted) {
      throw ArgumentError.value(
        session.wasCompleted,
        'session.wasCompleted',
        'Only completed sessions belong in workout history.',
      );
    }
    await _box.put(session.id, _encode(session));
  }

  Future<void> delete(String id) => _box.delete(id);

  Future<void> clear() => _box.clear();

  Future<List<DailySessionTotal>> weeklySummary({DateTime? anchorDate}) async {
    final anchor = anchorDate ?? DateTime.now();
    final lastDay = DateTime(anchor.year, anchor.month, anchor.day);
    final firstDay = lastDay.subtract(const Duration(days: 6));
    final totals = List.generate(
      7,
      (index) => DailySessionTotal(
        date: firstDay.add(Duration(days: index)),
        completedSessions: 0,
        durationSeconds: 0,
      ),
    );
    final counts = List<int>.filled(7, 0);
    final durations = List<int>.filled(7, 0);
    for (final session in await list()) {
      final localStart = session.startedAt.toLocal();
      final day = DateTime(localStart.year, localStart.month, localStart.day);
      final index = day.difference(firstDay).inDays;
      if (index < 0 || index >= 7) continue;
      counts[index]++;
      durations[index] += session.durationSeconds;
    }
    return List<DailySessionTotal>.unmodifiable([
      for (var index = 0; index < 7; index++)
        DailySessionTotal(
          date: totals[index].date,
          completedSessions: counts[index],
          durationSeconds: durations[index],
        ),
    ]);
  }

  static String _encode(WorkoutSession session) => jsonEncode({
        'id': session.id,
        'workoutId': session.workoutId,
        'workoutName': session.workoutName,
        'startedAt': session.startedAt.toUtc().toIso8601String(),
        'durationSeconds': session.durationSeconds,
        'completedRounds': session.completedRounds,
        'completedSets': session.completedSets,
        'wasCompleted': session.wasCompleted,
      });

  static WorkoutSession _decode(String value) {
    final json = jsonDecode(value) as Map<String, dynamic>;
    return WorkoutSession(
      id: json['id'] as String,
      workoutId: json['workoutId'] as String,
      workoutName: json['workoutName'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      durationSeconds: json['durationSeconds'] as int,
      completedRounds: json['completedRounds'] as int,
      completedSets: json['completedSets'] as int,
      wasCompleted: json['wasCompleted'] as bool,
    );
  }
}
