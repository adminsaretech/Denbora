import '../../../core/clock/monotonic_clock.dart';
import '../../workouts/domain/workout_plan.dart';
import '../../workouts/domain/workout_validation.dart';
import 'timer_phase.dart';
import 'timer_snapshot.dart';

class TimerEngine {
  TimerEngine({required this.plan, required this.clock}) {
    final validation = WorkoutValidation.validate(plan);
    if (!validation.isValid) {
      throw ArgumentError.value(
        validation.errors.map((error) => error.code).join(', '),
        'plan',
        'Workout plan is invalid.',
      );
    }

    _phases = List<TimerPhase>.unmodifiable(_buildPhases());
    final starts = <int>[];
    var total = 0;
    for (final phase in _phases) {
      starts.add(total);
      total += phase.durationSeconds * Duration.microsecondsPerSecond;
    }
    _phaseStartsMicroseconds = List<int>.unmodifiable(starts);
    _totalDurationMicroseconds = total;
  }

  final WorkoutPlan plan;
  final MonotonicClock clock;

  late final List<TimerPhase> _phases;
  late final List<int> _phaseStartsMicroseconds;
  late final int _totalDurationMicroseconds;
  final TimerPhase _finishedPhase = const TimerPhase(
    kind: TimerPhaseKind.finished,
    label: 'Terminado',
    durationSeconds: 0,
    roundNumber: 0,
    setNumber: 0,
  );

  TimerStatus _status = TimerStatus.idle;
  int _elapsedMicroseconds = 0;
  int _lastNowMicroseconds = 0;

  TimerSnapshot get snapshot => _makeSnapshot();

  TimerSnapshot start() {
    if (_status != TimerStatus.idle) {
      throw StateError('Restart the timer before starting it again.');
    }

    _elapsedMicroseconds = 0;
    _lastNowMicroseconds = clock.nowMicroseconds();
    _status = TimerStatus.running;

    final initialPhase = _phases.isNotEmpty ? _phases.first : _finishedPhase;
    final events = <TimerEvent>[
      TimerEvent(kind: TimerEventKind.started, phase: initialPhase),
    ];
    if (_phases.isNotEmpty) {
      final phase = _phases.first;
      events.add(TimerEvent(kind: TimerEventKind.phaseChanged, phase: phase));
      events.addAll(_countdownsAtPhaseStart(phase));
    }
    return _makeSnapshot(events: events);
  }

  TimerSnapshot advance() {
    if (_status != TimerStatus.running) return _makeSnapshot();

    final previousElapsed = _elapsedMicroseconds;
    final now = clock.nowMicroseconds();
    if (now > _lastNowMicroseconds) {
      _elapsedMicroseconds += now - _lastNowMicroseconds;
    }
    _lastNowMicroseconds = now;

    if (plan.mode == WorkoutMode.stopwatch) return _makeSnapshot();

    if (_elapsedMicroseconds > _totalDurationMicroseconds) {
      _elapsedMicroseconds = _totalDurationMicroseconds;
    }
    final events = _eventsBetween(previousElapsed, _elapsedMicroseconds);
    if (_elapsedMicroseconds >= _totalDurationMicroseconds) {
      _status = TimerStatus.completed;
      events.add(
        TimerEvent(kind: TimerEventKind.completed, phase: _finishedPhase),
      );
    }
    return _makeSnapshot(events: events);
  }

  TimerSnapshot pause() {
    if (_status != TimerStatus.running) return _makeSnapshot();
    final advanced = advance();
    if (_status == TimerStatus.running) _status = TimerStatus.paused;
    return _makeSnapshot(events: advanced.events);
  }

  TimerSnapshot resume() {
    if (_status != TimerStatus.paused) return _makeSnapshot();
    _lastNowMicroseconds = clock.nowMicroseconds();
    _status = TimerStatus.running;
    final phase = _phaseAtElapsed();
    return _makeSnapshot(
      events: [TimerEvent(kind: TimerEventKind.resumed, phase: phase)],
    );
  }

  TimerSnapshot restart() {
    _status = TimerStatus.idle;
    _elapsedMicroseconds = 0;
    _lastNowMicroseconds = clock.nowMicroseconds();
    return _makeSnapshot();
  }

  TimerSnapshot skipPhase() {
    if (_status != TimerStatus.running || plan.mode == WorkoutMode.stopwatch) {
      return _makeSnapshot();
    }

    final advanced = advance();
    if (_status != TimerStatus.running) return advanced;

    final phaseIndex = _phaseIndexAtElapsed();
    if (phaseIndex >= _phases.length) return _makeSnapshot();

    final currentPhase = _phases[phaseIndex];
    final phaseEnd = _phaseStartsMicroseconds[phaseIndex] +
        currentPhase.durationSeconds * Duration.microsecondsPerSecond;
    _elapsedMicroseconds = phaseEnd;

    final events = <TimerEvent>[
      ...advanced.events,
      TimerEvent(kind: TimerEventKind.skipped, phase: currentPhase),
    ];
    if (_elapsedMicroseconds >= _totalDurationMicroseconds) {
      _status = TimerStatus.completed;
      events.add(
        TimerEvent(kind: TimerEventKind.completed, phase: _finishedPhase),
      );
    } else {
      events.add(
        TimerEvent(
          kind: TimerEventKind.phaseChanged,
          phase: _phaseAtElapsed(),
        ),
      );
    }
    return _makeSnapshot(events: events);
  }

  TimerSnapshot stop() {
    if (_status == TimerStatus.running) {
      final advanced = advance();
      if (_status == TimerStatus.completed) return advanced;
    }
    if (_status == TimerStatus.completed || _status == TimerStatus.stopped) {
      return _makeSnapshot();
    }

    final stopwatchCompleted = plan.mode == WorkoutMode.stopwatch;
    _status = stopwatchCompleted ? TimerStatus.completed : TimerStatus.stopped;
    final kind = stopwatchCompleted
        ? TimerEventKind.completed
        : TimerEventKind.stopped;
    return _makeSnapshot(
      events: [TimerEvent(kind: kind, phase: _finishedPhase)],
    );
  }

  List<TimerPhase> _buildPhases() {
    if (plan.mode == WorkoutMode.stopwatch) {
      return [
        TimerPhase(
          kind: TimerPhaseKind.stopwatch,
          label: plan.name,
          durationSeconds: 0,
          roundNumber: 1,
          setNumber: 1,
        ),
      ];
    }

    final phases = <TimerPhase>[];
    void add(
      TimerPhaseKind kind,
      String label,
      int seconds, {
      required int round,
      required int set,
      int? blockIndex,
    }) {
      if (seconds <= 0) return;
      phases.add(
        TimerPhase(
          kind: kind,
          label: label,
          durationSeconds: seconds,
          roundNumber: round,
          setNumber: set,
          blockIndex: blockIndex,
        ),
      );
    }

    add(
      TimerPhaseKind.preparation,
      'Preparación',
      plan.preparationSeconds,
      round: 1,
      set: 1,
    );

    for (var set = 1; set <= plan.sets; set++) {
      for (var round = 1; round <= plan.rounds; round++) {
        for (var blockIndex = 0;
            blockIndex < plan.blocks.length;
            blockIndex++) {
          final block = plan.blocks[blockIndex];
          add(
            TimerPhaseKind.work,
            block.name,
            block.workSeconds,
            round: round,
            set: set,
            blockIndex: blockIndex,
          );
          add(
            TimerPhaseKind.rest,
            'Descanso',
            block.restAfterSeconds,
            round: round,
            set: set,
            blockIndex: blockIndex,
          );
        }

        if (round < plan.rounds) {
          add(
            TimerPhaseKind.roundRest,
            'Descanso entre rondas',
            plan.restBetweenRoundsSeconds,
            round: round,
            set: set,
          );
        }
      }

      if (set < plan.sets) {
        add(
          TimerPhaseKind.setRest,
          'Descanso entre series',
          plan.restBetweenSetsSeconds,
          round: plan.rounds,
          set: set,
        );
      }
    }

    add(
      TimerPhaseKind.cooldown,
      'Enfriamiento',
      plan.cooldownSeconds,
      round: plan.rounds,
      set: plan.sets,
    );
    return phases;
  }

  List<TimerEvent> _eventsBetween(int previousElapsed, int currentElapsed) {
    final events = <TimerEvent>[];
    for (var index = 0; index < _phases.length; index++) {
      final phase = _phases[index];
      final start = _phaseStartsMicroseconds[index];
      final duration = phase.durationSeconds * Duration.microsecondsPerSecond;

      if (index > 0 && start > previousElapsed && start <= currentElapsed) {
        events.add(
          TimerEvent(kind: TimerEventKind.phaseChanged, phase: phase),
        );
      }

      final lastCue = phase.durationSeconds < 3 ? phase.durationSeconds : 3;
      for (var remaining = lastCue; remaining >= 1; remaining--) {
        final cueAt = start +
            duration -
            remaining * Duration.microsecondsPerSecond;
        if (cueAt > previousElapsed && cueAt <= currentElapsed) {
          events.add(
            TimerEvent(
              kind: TimerEventKind.countdown,
              phase: phase,
              countdownSeconds: remaining,
            ),
          );
        }
      }
    }
    return events;
  }

  List<TimerEvent> _countdownsAtPhaseStart(TimerPhase phase) {
    final duration = phase.durationSeconds;
    final lastCue = duration < 3 ? duration : 3;
    if (lastCue <= 0) return const [];

    final events = <TimerEvent>[];
    for (var remaining = lastCue; remaining >= 1; remaining--) {
      if (duration - remaining == 0) {
        events.add(
          TimerEvent(
            kind: TimerEventKind.countdown,
            phase: phase,
            countdownSeconds: remaining,
          ),
        );
      }
    }
    return events;
  }

  int _phaseIndexAtElapsed() {
    if (plan.mode == WorkoutMode.stopwatch) return 0;
    for (var index = 0; index < _phases.length; index++) {
      final end = _phaseStartsMicroseconds[index] +
          _phases[index].durationSeconds * Duration.microsecondsPerSecond;
      if (_elapsedMicroseconds < end) return index;
    }
    return _phases.length;
  }

  TimerPhase _phaseAtElapsed() {
    final index = _phaseIndexAtElapsed();
    if (index >= _phases.length) return _finishedPhase;
    return _phases[index];
  }

  TimerSnapshot _makeSnapshot({List<TimerEvent> events = const []}) {
    final index = _phaseIndexAtElapsed();
    final isFinished =
        _status == TimerStatus.completed || _status == TimerStatus.stopped;
    final phase = isFinished || index >= _phases.length
        ? _finishedPhase
        : _phases[index];

    Duration? remaining;
    if (phase.kind != TimerPhaseKind.stopwatch) {
      if (phase.kind == TimerPhaseKind.finished || index >= _phases.length) {
        remaining = Duration.zero;
      } else {
        final end = _phaseStartsMicroseconds[index] +
            phase.durationSeconds * Duration.microsecondsPerSecond;
        final remainingMicroseconds = end - _elapsedMicroseconds;
        remaining = Duration(
          microseconds: remainingMicroseconds > 0 ? remainingMicroseconds : 0,
        );
      }
    }

    final elapsed = plan.mode == WorkoutMode.stopwatch
        ? _elapsedMicroseconds
        : (_elapsedMicroseconds < _totalDurationMicroseconds
              ? _elapsedMicroseconds
              : _totalDurationMicroseconds);
    return TimerSnapshot(
      status: _status,
      phase: phase,
      phaseIndex: index,
      phaseCount: _phases.length,
      phaseRemaining: remaining,
      elapsed: Duration(microseconds: elapsed),
      completedWorkBlocks: _completedWorkBlocks(elapsed),
      events: events,
    );
  }

  int _completedWorkBlocks(int elapsedMicroseconds) {
    var completed = 0;
    for (var index = 0; index < _phases.length; index++) {
      if (_phases[index].kind != TimerPhaseKind.work) continue;
      final end = _phaseStartsMicroseconds[index] +
          _phases[index].durationSeconds * Duration.microsecondsPerSecond;
      if (end <= elapsedMicroseconds) completed++;
    }
    return completed;
  }
}

