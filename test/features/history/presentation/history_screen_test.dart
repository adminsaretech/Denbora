import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/core/database/database_providers.dart';
import 'package:tempo_workout_timer/features/history/data/session_repository.dart';
import 'package:tempo_workout_timer/features/history/domain/workout_session.dart';
import 'package:tempo_workout_timer/features/history/presentation/history_screen.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';

void main() {
  late Directory directory;
  late Box<String> box;
  late SessionRepository repository;

  setUp(() async {
    await Hive.close();
    directory = await Directory.systemTemp.createTemp('tempo-history-ui-');
    Hive.init(directory.path);
    box = await Hive.openBox<String>(
      'sessions',
      encryptionCipher: HiveAesCipher(List<int>.generate(32, (index) => index)),
    );
    repository = MemoryHistoryRepository(box);
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  Future<void> pumpHistory(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(repository),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(MemorySettingsStorage()),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: const TempoApp(homeOverride: HistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows sessions and an accessible seven-day activity chart', (
    tester,
  ) async {
    await repository.recordCompleted(
      WorkoutSession(
        id: 'session-one',
        workoutId: 'hiit-20-10',
        workoutName: 'HIIT 20/10',
        startedAt: DateTime.now(),
        durationSeconds: 12 * 60 + 5,
        completedRounds: 6,
        completedSets: 2,
        wasCompleted: true,
      ),
    );
    await pumpHistory(tester);

    expect(find.text('HIIT 20/10'), findsOneWidget);
    expect(
      find.textContaining('12 min · 6 rondas completadas'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp('últimos 7 días')), findsOneWidget);
  });

  testWidgets('explains how to populate an empty history', (tester) async {
    await pumpHistory(tester);
    expect(
      find.text('Completa tu primer entrenamiento para ver aquí el historial.'),
      findsOneWidget,
    );
  });
}

class MemorySettingsStorage implements SettingsStorage {
  @override
  Future<bool?> getBool(String key) async => null;

  @override
  Future<String?> getString(String key) async => null;

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> setString(String key, String value) async {}
}

class MemoryHistoryRepository extends SessionRepository {
  MemoryHistoryRepository(super.box);

  final List<WorkoutSession> sessions = [];

  @override
  Future<void> recordCompleted(WorkoutSession session) async {
    sessions.add(session);
  }

  @override
  Future<List<WorkoutSession>> list() async =>
      List<WorkoutSession>.unmodifiable(sessions);

  @override
  Future<List<DailySessionTotal>> weeklySummary({DateTime? anchorDate}) async {
    final anchor = anchorDate ?? DateTime.now();
    final today = DateTime(anchor.year, anchor.month, anchor.day);
    final first = today.subtract(const Duration(days: 6));
    final totals = List.generate(
      7,
      (index) => DailySessionTotal(
        date: first.add(Duration(days: index)),
        completedSessions: 0,
        durationSeconds: 0,
      ),
    );
    final count = List<int>.filled(7, 0);
    final duration = List<int>.filled(7, 0);
    for (final session in sessions) {
      final start = session.startedAt.toLocal();
      final date = DateTime(start.year, start.month, start.day);
      final index = date.difference(first).inDays;
      if (index < 0 || index >= 7) continue;
      count[index]++;
      duration[index] += session.durationSeconds;
    }
    return List.generate(
      7,
      (index) => DailySessionTotal(
        date: totals[index].date,
        completedSessions: count[index],
        durationSeconds: duration[index],
      ),
      growable: false,
    );
  }
}
