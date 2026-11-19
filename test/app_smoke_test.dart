import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';

void main() {
  testWidgets('home presents Tempo and the workout library', (tester) async {
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

    expect(find.text('Tempo'), findsOneWidget);
    expect(find.text('Entrenamientos'), findsNWidgets(2));
  });
}
