import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/core/database/database_providers.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';
import 'package:tempo_workout_timer/features/workouts/data/workout_repository.dart';
import 'package:tempo_workout_timer/features/workouts/data/workout_templates.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_plan.dart';
import 'package:tempo_workout_timer/features/workouts/presentation/workout_library_screen.dart';

void main() {
  late Directory directory;
  late Box<String> box;
  late WorkoutRepository repository;
  var nextId = 0;

  setUp(() async {
    await Hive.close();
    directory = await Directory.systemTemp.createTemp('tempo-library-');
    Hive.init(directory.path);
    box = await Hive.openBox<String>(
      'workouts',
      encryptionCipher: HiveAesCipher(List<int>.generate(32, (index) => index)),
    );
    nextId = 0;
    repository = MemoryWorkoutRepository(
      box,
      () => 'user-${nextId++}',
      () => DateTime.utc(2026, 11, 19, 12, nextId),
    );
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  Future<void> pumpLibrary(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          workoutRepositoryProvider.overrideWithValue(repository),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(MemorySettingsStorage()),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: const TempoApp(homeOverride: WorkoutLibraryScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows original templates and can search by name', (
    tester,
  ) async {
    await pumpLibrary(tester);

    expect(find.text('HIIT 20/10'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('workout-search')),
      'cardio',
    );
    await tester.pumpAndSettle();
    expect(find.text('Cardio libre'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('workout-search')),
      'tabata',
    );
    await tester.pumpAndSettle();
    expect(find.text('Tabata 20/10'), findsOneWidget);
    expect(find.text('HIIT 20/10'), findsNothing);
  });

  testWidgets(
    'opens the workout library tab without a localization exception',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            workoutRepositoryProvider.overrideWithValue(repository),
            settingsRepositoryProvider.overrideWithValue(
              SettingsRepository(MemorySettingsStorage()),
            ),
            initialAppSettingsProvider.overrideWithValue(
              const AppSettings(onboardingCompleted: true),
            ),
          ],
          child: const TempoApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('nav-workouts')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('workout-search')), findsOneWidget);
      expect(find.text('HIIT 20/10'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('creates a custom interval workout', (tester) async {
    await pumpLibrary(tester);
    await tester.tap(find.byKey(const ValueKey('create-workout')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('workout-name')),
      'Mi rutina',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('save-workout')));
    await tester.tap(find.byKey(const ValueKey('save-workout')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('workout-search')),
      'Mi rutina',
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('workout-user-0')),
        matching: find.text('Mi rutina'),
      ),
      findsOneWidget,
    );
    expect(
      (await repository.list()).any((plan) => plan.name == 'Mi rutina'),
      isTrue,
    );
  });

  testWidgets('duplicates a template, edits the copy, and deletes it', (
    tester,
  ) async {
    await pumpLibrary(tester);
    await tester.tap(find.byKey(const ValueKey('workout-menu-tabata-20-10')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('workout-search')),
      'Tabata 20/10 (copia)',
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('workout-user-0')),
        matching: find.text('Tabata 20/10 (copia)'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('workout-menu-user-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('workout-name')),
      'Tabata personalizado',
    );
    await tester.ensureVisible(find.byKey(const ValueKey('save-workout')));
    await tester.tap(find.byKey(const ValueKey('save-workout')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('workout-search')),
      'Tabata personalizado',
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('workout-user-0')),
        matching: find.text('Tabata personalizado'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('workout-menu-user-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-delete-workout')));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('workout-user-0')),
        matching: find.text('Tabata personalizado'),
      ),
      findsNothing,
    );
    expect(await repository.getById('user-0'), isNull);
    expect((await repository.getById('tabata-20-10'))?.isBuiltIn, isTrue);
  });

  testWidgets('requires a workout name before saving', (tester) async {
    await pumpLibrary(tester);
    await tester.tap(find.byKey(const ValueKey('create-workout')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('save-workout')));
    await tester.tap(find.byKey(const ValueKey('save-workout')));
    await tester.pumpAndSettle();
    expect(
      find.text('Escribe un nombre para el entrenamiento.'),
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

class MemoryWorkoutRepository extends WorkoutRepository {
  MemoryWorkoutRepository(super.box, this._createMemoryId, this._now);

  final String Function() _createMemoryId;
  final DateTime Function() _now;
  final Map<String, WorkoutPlan> _custom = {};

  @override
  String createId() => _createMemoryId();

  @override
  Future<List<WorkoutPlan>> list() async => [
    ...WorkoutTemplates.all,
    ..._custom.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)),
  ];

  @override
  Future<WorkoutPlan?> getById(String id) async {
    for (final template in WorkoutTemplates.all) {
      if (template.id == id) return template;
    }
    return _custom[id];
  }

  @override
  Future<void> save(WorkoutPlan plan) async {
    _custom[plan.id] = plan.copyWith(isBuiltIn: false, updatedAt: _now());
  }

  @override
  Future<WorkoutPlan> duplicate(
    String id, {
    String copySuffix = '(copy)',
  }) async {
    final source = await getById(id);
    if (source == null) throw ArgumentError.value(id, 'id');
    final copy = source.copyWith(
      id: createId(),
      name: '${source.name} $copySuffix',
      createdAt: _now(),
      updatedAt: _now(),
      clearLastUsedAt: true,
      isBuiltIn: false,
    );
    await save(copy);
    return copy;
  }

  @override
  Future<void> delete(String id) async {
    _custom.remove(id);
  }

  @override
  Future<List<WorkoutPlan>> sortByName() async {
    final plans = (await list()).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return plans;
  }

  @override
  Future<List<WorkoutPlan>> sortByUpdatedAt() async => list();
}
