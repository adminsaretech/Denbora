import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/clock/monotonic_clock.dart';
import '../../workouts/domain/workout_plan.dart';
import '../data/active_session_store.dart';
import '../domain/timer_engine.dart';
import '../domain/timer_phase.dart';
import '../domain/timer_snapshot.dart';

typedef TimerEventHandler = void Function(TimerEvent event);
typedef SessionCompletedHandler = Future<void> Function(
  WorkoutPlan plan,
  TimerSnapshot snapshot,
);

class TimerController extends ChangeNotifier {
  TimerController({
    required this.clock,
    required this.activeSessionStore,
    this.onEvent,
    this.onCompleted,
    this.startTicker = true,
  });

  final MonotonicClock clock;
  final ActiveSessionStore activeSessionStore;
  final TimerEventHandler? onEvent;
  final SessionCompletedHandler? onCompleted;
  final bool startTicker;

  TimerEngine? _engine;
  WorkoutPlan? _plan;
  Timer? _ticker;
  bool _refreshing = false;
  bool _completionHandled = false;
  TimerSnapshot _state = TimerSnapshot(
    status: TimerStatus.idle,
    phase: const TimerPhase(
      kind: TimerPhaseKind.finished,
      label: 'Listo',
      durationSeconds: 0,
      roundNumber: 0,
      setNumber: 0,
    ),
    phaseIndex: 0,
    phaseCount: 0,
    phaseRemaining: Duration.zero,
    elapsed: Duration.zero,
    completedWorkBlocks: 0,
  );

  TimerSnapshot get state => _state;
  WorkoutPlan? get activePlan => _plan;

  Future<bool> restoreActiveSession({
    required Future<WorkoutPlan?> Function(String planId) findPlanById,
  }) async {
    final checkpoint = await activeSessionStore.load();
    if (checkpoint == null) return false;

    await _synchronizeClock();
    final plan = await findPlanById(checkpoint.planId);
    if (plan == null ||
        (checkpoint.status != TimerStatus.running &&
            checkpoint.status != TimerStatus.paused)) {
      await activeSessionStore.clear();
      return false;
    }

    final now = clock.nowMicroseconds();
    final previousBoot = checkpoint.status == TimerStatus.running &&
        now < checkpoint.monotonicCheckpointMicroseconds;
    final status = previousBoot ? TimerStatus.interrupted : checkpoint.status;
    final sleepElapsed = checkpoint.status == TimerStatus.running && !previousBoot
        ? now - checkpoint.monotonicCheckpointMicroseconds
        : 0;
    _plan = plan;
    _engine = TimerEngine(plan: plan, clock: clock);
    _completionHandled = false;

    var restored = _engine!.restore(
      elapsed: Duration(
        microseconds: checkpoint.elapsedMicroseconds + sleepElapsed,
      ),
      status: status,
    );
    if (status == TimerStatus.running) restored = _engine!.advance();
    _setState(restored.withEvents(const []));

    if (_state.status == TimerStatus.interrupted) {
      await activeSessionStore.clear();
    } else if (_state.status == TimerStatus.completed) {
      await _handleCompletionIfNeeded();
    } else {
      await _saveCheckpoint();
      _ensureTicker();
    }
    return true;
  }

  Future<void> start(WorkoutPlan plan) async {
    if (clock case final RefreshableMonotonicClock refreshable) {
      await refreshable.synchronize();
    }
    _plan = plan;
    _engine = TimerEngine(plan: plan, clock: clock);
    _completionHandled = false;
    _publish(_engine!.start());
    await _saveCheckpoint();
    _ensureTicker();
  }

  Future<void> pause() async {
    final engine = _engine;
    if (engine == null) return;
    await _synchronizeClock();
    _publish(engine.pause());
    await _handleCompletionIfNeeded();
    if (_state.status != TimerStatus.completed) await _saveCheckpoint();
    _stopTicker();
  }

  Future<void> resume() async {
    final engine = _engine;
    if (engine == null) return;
    await _synchronizeClock();
    _publish(engine.resume());
    await _handleCompletionIfNeeded();
    await _saveCheckpoint();
    _ensureTicker();
  }

  Future<void> restart() async {
    final engine = _engine;
    if (engine == null) return;
    await _synchronizeClock();
    _publish(engine.restart());
    await activeSessionStore.clear();
    _stopTicker();
    _completionHandled = false;
  }

  Future<void> skipPhase() async {
    final engine = _engine;
    if (engine == null) return;
    await _synchronizeClock();
    _publish(engine.skipPhase());
    await _persistOrClear();
  }

  Future<void> stop() async {
    final engine = _engine;
    if (engine == null) return;
    await _synchronizeClock();
    _publish(engine.stop());
    await _persistOrClear();
    _stopTicker();
  }

  /// Advances authoritative elapsed time after the native clock is sampled.
  Future<TimerSnapshot> refresh() async {
    if (_refreshing || _engine == null) return _state;
    _refreshing = true;
    try {
      await _synchronizeClock();
      final previousPhaseIndex = _state.phaseIndex;
      _publish(_engine!.advance());
      if (_state.phaseIndex != previousPhaseIndex) {
        await _persistOrClear();
      }
      await _handleCompletionIfNeeded();
      return _state;
    } finally {
      _refreshing = false;
    }
  }

  /// Reconciles elapsed time after suspension, dropping events that would now
  /// be stale. Native notifications are responsible for any background cues.
  Future<TimerSnapshot> onLifecycleResume() async {
    if (_engine == null) return _state;
    await _synchronizeClock();
    final previousPhaseIndex = _state.phaseIndex;
    _setState(_engine!.advance().withEvents(const []));
    if (_state.phaseIndex != previousPhaseIndex) await _persistOrClear();
    await _handleCompletionIfNeeded();
    return _state;
  }

  Future<void> _synchronizeClock() async {
    if (clock case final RefreshableMonotonicClock refreshable) {
      await refreshable.synchronize();
    }
  }

  void _publish(TimerSnapshot next) {
    _setState(next);
    for (final event in next.events) {
      onEvent?.call(event);
    }
  }

  void _setState(TimerSnapshot next) {
    _state = next;
    notifyListeners();
  }

  Future<void> _handleCompletionIfNeeded() async {
    if (_state.status != TimerStatus.completed || _completionHandled) return;
    _completionHandled = true;
    final plan = _plan;
    if (plan != null) await onCompleted?.call(plan, _state);
    await activeSessionStore.clear();
    _stopTicker();
  }

  Future<void> _persistOrClear() async {
    if (_state.status == TimerStatus.completed) {
      await _handleCompletionIfNeeded();
    } else if (_state.status == TimerStatus.stopped) {
      await activeSessionStore.clear();
    } else {
      await _saveCheckpoint();
    }
  }

  Future<void> _saveCheckpoint() async {
    final plan = _plan;
    if (plan == null || _state.status == TimerStatus.idle) return;
    await activeSessionStore.save(
      ActiveSessionCheckpoint(
        planId: plan.id,
        elapsedMicroseconds: _state.elapsed.inMicroseconds,
        status: _state.status,
        monotonicCheckpointMicroseconds: clock.nowMicroseconds(),
      ),
    );
  }

  void _ensureTicker() {
    if (!startTicker || _ticker != null || _state.status != TimerStatus.running) {
      return;
    }
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      unawaited(refresh());
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
