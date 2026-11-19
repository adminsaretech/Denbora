import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_workout_timer/app/tempo_app.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';
import 'package:tempo_workout_timer/features/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('settings exposes language, theme, and accessible switches',
      (tester) async {
    final storage = MemorySettingsStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(storage),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: const TempoApp(homeOverride: SettingsScreen()),
      ),
    );

    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.byKey(const ValueKey('language-select')), findsOneWidget);
    expect(find.byKey(const ValueKey('theme-select')), findsOneWidget);
    expect(find.byKey(const ValueKey('setting-soundEnabled')), findsOneWidget);
    expect(find.byKey(const ValueKey('setting-voiceEnabled')), findsOneWidget);
    expect(find.byKey(const ValueKey('setting-hapticsEnabled')), findsOneWidget);
    expect(find.byKey(const ValueKey('setting-keepScreenOn')), findsOneWidget);
    expect(find.byKey(const ValueKey('setting-backgroundCuesEnabled')),
        findsOneWidget);
    expect(
      tester.widget<SwitchListTile>(
        find.byKey(const ValueKey('setting-backgroundCuesEnabled')),
      ).onChanged,
      isNull,
    );
  });

  testWidgets('sound setting can be turned off and is saved', (tester) async {
    final storage = MemorySettingsStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(storage),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: const TempoApp(homeOverride: SettingsScreen()),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('setting-soundEnabled')));
    await tester.pumpAndSettle();

    expect(storage.values['soundEnabled'], false);
    expect(
      tester.widget<SwitchListTile>(
        find.byKey(const ValueKey('setting-soundEnabled')),
      ).value,
      isFalse,
    );
  });

  testWidgets('language selection switches the visible UI to English',
      (tester) async {
    final storage = MemorySettingsStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(storage),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: const TempoApp(homeOverride: SettingsScreen()),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('language-select')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inglés'));
    await tester.pumpAndSettle();

    expect(storage.values['languageCode'], 'en');
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Cues'), findsOneWidget);
  });

  testWidgets('theme selection persists dark mode', (tester) async {
    final storage = MemorySettingsStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(storage),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: const TempoApp(homeOverride: SettingsScreen()),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('theme-select')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oscuro'));
    await tester.pumpAndSettle();

    expect(storage.values['themeMode'], 'dark');
  });

  testWidgets('settings remain scrollable at 200 percent text scale',
      (tester) async {
    final storage = MemorySettingsStorage();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(
            SettingsRepository(storage),
          ),
          initialAppSettingsProvider.overrideWithValue(
            const AppSettings(onboardingCompleted: true),
          ),
        ],
        child: TempoApp(
          homeOverride: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(2),
              ),
              child: const SettingsScreen(),
            ),
          ),
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('setting-backgroundCuesEnabled')),
      160,
    );
    expect(find.byKey(const ValueKey('setting-backgroundCuesEnabled')),
        findsOneWidget);
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
  Future<void> setString(String key, String value) async =>
      values[key] = value;
}
