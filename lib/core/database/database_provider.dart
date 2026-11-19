import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'key_store.dart';

class DatabaseProvider {
  DatabaseProvider({
    required Directory directory,
    required SecureKeyStore secureKeyStore,
    HiveInterface? hive,
  })  : _applicationDirectory = directory,
        _keyStore = secureKeyStore,
        _hive = hive ?? Hive;

  static const encryptionKeyName = 'tempo_database_key_v1';
  static const workoutBoxName = 'tempo_workouts';
  static const sessionBoxName = 'tempo_sessions';
  static const activeSessionBoxName = 'tempo_active_session';
  static const _boxNames = [
    workoutBoxName,
    sessionBoxName,
    activeSessionBoxName,
  ];

  static Future<DatabaseProvider> create({
    SecureKeyStore? keyStore,
    HiveInterface? hive,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    return DatabaseProvider(
      directory: directory,
      secureKeyStore: keyStore ?? FlutterSecureKeyStore(),
      hive: hive,
    );
  }

  final Directory _applicationDirectory;
  final SecureKeyStore _keyStore;
  final HiveInterface _hive;

  Box<String>? _workouts;
  Box<String>? _sessions;
  Box<String>? _activeSession;
  Future<void>? _initializing;

  Box<String> get workouts => _requireBox(_workouts, workoutBoxName);
  Box<String> get sessions => _requireBox(_sessions, sessionBoxName);
  Box<String> get activeSession =>
      _requireBox(_activeSession, activeSessionBoxName);

  Future<void> initialize() async {
    final pending = _initializing;
    if (pending != null) return pending;
    final next = _open();
    _initializing = next;
    try {
      await next;
    } on Object {
      _initializing = null;
      rethrow;
    }
  }

  Future<void> _open() async {
    await _applicationDirectory.create(recursive: true);
    final storedKey = await _keyStore.read(encryptionKeyName);
    final filesExist = _boxNames.any(
      (name) => File(
        '${_applicationDirectory.path}${Platform.pathSeparator}$name.hive',
      ).existsSync(),
    );

    final encodedKey = storedKey ?? await _createAndPersistKey(filesExist);
    final key = _decodeKey(encodedKey);
    _hive.init(_applicationDirectory.path);
    final cipher = HiveAesCipher(key);
    try {
      _workouts = await _hive.openBox<String>(
        workoutBoxName,
        encryptionCipher: cipher,
      );
      _sessions = await _hive.openBox<String>(
        sessionBoxName,
        encryptionCipher: cipher,
      );
      _activeSession = await _hive.openBox<String>(
        activeSessionBoxName,
        encryptionCipher: cipher,
      );
    } on Object catch (error) {
      await _hive.close();
      _workouts = null;
      _sessions = null;
      _activeSession = null;
      throw StateError('Could not open encrypted local data: $error');
    }
  }

  Future<String> _createAndPersistKey(bool filesExist) async {
    if (filesExist) {
      throw StateError(
        'Encrypted Tempo data exists, but its secure key is unavailable. '
        'Existing files were left untouched.',
      );
    }
    final random = Random.secure();
    final encoded = base64Encode(
      List<int>.generate(32, (_) => random.nextInt(256), growable: false),
    );
    await _keyStore.write(encryptionKeyName, encoded);
    final verification = await _keyStore.read(encryptionKeyName);
    if (verification != encoded) {
      throw StateError('The database key could not be persisted securely.');
    }
    return encoded;
  }

  List<int> _decodeKey(String encoded) {
    try {
      final key = base64Decode(encoded);
      if (key.length != 32) throw const FormatException('Invalid key length.');
      return key;
    } on FormatException catch (error) {
      throw StateError('The stored database key is invalid: $error');
    }
  }

  Box<String> _requireBox(Box<String>? box, String name) {
    if (box == null || !box.isOpen) {
      throw StateError('The $name box is not initialized.');
    }
    return box;
  }

  Future<void> close() async {
    if (_workouts == null && _sessions == null && _activeSession == null) {
      _initializing = null;
      return;
    }
    await _hive.close();
    _workouts = null;
    _sessions = null;
    _activeSession = null;
    _initializing = null;
  }
}
