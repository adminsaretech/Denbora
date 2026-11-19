import 'package:material_ui/material_ui.dart';

class AppSettings {
  const AppSettings({
    this.languageCode = 'es',
    this.themeMode = ThemeMode.system,
    this.metricUnits = true,
    this.soundEnabled = true,
    this.voiceEnabled = false,
    this.hapticsEnabled = true,
    this.keepScreenOn = false,
    this.backgroundCuesEnabled = false,
    this.onboardingCompleted = false,
  });

  final String? languageCode;
  final ThemeMode themeMode;
  final bool metricUnits;
  final bool soundEnabled;
  final bool voiceEnabled;
  final bool hapticsEnabled;
  final bool keepScreenOn;
  final bool backgroundCuesEnabled;
  final bool onboardingCompleted;

  Locale? get locale => languageCode == null ? null : Locale(languageCode!);

  AppSettings copyWith({
    String? languageCode,
    bool clearLanguageCode = false,
    ThemeMode? themeMode,
    bool? metricUnits,
    bool? soundEnabled,
    bool? voiceEnabled,
    bool? hapticsEnabled,
    bool? keepScreenOn,
    bool? backgroundCuesEnabled,
    bool? onboardingCompleted,
  }) =>
      AppSettings(
        languageCode:
            clearLanguageCode ? null : languageCode ?? this.languageCode,
        themeMode: themeMode ?? this.themeMode,
        metricUnits: metricUnits ?? this.metricUnits,
        soundEnabled: soundEnabled ?? this.soundEnabled,
        voiceEnabled: voiceEnabled ?? this.voiceEnabled,
        hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
        keepScreenOn: keepScreenOn ?? this.keepScreenOn,
        backgroundCuesEnabled:
            backgroundCuesEnabled ?? this.backgroundCuesEnabled,
        onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      );
}
