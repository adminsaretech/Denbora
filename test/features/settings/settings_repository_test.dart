import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tempo_workout_timer/features/settings/data/settings_repository.dart';
import 'package:tempo_workout_timer/features/settings/domain/app_settings.dart';

void main() {
  test('loads safe Spanish defaults on first launch', () async {
    final settings = await SettingsRepository(MemorySettingsStorage()).load();

    expect(settings.languageCode, 'es');
    expect(settings.themeMode, ThemeMode.system);
    expect(settings.metricUnits, isTrue);
    expect(settings.soundEnabled, isTrue);
    expect(settings.voiceEnabled, isFalse);
    expect(settings.hapticsEnabled, isTrue);
    expect(settings.onboardingCompleted, isFalse);
  });

  test('persists settings including system locale and onboarding state',
      () async {
    final storage = MemorySettingsStorage();
    final repository = SettingsRepository(storage);
    const desired = AppSettings(
      languageCode: null,
      themeMode: ThemeMode.dark,
      metricUnits: false,
      soundEnabled: false,
      voiceEnabled: true,
      hapticsEnabled: false,
      keepScreenOn: true,
      backgroundCuesEnabled: false,
      onboardingCompleted: true,
    );

    await repository.save(desired);
    final loaded = await repository.load();

    expect(loaded.languageCode, isNull);
    expect(loaded.themeMode, ThemeMode.dark);
    expect(loaded.metricUnits, isFalse);
    expect(loaded.soundEnabled, isFalse);
    expect(loaded.voiceEnabled, isTrue);
    expect(loaded.hapticsEnabled, isFalse);
    expect(loaded.keepScreenOn, isTrue);
    expect(loaded.backgroundCuesEnabled, isFalse);
    expect(loaded.onboardingCompleted, isTrue);
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
