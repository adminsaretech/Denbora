import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:tempo_workout_timer/features/history/data/session_repository.dart';
import 'package:tempo_workout_timer/features/history/domain/workout_session.dart';

void main() {
  late Directory directory;
  late Box<String> box;
  late SessionRepository repository;

  setUp(() async {
    await Hive.close();
    directory = await Directory.systemTemp.createTemp('tempo-sessions-');
    Hive.init(directory.path);
    box = await Hive.openBox<String>(
      'sessions',
      encryptionCipher: HiveAesCipher(List<int>.generate(32, (index) => index)),
    );
    repository = SessionRepository(box);
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('records each completion once and preserves the workout name snapshot',
      () async {
    final session = _session(id: 'session-1', name: 'Rutina original');
    await repository.recordCompleted(session);
    await repository.recordCompleted(session);

    final sessions = await repository.list();
    expect(sessions, hasLength(1));
    expect(sessions.single.workoutName, 'Rutina original');
    expect(sessions.single.completedRounds, 5);
    expect(sessions.single.wasCompleted, isTrue);
  });

  test('weekly summary includes seven local calendar days and completed time',
      () async {
    final today = DateTime(2026, 11, 19, 14);
    await repository.recordCompleted(
      _session(id: 'today', date: DateTime(2026, 11, 19, 9), duration: 900),
    );
    await repository.recordCompleted(
      _session(id: 'yesterday', date: DateTime(2026, 11, 18, 9), duration: 600),
    );

    final summary = await repository.weeklySummary(anchorDate: today);

    expect(summary, hasLength(7));
    expect(summary.last.completedSessions, 1);
    expect(summary.last.durationSeconds, 900);
    expect(summary[5].completedSessions, 1);
    expect(summary[5].durationSeconds, 600);
  });

  test('deletes a session and clears history', () async {
    await repository.recordCompleted(_session(id: 'one'));
    await repository.delete('one');
    expect(await repository.list(), isEmpty);
    await repository.recordCompleted(_session(id: 'two'));
    await repository.clear();
    expect(await repository.list(), isEmpty);
  });
}

WorkoutSession _session({
  required String id,
  String name = 'Rutina',
  DateTime? date,
  int duration = 120,
}) =>
    WorkoutSession(
      id: id,
      workoutId: 'workout-1',
      workoutName: name,
      startedAt: date ?? DateTime(2026, 11, 19, 9),
      durationSeconds: duration,
      completedRounds: 5,
      completedSets: 1,
      wasCompleted: true,
    );
