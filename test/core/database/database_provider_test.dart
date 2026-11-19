import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:tempo_workout_timer/core/database/database_provider.dart';
import 'package:tempo_workout_timer/core/database/key_store.dart';

void main() {
  late Directory directory;
  late MemoryKeyStore keys;

  setUp(() async {
    await Hive.close();
    directory = await Directory.systemTemp.createTemp('tempo-database-');
    keys = MemoryKeyStore();
  });

  tearDown(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('creates a secure key and opens all encrypted boxes', () async {
    final database = DatabaseProvider(
      directory: directory,
      secureKeyStore: keys,
    );

    await database.initialize();

    expect(keys.values, isNotEmpty);
    expect(database.workouts.isOpen, isTrue);
    expect(database.sessions.isOpen, isTrue);
    expect(database.activeSession.isOpen, isTrue);
    await database.close();
  });

  test('does not replace encrypted files when a stored key is missing',
      () async {
    final first = DatabaseProvider(
      directory: directory,
      secureKeyStore: keys,
    );
    await first.initialize();
    await first.workouts.put('sample', '{"name":"original"}');
    await first.close();
    final originalKey = keys.values[DatabaseProvider.encryptionKeyName]!;
    keys.values.clear();

    final reopenedWithoutKey = DatabaseProvider(
      directory: directory,
      secureKeyStore: keys,
    );
    await expectLater(reopenedWithoutKey.initialize(), throwsStateError);

    keys.values[DatabaseProvider.encryptionKeyName] = originalKey;
    final recovered = DatabaseProvider(
      directory: directory,
      secureKeyStore: keys,
    );
    await recovered.initialize();
    expect(recovered.workouts.get('sample'), '{"name":"original"}');
    await recovered.close();
  });

  test('does not overwrite data when an incorrect key cannot open a box',
      () async {
    final first = DatabaseProvider(
      directory: directory,
      secureKeyStore: keys,
    );
    await first.initialize();
    await first.workouts.put('sample', '{"name":"original"}');
    await first.close();
    keys.values[DatabaseProvider.encryptionKeyName] = _wrongKey;

    final wrongKey = DatabaseProvider(
      directory: directory,
      secureKeyStore: keys,
    );
    await expectLater(wrongKey.initialize(), throwsStateError);
  });
}

const _wrongKey = 'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8=';

class MemoryKeyStore implements SecureKeyStore {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}
