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
  int _preparationSeconds = 5;
  int _workSeconds = 20;
  int _restSeconds = 10;
  int _roundsPerCycle = 8;
  int _cycles = 1;
  int _restBetweenCyclesSeconds = 0;
  int _cooldownSeconds = 0;

  WorkoutPlan _plan(String name) {
    final template = WorkoutTemplates.byId('tabata-20-10');
    return template.copyWith(
      name: name,
      preparationSeconds: _preparationSeconds,
      rounds: _roundsPerCycle,
      sets: _cycles,
      restBetweenSetsSeconds: _restBetweenCyclesSeconds,
      cooldownSeconds: _cooldownSeconds,
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
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                  const SizedBox(height: 16),
                  Text(
                    strings.tabataCycleSummary(_roundsPerCycle, _cycles),
                    key: const ValueKey('tabata-cycle-summary'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _TabataSectionTitle(
                            title: strings.tabataTimingSection,
                          ),
                          _TabataStepper(
                            keyName: 'tabata-preparation',
                            label: strings.tabataPreparation,
                            value: _preparationSeconds,
                            unit: 's',
                            decreaseLabel: strings.tabataDecreasePreparation,
                            increaseLabel: strings.tabataIncreasePreparation,
                            canDecrease: _preparationSeconds > 0,
                            onDecrease: () => _change(
                              () => _preparationSeconds =
                                  (_preparationSeconds - 5).clamp(0, 60),
                            ),
                            onIncrease: () => _change(
                              () => _preparationSeconds =
                                  (_preparationSeconds + 5).clamp(0, 60),
                            ),
                          ),
                          const Divider(height: 1),
                          _TabataStepper(
                            keyName: 'tabata-work',
                            label: strings.tabataWork,
                            value: _workSeconds,
                            unit: 's',
                            decreaseLabel: strings.tabataDecreaseWork,
                            increaseLabel: strings.tabataIncreaseWork,
                            canDecrease: _workSeconds > 5,
                            onDecrease: () => _change(
                              () => _workSeconds = (_workSeconds - 5).clamp(
                                5,
                                300,
                              ),
                            ),
                            onIncrease: () => _change(
                              () => _workSeconds = (_workSeconds + 5).clamp(
                                5,
                                300,
                              ),
                            ),
                          ),
                          const Divider(height: 1),
                          _TabataStepper(
                            keyName: 'tabata-rest',
                            label: strings.tabataRest,
                            value: _restSeconds,
                            unit: 's',
                            decreaseLabel: strings.tabataDecreaseRest,
                            increaseLabel: strings.tabataIncreaseRest,
                            canDecrease: _restSeconds > 0,
                            onDecrease: () => _change(
                              () => _restSeconds = (_restSeconds - 5).clamp(
                                0,
                                300,
                              ),
                            ),
                            onIncrease: () => _change(
                              () => _restSeconds = (_restSeconds + 5).clamp(
                                0,
                                300,
                              ),
                            ),
                          ),
                          _TabataSectionTitle(
                            title: strings.tabataCycleSection,
                          ),
                          _TabataStepper(
                            keyName: 'tabata-rounds',
                            label: strings.tabataRounds,
                            value: _roundsPerCycle,
                            unit: '',
                            decreaseLabel: strings.tabataDecreaseRounds,
                            increaseLabel: strings.tabataIncreaseRounds,
                            canDecrease: _roundsPerCycle > 1,
                            onDecrease: () => _change(
                              () => _roundsPerCycle = (_roundsPerCycle - 1)
                                  .clamp(1, 30),
                            ),
                            onIncrease: () => _change(
                              () => _roundsPerCycle = (_roundsPerCycle + 1)
                                  .clamp(1, 30),
                            ),
                          ),
                          const Divider(height: 1),
                          _TabataStepper(
                            keyName: 'tabata-cycles',
                            label: strings.tabataCycles,
                            value: _cycles,
                            unit: '',
                            decreaseLabel: strings.tabataDecreaseCycles,
                            increaseLabel: strings.tabataIncreaseCycles,
                            canDecrease: _cycles > 1,
                            onDecrease: () => _change(
                              () => _cycles = (_cycles - 1).clamp(1, 10),
                            ),
                            onIncrease: () => _change(
                              () => _cycles = (_cycles + 1).clamp(1, 10),
                            ),
                          ),
                          const Divider(height: 1),
                          _TabataStepper(
                            keyName: 'tabata-cycle-rest',
                            label: strings.tabataRestBetweenCycles,
                            value: _restBetweenCyclesSeconds,
                            unit: 's',
                            decreaseLabel: strings.tabataDecreaseCycleRest,
                            increaseLabel: strings.tabataIncreaseCycleRest,
                            canDecrease: _restBetweenCyclesSeconds > 0,
                            onDecrease: () => _change(
                              () => _restBetweenCyclesSeconds =
                                  (_restBetweenCyclesSeconds - 5).clamp(0, 600),
                            ),
                            onIncrease: () => _change(
                              () => _restBetweenCyclesSeconds =
                                  (_restBetweenCyclesSeconds + 5).clamp(0, 600),
                            ),
                          ),
                          _TabataSectionTitle(
                            title: strings.tabataFinishSection,
                          ),
                          _TabataStepper(
                            keyName: 'tabata-cooldown',
                            label: strings.tabataCooldown,
                            value: _cooldownSeconds,
                            unit: 's',
                            decreaseLabel: strings.tabataDecreaseCooldown,
                            increaseLabel: strings.tabataIncreaseCooldown,
                            canDecrease: _cooldownSeconds > 0,
                            onDecrease: () => _change(
                              () => _cooldownSeconds = (_cooldownSeconds - 5)
                                  .clamp(0, 600),
                            ),
                            onIncrease: () => _change(
                              () => _cooldownSeconds = (_cooldownSeconds + 5)
                                  .clamp(0, 600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    strings.tabataHint,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border(top: BorderSide(color: colors.outlineVariant)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(strings.tabataDuration)),
                        Text(
                          _formatTime(plan.totalDurationSeconds),
                          key: const ValueKey('tabata-duration-value'),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
      ),
    );
  }

  void _change(VoidCallback change) => setState(change);

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }
}

class _TabataSectionTitle extends StatelessWidget {
  const _TabataSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 4),
    child: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall
          ?.copyWith(fontWeight: FontWeight.w800),
    ),
  );
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            key: ValueKey('$keyName-decrement'),
            tooltip: decreaseLabel,
            onPressed: canDecrease ? onDecrease : null,
            constraints: const BoxConstraints.tightFor(
              width: TempoTokens.touchTarget,
              height: TempoTokens.touchTarget,
            ),
            style: IconButton.styleFrom(
              foregroundColor: colors.primary,
              shape: const CircleBorder(),
              side: BorderSide(color: colors.outlineVariant),
            ),
            icon: const Icon(Icons.remove_rounded),
          ),
          SizedBox(
            width: 84,
            child: Text(
              [value.toString(), if (unit.isNotEmpty) unit].join(' '),
              key: ValueKey('$keyName-value'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          IconButton(
            key: ValueKey('$keyName-increment'),
            tooltip: increaseLabel,
            onPressed: onIncrease,
            constraints: const BoxConstraints.tightFor(
              width: TempoTokens.touchTarget,
              height: TempoTokens.touchTarget,
            ),
            style: IconButton.styleFrom(
              foregroundColor: colors.primary,
              shape: const CircleBorder(),
              side: BorderSide(color: colors.outlineVariant),
            ),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
