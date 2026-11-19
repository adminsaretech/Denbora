import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('first launch reaches the offline workout home', (tester) async {
    final storage = _MemorySettingsStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(storage),
          ),
          initialAppSettingsProvider.overrideWithValue(const AppSettings()),
        ],
        child: const TempoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tu ritmo, a tu manera'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
    await tester.pumpAndSettle();

    expect(find.text('Entrenamientos'), findsNWidgets(2));
    expect(storage.values['onboardingCompleted'], isTrue);
  });
}

class _MemorySettingsStorage implements SettingsStorage {
  final Map<String, Object> values = {};

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async => values[key] = value;

  @override
  Future<void> setString(String key, String value) async =>
      values[key] = value;
}
