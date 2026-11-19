import 'package:flutter_test/flutter_test.dart';
import 'package:tempo_workout_timer/core/clock/monotonic_clock.dart';
import 'package:tempo_workout_timer/features/timer/domain/timer_engine.dart';
import 'package:tempo_workout_timer/features/timer/domain/timer_phase.dart';
import 'package:tempo_workout_timer/features/timer/domain/timer_snapshot.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_plan.dart';

void main() {
  group('TimerEngine interval mode', () {
    test('start event identifies the first active phase', () {
      final engine = TimerEngine(
        plan: _plan(preparationSeconds: 5, workSeconds: 10),
        clock: FakeMonotonicClock(),
      );

      final started = engine.start();

      expect(started.events.first.kind, TimerEventKind.started);
      expect(started.events.first.phase.kind, TimerPhaseKind.preparation);
    });

    test('moves through preparation, work, rest, rounds, cooldown, and finish', () {
      final clock = FakeMonotonicClock();
      final engine = TimerEngine(
        plan: _plan(
          preparationSeconds: 2,
          workSeconds: 3,
          restSeconds: 2,
          rounds: 2,
          roundRestSeconds: 1,
          cooldownSeconds: 1,
        ),
        clock: clock,
      );

      engine.start();
      expect(engine.snapshot.phase.kind, TimerPhaseKind.preparation);

      clock.elapse(const Duration(seconds: 2));
      expect(engine.advance().phase.kind, TimerPhaseKind.work);
      clock.elapse(const Duration(seconds: 3));
      expect(engine.advance().phase.kind, TimerPhaseKind.rest);
      clock.elapse(const Duration(seconds: 2));
      expect(engine.advance().phase.kind, TimerPhaseKind.roundRest);
      clock.elapse(const Duration(seconds: 1));
      final secondRound = engine.advance();
      expect(secondRound.phase.kind, TimerPhaseKind.work);
      expect(secondRound.phase.roundNumber, 2);
      clock.elapse(const Duration(seconds: 3));
      expect(engine.advance().phase.kind, TimerPhaseKind.rest);
      clock.elapse(const Duration(seconds: 2));
      expect(engine.advance().phase.kind, TimerPhaseKind.cooldown);
      clock.elapse(const Duration(seconds: 1));
      final finished = engine.advance();

      expect(finished.status, TimerStatus.completed);
      expect(finished.phase.kind, TimerPhaseKind.finished);
      expect(finished.completedWorkBlocks, 2);
    });

    test('countdown cues fire once at three, two, and one seconds remaining', () {
      final clock = FakeMonotonicClock();
      final engine = TimerEngine(
        plan: _plan(preparationSeconds: 5, workSeconds: 10),
        clock: clock,
      );

      engine.start();
      clock.elapse(const Duration(seconds: 2));
      expect(engine.advance().events.single.countdownSeconds, 3);
      clock.elapse(const Duration(seconds: 1));
      expect(engine.advance().events.single.countdownSeconds, 2);
      clock.elapse(const Duration(seconds: 1));
      expect(engine.advance().events.single.countdownSeconds, 1);
      expect(engine.advance().events, isEmpty);
    });

    test('pause and resume exclude paused time', () {
      final clock = FakeMonotonicClock();
      final engine = TimerEngine(
        plan: _plan(preparationSeconds: 0, workSeconds: 10),
        clock: clock,
      );

      engine.start();
      clock.elapse(const Duration(seconds: 3));
      engine.pause();
      clock.elapse(const Duration(minutes: 5));
      expect(engine.snapshot.phaseRemaining, const Duration(seconds: 7));

      engine.resume();
      clock.elapse(const Duration(seconds: 7));
      expect(engine.advance().status, TimerStatus.completed);
      expect(engine.snapshot.elapsed, const Duration(seconds: 10));
    });

    test('set rest follows the last round and preserves round/set numbers', () {
      final clock = FakeMonotonicClock();
      final engine = TimerEngine(
        plan: _plan(
          preparationSeconds: 0,
          workSeconds: 1,
          rounds: 2,
          sets: 2,
          roundRestSeconds: 2,
          setRestSeconds: 5,
        ),
        clock: clock,
      );

      engine.start();
      clock.elapse(const Duration(seconds: 1));
      expect(engine.advance().phase.kind, TimerPhaseKind.roundRest);
      clock.elapse(const Duration(seconds: 2));
      final lastRound = engine.advance();
      expect(lastRound.phase.kind, TimerPhaseKind.work);
      expect(lastRound.phase.roundNumber, 2);
      clock.elapse(const Duration(seconds: 1));
      expect(engine.advance().phase.kind, TimerPhaseKind.setRest);
      clock.elapse(const Duration(seconds: 5));
      final nextSet = engine.advance();
      expect(nextSet.phase.kind, TimerPhaseKind.work);
      expect(nextSet.phase.roundNumber, 1);
      expect(nextSet.phase.setNumber, 2);
    });

    test('restart returns to the first phase and skip advances exactly one phase', () {
      final clock = FakeMonotonicClock();
      final engine = TimerEngine(
        plan: _plan(preparationSeconds: 5, workSeconds: 3, restSeconds: 2),
        clock: clock,
      );

      engine.start();
      expect(engine.skipPhase().phase.kind, TimerPhaseKind.work);
      expect(engine.skipPhase().phase.kind, TimerPhaseKind.rest);
      expect(engine.skipPhase().status, TimerStatus.completed);

      expect(engine.restart().phase.kind, TimerPhaseKind.preparation);
      expect(engine.snapshot.status, TimerStatus.idle);
      expect(engine.snapshot.elapsed, Duration.zero);
    });

    test('catches up over device sleep and emits crossed boundaries only once', () {
      final clock = FakeMonotonicClock();
      final engine = TimerEngine(
        plan: _plan(
          preparationSeconds: 0,
          workSeconds: 2,
          restSeconds: 1,
          rounds: 3,
        ),
        clock: clock,
      );

      engine.start();
      clock.elapse(const Duration(seconds: 4, milliseconds: 500));
      final caughtUp = engine.advance();

      expect(caughtUp.phase.kind, TimerPhaseKind.work);
      expect(caughtUp.phase.roundNumber, 2);
      expect(caughtUp.phaseRemaining, const Duration(milliseconds: 500));
      expect(
        caughtUp.events.where((event) => event.kind == TimerEventKind.phaseChanged),
        hasLength(2),
      );
      expect(engine.advance().events, isEmpty);
    });
  });

  test('free cardio counts up without a remaining-time limit', () {
    final clock = FakeMonotonicClock();
    final engine = TimerEngine(
      plan: WorkoutPlan(
        id: 'free',
        name: 'Cardio libre',
        mode: WorkoutMode.stopwatch,
        blocks: const [],
        preparationSeconds: 0,
      ),
      clock: clock,
    );

    engine.start();
    clock.elapse(const Duration(minutes: 4, seconds: 30));
    final running = engine.advance();

    expect(running.status, TimerStatus.running);
    expect(running.phase.kind, TimerPhaseKind.stopwatch);
    expect(running.phaseRemaining, isNull);
    expect(running.elapsed, const Duration(minutes: 4, seconds: 30));
    expect(engine.stop().status, TimerStatus.completed);
  });
}

WorkoutPlan _plan({
  required int preparationSeconds,
  required int workSeconds,
  int restSeconds = 0,
  int rounds = 1,
  int sets = 1,
  int roundRestSeconds = 0,
  int setRestSeconds = 0,
  int cooldownSeconds = 0,
}) {
  return WorkoutPlan(
    id: 'test-plan',
    name: 'Test plan',
    preparationSeconds: preparationSeconds,
    rounds: rounds,
    sets: sets,
    restBetweenRoundsSeconds: roundRestSeconds,
    restBetweenSetsSeconds: setRestSeconds,
    cooldownSeconds: cooldownSeconds,
    blocks: [
      WorkoutBlock(
        id: 'block-a',
        name: 'Trabajo',
        workSeconds: workSeconds,
        restAfterSeconds: restSeconds,
      ),
    ],
  );
}

class FakeMonotonicClock implements MonotonicClock {
  int _nowMicroseconds = 0;

  @override
  int nowMicroseconds() => _nowMicroseconds;

  void elapse(Duration duration) {
    _nowMicroseconds += duration.inMicroseconds;
  }
}
