import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../data/workout_repository.dart';
import '../domain/workout_plan.dart';
import 'workout_editor_screen.dart';
import '../../timer/presentation/workout_timer_screen.dart';

enum WorkoutSort { recent, name }

class WorkoutLibraryScreen extends ConsumerStatefulWidget {
  const WorkoutLibraryScreen({super.key});

  @override
  ConsumerState<WorkoutLibraryScreen> createState() =>
      _WorkoutLibraryScreenState();
}

class _WorkoutLibraryScreenState extends ConsumerState<WorkoutLibraryScreen> {
  final _searchController = TextEditingController();
  List<WorkoutPlan> _plans = const [];
  WorkoutSort _sort = WorkoutSort.recent;
  bool _loading = true;

  WorkoutRepository get _repository => ref.read(workoutRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final plans = _sort == WorkoutSort.name
        ? await _repository.sortByName()
        : await _repository.sortByUpdatedAt();
    if (!mounted) return;
    setState(() {
      _plans = plans;
      _loading = false;
    });
  }

  List<WorkoutPlan> get _visiblePlans {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _plans;
    return _plans
        .where((plan) => _displayName(plan).toLowerCase().contains(query))
        .toList(growable: false);
  }

  String _displayName(WorkoutPlan plan) {
    final strings = AppLocalizations.of(context);
    return switch (plan.id) {
      'circuit' => strings.workoutCircuit,
      'free-cardio' => strings.workoutFreeCardio,
      'stretching' => strings.workoutStretching,
      _ => plan.name,
    };
  }

  Future<void> _openEditor([WorkoutPlan? plan]) async {
    await Navigator.of(context).push<WorkoutPlan>(
      MaterialPageRoute(builder: (_) => WorkoutEditorScreen(plan: plan)),
    );
    await _reload();
  }

  Future<void> _duplicate(WorkoutPlan plan) async {
    final strings = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    await _repository.duplicate(
      plan.id,
      copySuffix: languageCode == 'es' ? '(copia)' : '(copy)',
    );
    await _reload();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.workoutDuplicated)));
    }
  }

  Future<void> _delete(WorkoutPlan plan) async {
    final strings = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.workoutsDeleteTitle),
        content: Text(strings.workoutsDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.workoutsCancel),
          ),
          FilledButton(
            key: const ValueKey('confirm-delete-workout'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.workoutsDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _repository.delete(plan.id);
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final visible = _visiblePlans;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.workoutsTitle),
        actions: [
          IconButton(
            key: const ValueKey('create-workout'),
            tooltip: strings.workoutsCreate,
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const ValueKey('workout-search'),
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_rounded),
                      hintText: strings.workoutsSearch,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton<WorkoutSort>(
                      key: const ValueKey('workout-sort'),
                      value: _sort,
                      underline: const SizedBox.shrink(),
                      items: [
                        DropdownMenuItem(
                          value: WorkoutSort.recent,
                          child: Text(strings.workoutsSortRecent),
                        ),
                        DropdownMenuItem(
                          value: WorkoutSort.name,
                          child: Text(strings.workoutsSortName),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _sort = value;
                          _loading = true;
                        });
                        _reload();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : visible.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          strings.workoutsEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: visible.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final plan = visible[index];
                        return _WorkoutTile(
                          key: ValueKey('workout-${plan.id}'),
                          plan: plan,
                          title: _displayName(plan),
                          summary: _summary(strings, plan),
                          onDuplicate: () => _duplicate(plan),
                          onStart: () => Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => WorkoutTimerScreen(plan: plan),
                            ),
                          ),
                          onEdit: plan.isBuiltIn
                              ? null
                              : () => _openEditor(plan),
                          onDelete: plan.isBuiltIn ? null : () => _delete(plan),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _summary(AppLocalizations strings, WorkoutPlan plan) {
    if (plan.mode == WorkoutMode.stopwatch) {
      return strings.workoutStopwatchSummary;
    }
    final seconds = plan.totalDurationSeconds;
    final duration = seconds < 60
        ? strings.durationSeconds(seconds)
        : strings.durationMinutes((seconds / 60).ceil());
    return strings.workoutIntervalSummary(
      plan.rounds,
      plan.sets,
      plan.blocks.length,
      duration,
    );
  }
}

class _WorkoutTile extends StatelessWidget {
  const _WorkoutTile({
    super.key,
    required this.plan,
    required this.title,
    required this.summary,
    required this.onDuplicate,
    required this.onStart,
    required this.onEdit,
    required this.onDelete,
  });

  final WorkoutPlan plan;
  final String title;
  final String summary;
  final VoidCallback onDuplicate;
  final VoidCallback onStart;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        minVerticalPadding: 14,
        onTap: onStart,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            plan.mode == WorkoutMode.stopwatch
                ? Icons.timer_outlined
                : Icons.bolt_rounded,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(summary),
              if (plan.isBuiltIn)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    strings.workoutBuiltIn,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: strings.workoutStart,
              onPressed: onStart,
              icon: const Icon(Icons.play_arrow_rounded),
            ),
            PopupMenuButton<String>(
              key: ValueKey('workout-menu-${plan.id}'),
              tooltip: strings.workoutActions,
              onSelected: (action) {
                switch (action) {
                  case 'duplicate':
                    onDuplicate();
                  case 'edit':
                    onEdit?.call();
                  case 'delete':
                    onDelete?.call();
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'duplicate',
                  child: Text(strings.workoutsDuplicate),
                ),
                if (onEdit != null)
                  PopupMenuItem(
                    value: 'edit',
                    child: Text(strings.workoutsEdit),
                  ),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(strings.workoutsDelete),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
