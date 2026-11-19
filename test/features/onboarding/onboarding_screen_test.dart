import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';

void main() {
  testWidgets('keeps the main onboarding action visible on a compact screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(MemorySettingsStorage()),
          ),
          initialAppSettingsProvider.overrideWithValue(const AppSettings()),
        ],
        child: const TempoApp(),
      ),
    );

    final action = find.byKey(const ValueKey('onboarding-complete'));
    expect(action, findsOneWidget);
    expect(tester.getRect(action).bottom, lessThanOrEqualTo(640));
  });

  testWidgets('first-run onboarding can be skipped without an account', (
    tester,
  ) async {
    final storage = MemorySettingsStorage();
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

    expect(find.text('Tu ritmo, a tu manera'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('onboarding-skip')));
    await tester.pumpAndSettle();

    expect(find.text('Tabata'), findsNWidgets(2));
    expect(storage.values['onboardingCompleted'], isTrue);
  });

  testWidgets('onboarding can be completed with the primary action', (
    tester,
  ) async {
    final storage = MemorySettingsStorage();
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

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('onboarding-complete')),
      180,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('onboarding-complete')));
    await tester.pumpAndSettle();
    expect(find.text('Tabata'), findsNWidgets(2));
    expect(storage.values['onboardingCompleted'], isTrue);
  });
}

class MemorySettingsStorage implements SettingsStorage {
  final Map<String, Object> values = {};

  @override
  Future<bool?> getBool(String key) async => values[key] as bool?;

  @override
  Future<String?> getString(String key) async => values[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async => values[key] = value;

  @override
  Future<void> setString(String key, String value) async => values[key] = value;
}

