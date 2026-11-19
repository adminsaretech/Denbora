abstract interface class MonotonicClock {
  /// Returns monotonic microseconds from an arbitrary, process-independent base.
  int nowMicroseconds();
}

/// Optional capability for clocks that need an asynchronous native sample.
abstract interface class RefreshableMonotonicClock implements MonotonicClock {
  Future<void> synchronize();
}

class StopwatchMonotonicClock implements MonotonicClock {
  StopwatchMonotonicClock() : _stopwatch = Stopwatch()..start();

  final Stopwatch _stopwatch;

  @override
  int nowMicroseconds() => _stopwatch.elapsedMicroseconds;
}
