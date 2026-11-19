import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';

void main() {
  testWidgets(
    'home provides four clear destinations without localization errors',
    (tester) async {
      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            initialAppSettingsProvider.overrideWithValue(
              const AppSettings(onboardingCompleted: true),
            ),
          ],
          child: const TempoApp(),
        ),
      );

      expect(find.byKey(const ValueKey('nav-tabata')), findsOneWidget);
      expect(find.byKey(const ValueKey('nav-workouts')), findsOneWidget);
      expect(find.byKey(const ValueKey('nav-stopwatch')), findsOneWidget);
      expect(find.byKey(const ValueKey('nav-more')), findsOneWidget);
      expect(tester.takeException(), isNull);

      expect(find.text('20 s'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('tabata-preparation-value')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('tabata-cycle-rest-value')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('tabata-cycles-value')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('tabata-cooldown-value')),
        findsOneWidget,
      );
      final workIncrement = find.byKey(const ValueKey('tabata-work-increment'));
      await tester.ensureVisible(workIncrement);
      await tester.pumpAndSettle();
      final workButton = tester.widget<IconButton>(workIncrement);
      expect(workButton.onPressed, isNotNull);
      workButton.onPressed!.call();
      await tester.pump();
      expect(find.text('25 s'), findsOneWidget);

      final cyclesIncrement = find.byKey(
        const ValueKey('tabata-cycles-increment'),
      );
      await tester.ensureVisible(cyclesIncrement);
      await tester.pumpAndSettle();
      final cyclesButton = tester.widget<IconButton>(cyclesIncrement);
      expect(cyclesButton.onPressed, isNotNull);
      cyclesButton.onPressed!.call();
      await tester.pump();
      expect(find.text('2'), findsOneWidget);
      expect(find.text('8 rondas por ciclo · 2 ciclos'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('tabata-duration-value')),
        findsOneWidget,
      );
      expect(find.text('9:25'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('nav-stopwatch')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('stopwatch-start')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('nav-more')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('more-history')), findsOneWidget);
      expect(find.byKey(const ValueKey('more-settings')), findsOneWidget);
    },
  );
}
