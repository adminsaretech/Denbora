import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:tempo_workout_timer/features/workouts/data/workout_repository.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_plan.dart';

void main() {
  late Directory directory;
  late Box<String> box;
  late WorkoutRepository repository;
  var nextId = 0;
  var now = DateTime.utc(2026, 11, 19);

  setUp(() async {
    await Hive.close();
    directory = await Directory.systemTemp.createTemp('tempo-workouts-');
    Hive.init(directory.path);
    box = await Hive.openBox<String>(
      'workouts',
      encryptionCipher: HiveAesCipher(List<int>.generate(32, (index) => index)),
    );
    nextId = 0;
    now = DateTime.utc(2026, 11, 19);
    repository = WorkoutRepository(
      box,
      createId: () => 'custom-${nextId++}',
      now: () => now,
    );
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('saves and reloads a custom plan from the encrypted box', () async {
    final created = _plan();
    await repository.save(created);

    final loaded = await repository.getById(created.id);

    expect(loaded?.name, created.name);
    expect(loaded?.blocks.single.workSeconds, 30);
    expect(loaded?.isBuiltIn, isFalse);
  });

  test('lists original built-ins and duplicates them as editable plans',
      () async {
    final before = await repository.list();
    final duplicate = await repository.duplicate('tabata-20-10');

    expect(before.any((plan) => plan.isBuiltIn), isTrue);
    expect(duplicate.id, 'custom-0');
    expect(duplicate.isBuiltIn, isFalse);
    expect(duplicate.blocks.single.workSeconds, 20);
    expect((await repository.getById('tabata-20-10'))?.isBuiltIn, isTrue);
  });

  test('searches names and sorts by name or last update', () async {
    await repository.save(_plan(id: 'beta', name: 'Zancadas'));
    now = now.add(const Duration(days: 1));
    await repository.save(_plan(id: 'alpha', name: 'Abdominales'));

    expect((await repository.search('ABDOM')).map((plan) => plan.id), ['alpha']);
    expect((await repository.sortByName()).first.name, 'Abdominales');
    expect((await repository.sortByUpdatedAt()).first.name, 'Abdominales');
  });

  test('does not allow built-in mutation or deletion', () async {
    await expectLater(
      repository.save(_plan(id: 'tabata-20-10')),
      throwsStateError,
    );
    await expectLater(
      repository.delete('tabata-20-10'),
      throwsStateError,
    );
  });

  test('deleting a custom plan does not affect a separate session snapshot',
      () async {
    final plan = _plan(id: 'snapshot-plan', name: 'Saltos');
    await repository.save(plan);
    final sessionSnapshotName = plan.name;

    await repository.delete(plan.id);

    expect(await repository.getById(plan.id), isNull);
    expect(sessionSnapshotName, 'Saltos');
  });
}

WorkoutPlan _plan({String id = 'custom', String name = 'Mi rutina'}) =>
    WorkoutPlan(
      id: id,
      name: name,
      preparationSeconds: 0,
      blocks: const [
        WorkoutBlock(id: 'block', name: 'Bloque', workSeconds: 30),
      ],
    );
