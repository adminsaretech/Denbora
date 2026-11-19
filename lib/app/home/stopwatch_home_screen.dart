import 'package:material_ui/material_ui.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/tempo_tokens.dart';
import '../../features/timer/presentation/workout_timer_screen.dart';
import '../../features/workouts/data/workout_templates.dart';

class StopwatchHomeScreen extends StatelessWidget {
  const StopwatchHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.navStopwatch)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    strings.stopwatchIntro,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 72),
                  Text(
                    '00:00',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.stopwatchReady,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 48),
                  FilledButton.icon(
                    key: const ValueKey('stopwatch-start'),
                    onPressed: () => Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) => WorkoutTimerScreen(
                          plan: WorkoutTemplates.byId('free-cardio'),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(strings.stopwatchStart),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        TempoTokens.touchTarget,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    strings.stopwatchHint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
