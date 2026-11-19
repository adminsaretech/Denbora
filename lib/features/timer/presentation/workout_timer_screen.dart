import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/tempo_tokens.dart';
import '../../settings/data/settings_repository.dart';
import '../../workouts/domain/workout_plan.dart';
import '../application/timer_controller.dart';
import '../application/timer_providers.dart';
import '../domain/timer_phase.dart';
import '../domain/timer_snapshot.dart';

class WorkoutTimerScreen extends ConsumerStatefulWidget {
  const WorkoutTimerScreen({super.key, required this.plan});

  final WorkoutPlan plan;

  @override
  ConsumerState<WorkoutTimerScreen> createState() => _WorkoutTimerScreenState();
}

class _WorkoutTimerScreenState extends ConsumerState<WorkoutTimerScreen>
    with WidgetsBindingObserver {
  TimerController? _controller;
  String? _error;
  bool _wakeLockRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_start());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_wakeLockRequested) unawaited(WakelockPlus.disable());
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final controller = _controller;
      if (controller != null) unawaited(controller.onLifecycleResume());
    }
  }

  Future<void> _start() async {
    final controller = ref.read(timerControllerProvider);
    if (mounted) setState(() => _controller = controller);
    try {
      await controller.start(widget.plan);
    } on Object {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).timerStartError);
      }
    }
  }

  Future<void> _restart() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.restart();
    await controller.start(widget.plan);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final keepScreenOn = ref.watch(appSettingsProvider).keepScreenOn;
    _syncWakeLock(keepScreenOn);
    final controller = _controller;
    if (controller == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.plan.name)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.plan.name)),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final snapshot = controller.state;
            final phaseTitle = _phaseTitle(strings, snapshot.phase.kind);
            final remaining = snapshot.phaseRemaining;
            final shownSeconds = widget.plan.mode == WorkoutMode.stopwatch
                ? snapshot.elapsed.inSeconds
                : snapshot.isFinished || remaining == null
                ? 0
                : (remaining.inMicroseconds +
                          Duration.microsecondsPerSecond -
                          1) ~/
                      Duration.microsecondsPerSecond;
            final shownTime = _formatTime(shownSeconds);
            final phaseDuration = snapshot.phase.durationSeconds;
            final progress = phaseDuration <= 0 || remaining == null
                ? 0.0
                : (remaining.inMicroseconds /
                          (phaseDuration * Duration.microsecondsPerSecond))
                      .clamp(0.0, 1.0);

            return LayoutBuilder(
              builder: (context, constraints) {
                final ringSize = math
                    .min(
                      300.0,
                      math.min(
                        constraints.maxWidth - 48,
                        constraints.maxHeight * 0.38,
                      ),
                    )
                    .clamp(180.0, 300.0)
                    .toDouble();
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            phaseTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: _phaseColor(
                                    context,
                                    snapshot.phase.kind,
                                  ),
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          if (snapshot.phase.kind == TimerPhaseKind.work &&
                              snapshot.phase.label.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                snapshot.phase.label,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          if (widget.plan.mode == WorkoutMode.intervals &&
                              !snapshot.isFinished &&
                              snapshot.phase.kind !=
                                  TimerPhaseKind.preparation &&
                              snapshot.phase.kind !=
                                  TimerPhaseKind.cooldown) ...[
                            const SizedBox(height: 8),
                            Text(
                              strings.timerRoundLabel(
                                snapshot.phase.roundNumber,
                                widget.plan.rounds,
                              ),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (widget.plan.sets > 1)
                              Text(
                                strings.timerSetLabel(
                                  snapshot.phase.setNumber,
                                  widget.plan.sets,
                                ),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                          ],
                          const SizedBox(height: 24),
                          Center(
                            child: Semantics(
                              liveRegion: true,
                              label: '$phaseTitle, $shownTime',
                              child: ExcludeSemantics(
                                child: SizedBox.square(
                                  dimension: ringSize,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 12,
                                        strokeCap: StrokeCap.round,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainerHighest,
                                        valueColor: AlwaysStoppedAnimation(
                                          _phaseColor(
                                            context,
                                            snapshot.phase.kind,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Padding(
                                            padding: const EdgeInsets.all(28),
                                            child: Text(
                                              shownTime,
                                              key: const ValueKey('timer-time'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    fontFeatures: const [
                                                      FontFeature.tabularFigures(),
                                                    ],
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            strings.timerElapsedLabel(
                              _formatTime(snapshot.elapsed.inSeconds),
                            ),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (snapshot.isPaused)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                strings.timerPaused,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          if (snapshot.status == TimerStatus.completed)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                strings.timerCompleted,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                          const SizedBox(height: 28),
                          _buildControls(context, strings, snapshot),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _syncWakeLock(bool enabled) {
    if (_wakeLockRequested == enabled) return;
    _wakeLockRequested = enabled;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (enabled && mounted) {
        unawaited(WakelockPlus.enable());
      } else if (!enabled) {
        unawaited(WakelockPlus.disable());
      }
    });
  }

  Widget _buildControls(
    BuildContext context,
    AppLocalizations strings,
    TimerSnapshot snapshot,
  ) {
    final controller = _controller!;
    final fullWidthStyle = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(TempoTokens.touchTarget + 8),
    );
    if (snapshot.status == TimerStatus.idle) {
      return FilledButton.icon(
        key: const ValueKey('timer-start'),
        onPressed: () => controller.start(widget.plan),
        style: fullWidthStyle,
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(strings.timerStart),
      );
    }
    if (snapshot.status == TimerStatus.running) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            key: const ValueKey('timer-pause'),
            onPressed: controller.pause,
            style: fullWidthStyle,
            icon: const Icon(Icons.pause_rounded),
            label: Text(strings.timerPause),
          ),
          const SizedBox(height: 12),
          if (widget.plan.mode == WorkoutMode.stopwatch)
            OutlinedButton.icon(
              key: const ValueKey('timer-stop'),
              onPressed: controller.stop,
              style: fullWidthStyle,
              icon: const Icon(Icons.stop_rounded),
              label: Text(strings.timerStop),
            )
          else
            OutlinedButton.icon(
              key: const ValueKey('timer-skip'),
              onPressed: controller.skipPhase,
              style: fullWidthStyle,
              icon: const Icon(Icons.skip_next_rounded),
              label: Text(strings.timerSkip),
            ),
        ],
      );
    }
    if (snapshot.status == TimerStatus.paused) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            key: const ValueKey('timer-resume'),
            onPressed: controller.resume,
            style: fullWidthStyle,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(strings.timerResume),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            key: const ValueKey('timer-restart'),
            onPressed: _restart,
            style: fullWidthStyle,
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(strings.timerRestart),
          ),
        ],
      );
    }
    return FilledButton.icon(
      key: const ValueKey('timer-restart'),
      onPressed: _restart,
      style: fullWidthStyle,
      icon: const Icon(Icons.restart_alt_rounded),
      label: Text(strings.timerRestart),
    );
  }

  String _phaseTitle(AppLocalizations strings, TimerPhaseKind kind) =>
      switch (kind) {
        TimerPhaseKind.preparation => strings.timerPhasePreparation,
        TimerPhaseKind.work => strings.timerPhaseWork,
        TimerPhaseKind.rest => strings.timerPhaseRest,
        TimerPhaseKind.roundRest => strings.timerPhaseRoundRest,
        TimerPhaseKind.setRest => strings.timerPhaseSetRest,
        TimerPhaseKind.cooldown => strings.timerPhaseCooldown,
        TimerPhaseKind.stopwatch => strings.timerPhaseStopwatch,
        TimerPhaseKind.finished => strings.timerPhaseFinished,
      };

  Color _phaseColor(BuildContext context, TimerPhaseKind kind) {
    final colors = Theme.of(context).colorScheme;
    return switch (kind) {
      TimerPhaseKind.preparation => colors.secondary,
      TimerPhaseKind.work => colors.primary,
      TimerPhaseKind.rest ||
      TimerPhaseKind.roundRest ||
      TimerPhaseKind.setRest => TempoTokens.amber,
      TimerPhaseKind.cooldown => colors.tertiary,
      TimerPhaseKind.stopwatch => colors.primary,
      TimerPhaseKind.finished => colors.onSurfaceVariant,
    };
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainder = seconds % 60;
    final ss = remainder.toString().padLeft(2, '0');
    if (hours > 0) return '$hours:${minutes.toString().padLeft(2, '0')}:$ss';
    return '${seconds ~/ 60}:$ss';
  }
}
