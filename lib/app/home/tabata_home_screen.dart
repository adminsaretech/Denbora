import 'package:material_ui/material_ui.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/theme/tempo_tokens.dart';
import '../../features/timer/presentation/workout_timer_screen.dart';
import '../../features/workouts/data/workout_templates.dart';
import '../../features/workouts/domain/workout_plan.dart';

class TabataHomeScreen extends StatefulWidget {
  const TabataHomeScreen({super.key});

  @override
  State<TabataHomeScreen> createState() => _TabataHomeScreenState();
}

class _TabataHomeScreenState extends State<TabataHomeScreen> {
  int _workSeconds = 20;
  int _restSeconds = 10;
  int _rounds = 8;

  WorkoutPlan _plan(String name) {
    final template = WorkoutTemplates.byId('tabata-20-10');
    return template.copyWith(
      name: name,
      rounds: _rounds,
      preparationSeconds: 5,
      blocks: [
        template.blocks.first.copyWith(
          workSeconds: _workSeconds,
          restAfterSeconds: _restSeconds,
        ),
      ],
    );
  }

  void _start(AppLocalizations strings) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => WorkoutTimerScreen(plan: _plan(strings.navTabata)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final plan = _plan(strings.navTabata);
    return Scaffold(
      appBar: AppBar(title: Text(strings.navTabata)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    strings.tabataQuickIntro,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      child: Column(
                        children: [
                          _TabataStepper(
                            keyName: 'tabata-work',
                            label: strings.tabataWork,
                            value: _workSeconds,
                            unit: 's',
                            decreaseLabel: strings.tabataDecreaseWork,
                            increaseLabel: strings.tabataIncreaseWork,
                            canDecrease: _workSeconds > 5,
                            onDecrease: () => setState(
                              () => _workSeconds = (_workSeconds - 5)
                                  .clamp(5, 300)
                                  .toInt(),
                            ),
                            onIncrease: () => setState(
                              () => _workSeconds = (_workSeconds + 5)
                                  .clamp(5, 300)
                                  .toInt(),
                            ),
                          ),
                          const Divider(height: 12),
                          _TabataStepper(
                            keyName: 'tabata-rest',
                            label: strings.tabataRest,
                            value: _restSeconds,
                            unit: 's',
                            decreaseLabel: strings.tabataDecreaseRest,
                            increaseLabel: strings.tabataIncreaseRest,
                            canDecrease: _restSeconds > 0,
                            onDecrease: () => setState(
                              () => _restSeconds = (_restSeconds - 5)
                                  .clamp(0, 300)
                                  .toInt(),
                            ),
                            onIncrease: () => setState(
                              () => _restSeconds = (_restSeconds + 5)
                                  .clamp(0, 300)
                                  .toInt(),
                            ),
                          ),
                          const Divider(height: 12),
                          _TabataStepper(
                            keyName: 'tabata-rounds',
                            label: strings.tabataRounds,
                            value: _rounds,
                            unit: '',
                            decreaseLabel: strings.tabataDecreaseRounds,
                            increaseLabel: strings.tabataIncreaseRounds,
                            canDecrease: _rounds > 1,
                            onDecrease: () => setState(
                              () =>
                                  _rounds = (_rounds - 1).clamp(1, 30).toInt(),
                            ),
                            onIncrease: () => setState(
                              () =>
                                  _rounds = (_rounds + 1).clamp(1, 30).toInt(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.schedule_rounded,
                        color: colors.primary,
                      ),
                      title: Text(strings.tabataDuration),
                      trailing: Text(
                        _formatTime(plan.totalDurationSeconds),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strings.tabataHint,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    key: const ValueKey('tabata-start'),
                    onPressed: () => _start(strings),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(strings.tabataStart),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                        TempoTokens.touchTarget,
                      ),
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }
}

class _TabataStepper extends StatelessWidget {
  const _TabataStepper({
    required this.keyName,
    required this.label,
    required this.value,
    required this.unit,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.canDecrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String keyName;
  final String label;
  final int value;
  final String unit;
  final String decreaseLabel;
  final String increaseLabel;
  final bool canDecrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton.filledTonal(
          key: ValueKey('$keyName-decrement'),
          tooltip: decreaseLabel,
          onPressed: canDecrease ? onDecrease : null,
          constraints: const BoxConstraints.tightFor(
            width: TempoTokens.touchTarget,
            height: TempoTokens.touchTarget,
          ),
          icon: const Icon(Icons.remove_rounded),
        ),
        SizedBox(
          width: 86,
          child: Text(
            [value.toString(), if (unit.isNotEmpty) unit].join(' '),
            key: ValueKey('$keyName-value'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        IconButton.filledTonal(
          key: ValueKey('$keyName-increment'),
          tooltip: increaseLabel,
          onPressed: onIncrease,
          constraints: const BoxConstraints.tightFor(
            width: TempoTokens.touchTarget,
            height: TempoTokens.touchTarget,
          ),
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }
}

