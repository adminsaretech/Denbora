import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../domain/workout_session.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<WorkoutSession> _sessions = const [];
  List<DailySessionTotal> _week = const [];
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repository = ref.read(sessionRepositoryProvider);
      final sessions = await repository.list();
      final week = await repository.weeklySummary();
      if (!mounted) return;
      setState(() {
        _sessions = sessions;
        _week = week;
        _error = null;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.historyTitle)),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(strings.historyLoadError),
                ),
              )
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                  children: [
                    _weeklySection(context, strings),
                    const SizedBox(height: 24),
                    Text(
                      strings.historySessions,
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    if (_sessions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Text(
                          strings.historyEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    else
                      for (final session in _sessions)
                        _sessionCard(context, strings, session),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _weeklySection(BuildContext context, AppLocalizations strings) {
    final totalSeconds = _week.fold<int>(
      0,
      (total, day) => total + day.durationSeconds,
    );
    final totalSessions = _week.fold<int>(
      0,
      (total, day) => total + day.completedSessions,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    strings.historyWeekTitle,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              strings.historyWeekSummary(
                totalSessions,
                _formatDuration(strings, totalSeconds),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            _WeekChart(week: _week),
          ],
        ),
      ),
    );
  }

  Widget _sessionCard(
    BuildContext context,
    AppLocalizations strings,
    WorkoutSession session,
  ) {
    final localDate = session.startedAt.toLocal();
    final dateText = MaterialLocalizations.of(context)
        .formatShortDate(localDate);
    final timeText = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(localDate));
    final duration = _formatDuration(strings, session.durationSeconds);
    final detail = session.completedRounds == 0
        ? strings.historyStopwatchSummary(duration)
        : strings.historySessionSummary(duration, session.completedRounds);
    return Card(
      child: ListTile(
        minVerticalPadding: 14,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          child: const Icon(Icons.check_rounded),
        ),
        title: Text(
          session.workoutName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('$dateText · $timeText\n$detail'),
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatDuration(AppLocalizations strings, int seconds) {
    if (seconds < 60) return strings.durationSeconds(seconds);
    final minutes = seconds ~/ 60;
    final hours = minutes ~/ 60;
    if (hours == 0) return strings.durationMinutes(minutes);
    return strings.historyDurationHours(hours, minutes % 60);
  }
}

class _WeekChart extends StatelessWidget {
  const _WeekChart({required this.week});

  final List<DailySessionTotal> week;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final maxSeconds = week.fold<int>(
      0,
      (max, day) => day.durationSeconds > max ? day.durationSeconds : max,
    );
    final weekdays = MaterialLocalizations.of(context).narrowWeekdays;
    final color = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: strings.historyChartLabel(
        week.fold<int>(0, (sum, day) => sum + day.completedSessions),
        week.fold<int>(0, (sum, day) => sum + day.durationSeconds) ~/ 60,
      ),
      child: ExcludeSemantics(
        child: SizedBox(
          height: 136,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final day in week)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 24,
                              height:
                                  day.durationSeconds == 0 || maxSeconds == 0
                                  ? 4
                                  : 16 + 74 * day.durationSeconds / maxSeconds,
                              decoration: BoxDecoration(
                                color: day.completedSessions == 0
                                    ? Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest
                                    : color,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(weekdays[day.date.weekday % 7]),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
