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
