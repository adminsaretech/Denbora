import 'package:material_ui/material_ui.dart';

import '../../core/localization/app_localizations.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

class MoreHomeScreen extends StatelessWidget {
  const MoreHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(strings.moreTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              strings.moreLead,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 18),
            Card(
              child: ListTile(
                key: const ValueKey('more-history'),
                minVerticalPadding: 16,
                leading: const Icon(Icons.history_rounded),
                title: Text(strings.moreHistory),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const HistoryScreen(),
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                key: const ValueKey('more-settings'),
                minVerticalPadding: 16,
                leading: const Icon(Icons.tune_rounded),
                title: Text(strings.moreSettings),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: colors.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lock_outline_rounded, color: colors.primary),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        strings.morePrivacy,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

