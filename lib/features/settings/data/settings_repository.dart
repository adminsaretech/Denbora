import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/app_settings.dart';

abstract interface class SettingsStorage {
  Future<String?> getString(String key);
  Future<bool?> getBool(String key);
  Future<void> setString(String key, String value);
  Future<void> setBool(String key, bool value);
}

class SharedPreferencesSettingsStorage implements SettingsStorage {
  SharedPreferencesSettingsStorage({SharedPreferencesAsync? preferences})
      : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<bool?> getBool(String key) => _preferences.getBool(key);

  @override
  Future<String?> getString(String key) => _preferences.getString(key);

  @override
  Future<void> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  @override
  Future<void> setString(String key, String value) =>
      _preferences.setString(key, value);
}

class SettingsRepository {
  SettingsRepository(this._storage);

  final SettingsStorage _storage;

  Future<AppSettings> load() async {
    final language = await _storage.getString('languageCode');
    final theme = await _storage.getString('themeMode');
    return AppSettings(
      languageCode: language == 'system' ? null : language ?? 'es',
      themeMode: ThemeMode.values.firstWhere(
        (mode) => mode.name == theme,
        orElse: () => ThemeMode.system,
      ),
      metricUnits: await _storage.getBool('metricUnits') ?? true,
      soundEnabled: await _storage.getBool('soundEnabled') ?? true,
      voiceEnabled: await _storage.getBool('voiceEnabled') ?? false,
      hapticsEnabled: await _storage.getBool('hapticsEnabled') ?? true,
      keepScreenOn: await _storage.getBool('keepScreenOn') ?? false,
      backgroundCuesEnabled:
          await _storage.getBool('backgroundCuesEnabled') ?? true,
      onboardingCompleted:
          await _storage.getBool('onboardingCompleted') ?? false,
    );
  }

  Future<void> save(AppSettings settings) async {
    await Future.wait([
      _storage.setString('languageCode', settings.languageCode ?? 'system'),
      _storage.setString('themeMode', settings.themeMode.name),
      _storage.setBool('metricUnits', settings.metricUnits),
      _storage.setBool('soundEnabled', settings.soundEnabled),
      _storage.setBool('voiceEnabled', settings.voiceEnabled),
      _storage.setBool('hapticsEnabled', settings.hapticsEnabled),
      _storage.setBool('keepScreenOn', settings.keepScreenOn),
      _storage.setBool(
        'backgroundCuesEnabled',
        settings.backgroundCuesEnabled,
      ),
      _storage.setBool('onboardingCompleted', settings.onboardingCompleted),
    ]);
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(SharedPreferencesSettingsStorage()),
);

final initialAppSettingsProvider = Provider<AppSettings>(
  (ref) => const AppSettings(),
);

final appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
  AppSettingsController.new,
);

class AppSettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => ref.watch(initialAppSettingsProvider);

  Future<void> updateSettings(AppSettings next) async {
    state = next;
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
