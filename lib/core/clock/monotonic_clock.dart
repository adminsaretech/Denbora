abstract interface class MonotonicClock {
  /// Returns monotonic microseconds from an arbitrary, process-independent base.
  int nowMicroseconds();
}

class StopwatchMonotonicClock implements MonotonicClock {
  StopwatchMonotonicClock() : _stopwatch = Stopwatch()..start();

  final Stopwatch _stopwatch;

  @override
  int nowMicroseconds() => _stopwatch.elapsedMicroseconds;
}
