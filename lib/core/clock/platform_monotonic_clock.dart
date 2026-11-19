import 'dart:async';

import 'package:flutter/services.dart';

import 'monotonic_clock.dart';

/// Uses the platform's sleep-aware monotonic clock as its anchor and a Dart
/// Stopwatch between samples while the Flutter isolate is active.
class PlatformMonotonicClock implements RefreshableMonotonicClock {
  PlatformMonotonicClock({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('com.saretech.tempo/clock');

  final MethodChannel _channel;
  final Stopwatch _sinceSample = Stopwatch();
  int _anchorMicroseconds = 0;
  bool _hasNativeSample = false;

  @override
  int nowMicroseconds() {
    if (!_hasNativeSample) return _sinceSample.elapsedMicroseconds;
    return _anchorMicroseconds + _sinceSample.elapsedMicroseconds;
  }

  @override
  Future<void> synchronize() async {
    final nativeTime = await _channel.invokeMethod<int>('nowMicroseconds');
    if (nativeTime == null || nativeTime < 0) {
      throw StateError('The native monotonic clock returned an invalid sample.');
    }
    _anchorMicroseconds = nativeTime;
    _hasNativeSample = true;
    _sinceSample
      ..reset()
      ..start();
  }
}
