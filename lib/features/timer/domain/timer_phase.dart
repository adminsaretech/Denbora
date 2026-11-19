enum TimerPhaseKind {
  preparation,
  work,
  rest,
  roundRest,
  setRest,
  cooldown,
  stopwatch,
  finished,
}

class TimerPhase {
  const TimerPhase({
    required this.kind,
    required this.label,
    required this.durationSeconds,
    required this.roundNumber,
    required this.setNumber,
    this.blockIndex,
  });

  final TimerPhaseKind kind;
  final String label;
  final int durationSeconds;
  final int roundNumber;
  final int setNumber;
  final int? blockIndex;
}
