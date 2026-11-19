import 'dart:convert';

import 'package:hive_ce/hive.dart';

import '../domain/timer_snapshot.dart';

class ActiveSessionCheckpoint {
  const ActiveSessionCheckpoint({
    required this.planId,
    required this.elapsedMicroseconds,
    required this.status,
    required this.monotonicCheckpointMicroseconds,
  });

  final String planId;
  final int elapsedMicroseconds;
  final TimerStatus status;
  final int monotonicCheckpointMicroseconds;
}

abstract interface class ActiveSessionStore {
  Future<ActiveSessionCheckpoint?> load();
  Future<void> save(ActiveSessionCheckpoint checkpoint);
  Future<void> clear();
}

/// Small test adapter. Production storage is supplied by the encrypted local
/// database provider.
class MemoryActiveSessionStore implements ActiveSessionStore {
  ActiveSessionCheckpoint? checkpoint;

  @override
  Future<ActiveSessionCheckpoint?> load() async => checkpoint;

  @override
  Future<void> save(ActiveSessionCheckpoint value) async {
    checkpoint = value;
  }

  @override
  Future<void> clear() async {
    checkpoint = null;
  }
}

class HiveActiveSessionStore implements ActiveSessionStore {
  HiveActiveSessionStore(this._box);

  static const _key = 'active';
  final Box<String> _box;

  @override
  Future<ActiveSessionCheckpoint?> load() async {
    final value = _box.get(_key);
    if (value == null) return null;
    final json = jsonDecode(value) as Map<String, dynamic>;
    return ActiveSessionCheckpoint(
      planId: json['planId'] as String,
      elapsedMicroseconds: json['elapsedMicroseconds'] as int,
      status: TimerStatus.values.byName(json['status'] as String),
      monotonicCheckpointMicroseconds:
          json['monotonicCheckpointMicroseconds'] as int,
    );
  }

  @override
  Future<void> save(ActiveSessionCheckpoint checkpoint) => _box.put(
        _key,
        jsonEncode({
          'planId': checkpoint.planId,
          'elapsedMicroseconds': checkpoint.elapsedMicroseconds,
          'status': checkpoint.status.name,
          'monotonicCheckpointMicroseconds':
              checkpoint.monotonicCheckpointMicroseconds,
        }),
      );

  @override
  Future<void> clear() => _box.delete(_key);
}
