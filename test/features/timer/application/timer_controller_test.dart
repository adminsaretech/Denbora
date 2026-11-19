import 'package:flutter_test/flutter_test.dart';
import 'package:tempo_workout_timer/core/clock/monotonic_clock.dart';
import 'package:tempo_workout_timer/features/timer/application/timer_controller.dart';
import 'package:tempo_workout_timer/features/timer/data/active_session_store.dart';
import 'package:tempo_workout_timer/features/timer/domain/timer_phase.dart';
import 'package:tempo_workout_timer/features/timer/domain/timer_snapshot.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_plan.dart';

void main() {
  test('catches up on lifecycle resume without replaying stale cues', () async {
    final clock = FakeMonotonicClock();
    final emitted = <TimerEvent>[];
    final controller = TimerController(
      clock: clock,
      activeSessionStore: MemoryActiveSessionStore(),
      onEvent: emitted.add,
      startTicker: false,
    );

    await controller.start(_plan());
    emitted.clear();
    clock.elapse(const Duration(seconds: 4, milliseconds: 500));

    await controller.onLifecycleResume();

    expect(controller.state.phase.kind, TimerPhaseKind.work);
    expect(controller.state.phase.roundNumber, 2);
    expect(controller.state.phaseRemaining, const Duration(milliseconds: 500));
    expect(controller.state.events, isEmpty);
    expect(emitted, isEmpty);
    controller.dispose();
  });

  test('emits completion once and clears the persisted active checkpoint',
      () async {
    final clock = FakeMonotonicClock();
    final store = MemoryActiveSessionStore();
    var completions = 0;
    final controller = TimerController(
      clock: clock,
      activeSessionStore: store,
      onCompleted: (_, _) async => completions++,
      startTicker: false,
    );

    await controller.start(_plan(workSeconds: 2, rounds: 1));
    expect(store.checkpoint?.planId, 'test-plan');
    clock.elapse(const Duration(seconds: 3));
    await controller.refresh();
    await controller.refresh();

    expect(controller.state.status, TimerStatus.completed);
    expect(completions, 1);
    expect(store.checkpoint, isNull);
    controller.dispose();
  });

  test('pause checkpoints the elapsed duration and resume keeps its phase',
      () async {
    final clock = FakeMonotonicClock();
    final store = MemoryActiveSessionStore();
    final controller = TimerController(
      clock: clock,
      activeSessionStore: store,
      startTicker: false,
    );

    await controller.start(_plan(workSeconds: 10));
    clock.elapse(const Duration(seconds: 2));
    await controller.pause();

    expect(controller.state.status, TimerStatus.paused);
    expect(controller.state.phase.kind, TimerPhaseKind.work);
    expect(store.checkpoint?.elapsedMicroseconds, 2000000);

    clock.elapse(const Duration(minutes: 1));
    await controller.resume();
    await controller.refresh();
    expect(controller.state.elapsed, const Duration(seconds: 2));
    controller.dispose();
  });

  test('restores a running session using sleep-aware monotonic elapsed time',
      () async {
    final clock = FakeMonotonicClock()..elapse(const Duration(seconds: 6));
    final store = MemoryActiveSessionStore()
      ..checkpoint = const ActiveSessionCheckpoint(
        planId: 'test-plan',
        elapsedMicroseconds: 1000000,
        status: TimerStatus.running,
        monotonicCheckpointMicroseconds: 2000000,
      );
    final emitted = <TimerEvent>[];
    final controller = TimerController(
      clock: clock,
      activeSessionStore: store,
      onEvent: emitted.add,
      startTicker: false,
    );

    final restored = await controller.restoreActiveSession(
      findPlanById: (id) async => id == 'test-plan' ? _plan() : null,
    );

    expect(restored, isTrue);
    expect(controller.state.elapsed, const Duration(seconds: 5));
    expect(controller.state.phase.kind, TimerPhaseKind.rest);
    expect(controller.state.phaseRemaining, const Duration(seconds: 1));
    expect(controller.state.events, isEmpty);
    expect(emitted, isEmpty);
    controller.dispose();
  });

  test('marks a checkpoint from a previous device boot as interrupted',
      () async {
    final clock = FakeMonotonicClock();
    final store = MemoryActiveSessionStore()
      ..checkpoint = const ActiveSessionCheckpoint(
        planId: 'test-plan',
        elapsedMicroseconds: 1000000,
        status: TimerStatus.running,
        monotonicCheckpointMicroseconds: 5000000,
      );
    final controller = TimerController(
      clock: clock,
      activeSessionStore: store,
      startTicker: false,
    );

    final restored = await controller.restoreActiveSession(
      findPlanById: (id) async => _plan(),
    );

    expect(restored, isTrue);
    expect(controller.state.status, TimerStatus.interrupted);
    expect(store.checkpoint, isNull);
    controller.dispose();
  });
}

WorkoutPlan _plan({int workSeconds = 2, int rounds = 3}) => WorkoutPlan(
      id: 'test-plan',
      name: 'Test plan',
      preparationSeconds: 0,
      rounds: rounds,
      blocks: [
        WorkoutBlock(
          id: 'block',
          name: 'Trabajo',
          workSeconds: workSeconds,
          restAfterSeconds: 1,
        ),
      ],
    );

class FakeMonotonicClock implements MonotonicClock {
  int _now = 0;

  @override
  int nowMicroseconds() => _now;

  void elapse(Duration duration) => _now += duration.inMicroseconds;
}
