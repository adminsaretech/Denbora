import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';
import 'package:tempo_workout_timer/features/timer/application/timer_controller.dart';
import 'package:tempo_workout_timer/features/timer/application/timer_providers.dart';
import 'package:tempo_workout_timer/features/timer/data/active_session_store.dart';
import 'package:tempo_workout_timer/features/timer/presentation/workout_timer_screen.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_plan.dart';
import 'package:tempo_workout_timer/core/clock/monotonic_clock.dart';

void main() {
  late TimerController controller;
  late ManualClock clock;

  setUp(() {
    clock = ManualClock();
    controller = TimerController(
      clock: clock,
      activeSessionStore: MemoryActiveSessionStore(),
      startTicker: false,
    );
  });

  tearDown(() => controller.dispose());

  testWidgets('pauses, resumes, catches up and skips an interval phase', (
    tester,
  ) async {
    final plan = WorkoutPlan(
      id: 'timer-test',
      name: 'Prueba',
      preparationSeconds: 0,
      blocks: const [
        WorkoutBlock(
          id: 'block',
          name: 'Burpees',
          workSeconds: 3,
          restAfterSeconds: 2,
        ),
      ],
      rounds: 2,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timerControllerProvider.overrideWithValue(controller),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(MemorySettingsStorage()),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: TempoApp(homeOverride: WorkoutTimerScreen(plan: plan)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Trabajo'), findsOneWidget);
    expect(find.text('0:03'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('timer-pause')));
    await tester.pumpAndSettle();
    expect(find.text('En pausa'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('timer-resume')));
    await tester.tap(find.byKey(const ValueKey('timer-resume')));
    await tester.pumpAndSettle();
    clock.advance(const Duration(seconds: 3));
    await controller.refresh();
    await tester.pumpAndSettle();
    expect(find.text('Descanso'), findsOneWidget);
    expect(find.text('0:02'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('timer-skip')));
    await tester.tap(find.byKey(const ValueKey('timer-skip')));
    await tester.pumpAndSettle();
    expect(find.text('Trabajo'), findsOneWidget);
    expect(find.text('0:03'), findsOneWidget);
  });

  testWidgets('announces the stopwatch elapsed time accessibly', (
    tester,
  ) async {
    final plan = WorkoutPlan(
      id: 'stopwatch-test',
      name: 'Cardio libre',
      mode: WorkoutMode.stopwatch,
      blocks: const [],
      preparationSeconds: 0,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timerControllerProvider.overrideWithValue(controller),
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(MemorySettingsStorage()),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: TempoApp(homeOverride: WorkoutTimerScreen(plan: plan)),
      ),
    );
    await tester.pumpAndSettle();
    clock.advance(const Duration(seconds: 65));
    await controller.refresh();
    await tester.pumpAndSettle();

    expect(find.text('1:05'), findsOneWidget);
    expect(find.bySemanticsLabel('Cronómetro, 1:05'), findsOneWidget);
    expect(find.byKey(const ValueKey('timer-stop')), findsOneWidget);
  });
}

class ManualClock implements MonotonicClock {
  int _elapsed = 0;

  void advance(Duration duration) {
    _elapsed += duration.inMicroseconds;
  }

  @override
  int nowMicroseconds() => _elapsed;
}

class MemorySettingsStorage implements SettingsStorage {
  @override
  Future<bool?> getBool(String key) async => null;

  @override
  Future<String?> getString(String key) async => null;

  @override
  Future<void> setBool(String key, bool value) async {}

  @override
  Future<void> setString(String key, String value) async {}
}
