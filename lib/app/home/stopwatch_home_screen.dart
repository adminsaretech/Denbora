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
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(strings.navStopwatch)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.av_timer_rounded,
                        size: 60,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    '00:00',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.stopwatchIntro,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 28),
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
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant),
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

