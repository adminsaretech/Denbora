import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:tempo_workout_timer/features/timer/data/active_session_store.dart';
import 'package:tempo_workout_timer/features/timer/domain/timer_snapshot.dart';

void main() {
  late Directory directory;
  late Box<String> box;
  late HiveActiveSessionStore store;

  setUp(() async {
    await Hive.close();
    directory = await Directory.systemTemp.createTemp('tempo-active-');
    Hive.init(directory.path);
    box = await Hive.openBox<String>(
      'active',
      encryptionCipher: HiveAesCipher(List<int>.generate(32, (index) => index)),
    );
    store = HiveActiveSessionStore(box);
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('round-trips a running checkpoint and removes it when cleared',
      () async {
    const checkpoint = ActiveSessionCheckpoint(
      planId: 'workout-id',
      elapsedMicroseconds: 9500000,
      status: TimerStatus.running,
      monotonicCheckpointMicroseconds: 123456789,
    );
    await store.save(checkpoint);

    final loaded = await store.load();
    expect(loaded?.planId, checkpoint.planId);
    expect(loaded?.elapsedMicroseconds, checkpoint.elapsedMicroseconds);
    expect(loaded?.status, checkpoint.status);
    expect(
      loaded?.monotonicCheckpointMicroseconds,
      checkpoint.monotonicCheckpointMicroseconds,
    );
    await store.clear();
    expect(await store.load(), isNull);
  });
}
