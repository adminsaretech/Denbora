import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/settings/data/settings_repository.dart';
import 'tempo_home_screen.dart';

class TempoApp extends ConsumerWidget {
  const TempoApp({super.key, this.homeOverride});

  final Widget? homeOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      locale: settings.locale,
      localizationsDelegates: TempoLocalizationDelegates.all,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      home:
          homeOverride ??
          (settings.onboardingCompleted
              ? const TempoHomeScreen()
              : const OnboardingScreen()),
    );
  }
}
