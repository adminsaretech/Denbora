import 'package:flutter/widgets.dart' show ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';

void main() {
  testWidgets(
    'home provides four clear destinations without localization errors',
    (tester) async {
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
      await tester.tap(find.byKey(const ValueKey('tabata-work-increment')));
      await tester.pumpAndSettle();
      expect(find.text('25 s'), findsOneWidget);

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

