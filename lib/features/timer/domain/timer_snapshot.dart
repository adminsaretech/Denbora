import 'timer_phase.dart';

enum TimerStatus { idle, running, paused, completed, stopped, interrupted }

enum TimerEventKind {
  started,
  resumed,
  phaseChanged,
  countdown,
  skipped,
  completed,
  stopped,
}

class TimerEvent {
  const TimerEvent({
    required this.kind,
    required this.phase,
    this.countdownSeconds,
  });

  final TimerEventKind kind;
  final TimerPhase phase;
  final int? countdownSeconds;
}

class TimerSnapshot {
  TimerSnapshot({
    required this.status,
    required this.phase,
    required this.phaseIndex,
    required this.phaseCount,
    required this.phaseRemaining,
    required this.elapsed,
    required this.completedWorkBlocks,
    List<TimerEvent> events = const [],
  }) : events = List<TimerEvent>.unmodifiable(events);

  final TimerStatus status;
  final TimerPhase phase;
  final int phaseIndex;
  final int phaseCount;
  final Duration? phaseRemaining;
  final Duration elapsed;
  final int completedWorkBlocks;
  final List<TimerEvent> events;

  bool get isRunning => status == TimerStatus.running;
  bool get isPaused => status == TimerStatus.paused;
  bool get isFinished =>
      status == TimerStatus.completed ||
      status == TimerStatus.stopped ||
      status == TimerStatus.interrupted;

  TimerSnapshot withEvents(List<TimerEvent> value) => TimerSnapshot(
        status: status,
        phase: phase,
        phaseIndex: phaseIndex,
        phaseCount: phaseCount,
        phaseRemaining: phaseRemaining,
        elapsed: elapsed,
        completedWorkBlocks: completedWorkBlocks,
        events: value,
      );
}
