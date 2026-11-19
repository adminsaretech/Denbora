import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../data/settings_repository.dart';
import '../domain/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    Future<void> update(AppSettings value) => ref
        .read(appSettingsProvider.notifier)
        .updateSettings(value);

    return Scaffold(
      appBar: AppBar(title: Text(strings.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _SectionCard(
              title: strings.settingsLanguage,
              icon: Icons.translate_rounded,
              child: DropdownButtonFormField<String>(
                key: const ValueKey('language-select'),
                initialValue: settings.languageCode ?? 'system',
                isExpanded: true,
                decoration: InputDecoration(labelText: strings.settingsLanguage),
                items: [
                  DropdownMenuItem(
                    value: 'system',
                    child: Text(strings.settingsLanguageSystem),
                  ),
                  DropdownMenuItem(
                    value: 'es',
                    child: Text(strings.settingsLanguageSpanish),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(strings.settingsLanguageEnglish),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  unawaited(update(settings.copyWith(
                    languageCode: value == 'system' ? null : value,
                    clearLanguageCode: value == 'system',
                  )));
                },
              ),
            ),
            _SectionCard(
              title: strings.settingsAppearance,
              icon: Icons.contrast_rounded,
              child: DropdownButtonFormField<ThemeMode>(
                key: const ValueKey('theme-select'),
                initialValue: settings.themeMode,
                isExpanded: true,
                decoration: InputDecoration(labelText: strings.settingsAppearance),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(strings.settingsThemeSystem),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(strings.settingsThemeLight),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(strings.settingsThemeDark),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    unawaited(update(settings.copyWith(themeMode: value)));
                  }
                },
              ),
            ),
            _SectionCard(
              title: strings.settingsUnits,
              icon: Icons.straighten_rounded,
              child: DropdownButtonFormField<bool>(
                key: const ValueKey('units-select'),
                initialValue: settings.metricUnits,
                isExpanded: true,
                decoration: InputDecoration(labelText: strings.settingsUnits),
                items: [
                  DropdownMenuItem(
                    value: true,
                    child: Text(strings.settingsUnitsMetric),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Text(strings.settingsUnitsImperial),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    unawaited(update(settings.copyWith(metricUnits: value)));
                  }
                },
              ),
            ),
            _SectionCard(
              title: strings.settingsCues,
              icon: Icons.tune_rounded,
              child: Column(
                children: [
                  _settingSwitch(
                    keyName: 'soundEnabled',
                    title: strings.settingsSound,
                    value: settings.soundEnabled,
                    onChanged: (value) => unawaited(
                      update(settings.copyWith(soundEnabled: value)),
                    ),
                  ),
                  _settingSwitch(
                    keyName: 'voiceEnabled',
                    title: strings.settingsVoice,
                    value: settings.voiceEnabled,
                    onChanged: (value) => unawaited(
                      update(settings.copyWith(voiceEnabled: value)),
                    ),
                  ),
                  _settingSwitch(
                    keyName: 'hapticsEnabled',
                    title: strings.settingsHaptics,
                    value: settings.hapticsEnabled,
                    onChanged: (value) => unawaited(
                      update(settings.copyWith(hapticsEnabled: value)),
                    ),
                  ),
                  _settingSwitch(
                    keyName: 'keepScreenOn',
                    title: strings.settingsKeepScreenOn,
                    value: settings.keepScreenOn,
                    onChanged: (value) => unawaited(
                      update(settings.copyWith(keepScreenOn: value)),
                    ),
                  ),
                  _settingSwitch(
                    keyName: 'backgroundCuesEnabled',
                    title: strings.settingsBackgroundCues,
                    subtitle: strings.settingsBackgroundCuesNote,
                    value: settings.backgroundCuesEnabled,
                    onChanged: (value) => unawaited(
                      update(settings.copyWith(backgroundCuesEnabled: value)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                strings.settingsPrivacy,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingSwitch({
    required String keyName,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      SwitchListTile(
        key: ValueKey('setting-$keyName'),
        contentPadding: EdgeInsets.zero,
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle),
        value: value,
        onChanged: onChanged,
      );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
