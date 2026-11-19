import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/tempo_tokens.dart';
import '../../settings/data/settings_repository.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    void complete() {
      final settings = ref.read(appSettingsProvider);
      unawaited(
        ref.read(appSettingsProvider.notifier).updateSettings(
              settings.copyWith(onboardingCompleted: true),
            ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    key: const ValueKey('onboarding-skip'),
                    onPressed: complete,
                    child: Text(strings.onboardingSkip),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Semantics(
                    image: true,
                    label: strings.brandName,
                    child: Image.asset(
                      'assets/branding/tempo-app-icon-1024.png',
                      width: 128,
                      height: 128,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  strings.onboardingTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  strings.onboardingLead,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 28),
                _Benefit(
                  icon: Icons.cloud_off_rounded,
                  title: strings.onboardingOffline,
                  detail: strings.onboardingOfflineDetail,
                ),
                _Benefit(
                  icon: Icons.tune_rounded,
                  title: strings.onboardingPersonalize,
                  detail: strings.onboardingPersonalizeDetail,
                ),
                _Benefit(
                  icon: Icons.notifications_active_outlined,
                  title: strings.onboardingCues,
                  detail: strings.onboardingCuesDetail,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const ValueKey('onboarding-complete'),
                  onPressed: complete,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(strings.onboardingContinue),
                ),
                const SizedBox(height: TempoTokens.controlGap),
                Text(
                  strings.settingsPrivacy,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Benefit extends StatelessWidget {
  const _Benefit({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: TempoTokens.touchTarget,
            height: TempoTokens.touchTarget,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: colors.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(detail, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
