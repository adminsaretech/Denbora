import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import '../../../core/audio/timer_cue_service.dart';
import '../../../core/clock/platform_monotonic_clock.dart';
import '../../../core/database/database_providers.dart';
import '../../history/domain/workout_session.dart';
import '../../settings/data/settings_repository.dart';
import '../../workouts/domain/workout_plan.dart';
import '../domain/timer_snapshot.dart';
import 'timer_controller.dart';

final timerControllerProvider = Provider<TimerController>((ref) {
  final clock = PlatformMonotonicClock();
  final cueService = TimerCueService();
  DateTime? startedAt;
  final controller = TimerController(
    clock: clock,
    activeSessionStore: ref.watch(activeSessionStoreProvider),
    onEvent: (event) {
      if (event.kind == TimerEventKind.started) startedAt = DateTime.now();
      final settings = ref.read(appSettingsProvider);
      cueService.handle(event, settings);
      if (settings.hapticsEnabled) {
        if (event.kind == TimerEventKind.countdown) {
          unawaited(HapticFeedback.selectionClick());
        } else if (event.kind == TimerEventKind.phaseChanged) {
          unawaited(HapticFeedback.mediumImpact());
        }
      }
    },
    onCompleted: (plan, snapshot) async {
      final endedAt = DateTime.now();
      final start = startedAt ?? endedAt.subtract(snapshot.elapsed);
      final stopwatch = plan.mode == WorkoutMode.stopwatch;
      await ref
          .read(sessionRepositoryProvider)
          .recordCompleted(
            WorkoutSession(
              id: 'session-${start.toUtc().microsecondsSinceEpoch}',
              workoutId: plan.id,
              workoutName: plan.name,
              startedAt: start,
              durationSeconds: snapshot.elapsed.inSeconds,
              completedRounds: stopwatch ? 0 : plan.rounds * plan.sets,
              completedSets: stopwatch ? 0 : plan.sets,
              wasCompleted: true,
            ),
          );
    },
  );
  ref.onDispose(() {
    controller.dispose();
    cueService.dispose();
  });
  return controller;
});
