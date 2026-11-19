import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/database/database_providers.dart';
import '../../../core/localization/app_localizations.dart';
import '../domain/workout_plan.dart';
import '../domain/workout_validation.dart';

class WorkoutEditorScreen extends ConsumerStatefulWidget {
  const WorkoutEditorScreen({super.key, this.plan});

  final WorkoutPlan? plan;

  @override
  ConsumerState<WorkoutEditorScreen> createState() =>
      _WorkoutEditorScreenState();
}

class _WorkoutEditorScreenState extends ConsumerState<WorkoutEditorScreen> {
  late final TextEditingController _name;
  late final TextEditingController _preparation;
  late final TextEditingController _rounds;
  late final TextEditingController _sets;
  late final TextEditingController _roundRest;
  late final TextEditingController _setRest;
  late final TextEditingController _cooldown;
  late WorkoutMode _mode;
  late List<_BlockFields> _blocks;
  String? _error;
  bool _saving = false;
  int _newBlockNumber = 1;

  @override
  void initState() {
    super.initState();
    final plan = widget.plan;
    _name = TextEditingController(text: plan?.name ?? '');
    _preparation = TextEditingController(
      text: '${plan?.preparationSeconds ?? 5}',
    );
    _rounds = TextEditingController(text: '${plan?.rounds ?? 1}');
    _sets = TextEditingController(text: '${plan?.sets ?? 1}');
    _roundRest = TextEditingController(
      text: '${plan?.restBetweenRoundsSeconds ?? 0}',
    );
    _setRest = TextEditingController(
      text: '${plan?.restBetweenSetsSeconds ?? 0}',
    );
    _cooldown = TextEditingController(text: '${plan?.cooldownSeconds ?? 0}');
    _mode = plan?.mode ?? WorkoutMode.intervals;
    _blocks = plan == null || plan.mode == WorkoutMode.stopwatch
        ? [_BlockFields(id: 'block-0', name: '', work: '30', rest: '0')]
        : plan.blocks
              .map(
                (block) => _BlockFields(
                  id: block.id,
                  name: block.name,
                  work: '${block.workSeconds}',
                  rest: '${block.restAfterSeconds}',
                ),
              )
              .toList();
    _newBlockNumber = _blocks.length;
  }

  @override
  void dispose() {
    _name.dispose();
    _preparation.dispose();
    _rounds.dispose();
    _sets.dispose();
    _roundRest.dispose();
    _setRest.dispose();
    _cooldown.dispose();
    for (final block in _blocks) {
      block.dispose();
    }
    super.dispose();
  }

  void _addBlock() {
    setState(() {
      _blocks.add(
        _BlockFields(
          id: 'block-${_newBlockNumber++}',
          name: '',
          work: '30',
          rest: '0',
        ),
      );
      _error = null;
    });
  }

  void _removeBlock(int index) {
    setState(() {
      _blocks.removeAt(index).dispose();
      _error = null;
    });
  }

  Future<void> _save() async {
    final strings = AppLocalizations.of(context);
    final plan = WorkoutPlan(
      id: widget.plan?.id ?? ref.read(workoutRepositoryProvider).createId(),
      name: _name.text.trim(),
      mode: _mode,
      blocks: _mode == WorkoutMode.stopwatch
          ? const []
          : _blocks
                .map(
                  (block) => WorkoutBlock(
                    id: block.id,
                    name: block.name.text.trim(),
                    workSeconds: int.tryParse(block.work.text.trim()) ?? -1,
                    restAfterSeconds:
                        int.tryParse(block.rest.text.trim()) ?? -1,
                  ),
                )
                .toList(growable: false),
      preparationSeconds: int.tryParse(_preparation.text.trim()) ?? -1,
      rounds: int.tryParse(_rounds.text.trim()) ?? -1,
      sets: int.tryParse(_sets.text.trim()) ?? -1,
      restBetweenRoundsSeconds: int.tryParse(_roundRest.text.trim()) ?? -1,
      restBetweenSetsSeconds: int.tryParse(_setRest.text.trim()) ?? -1,
      cooldownSeconds: int.tryParse(_cooldown.text.trim()) ?? -1,
      createdAt: widget.plan?.createdAt,
      lastUsedAt: widget.plan?.lastUsedAt,
    );
    final validation = WorkoutValidation.validate(plan);
    if (!validation.isValid) {
      final code = validation.errors.first.code;
      setState(() {
        _error = switch (code) {
          'emptyName' => strings.workoutNameRequired,
          'noBlocks' => strings.workoutAtLeastOneBlock,
          _ => strings.workoutInvalidNumber,
        };
      });
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(workoutRepositoryProvider).save(plan);
      if (mounted) Navigator.of(context).pop(plan);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = strings.workoutInvalidNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.plan == null
              ? strings.workoutsCreateTitle
              : strings.workoutsEditTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const ValueKey('workout-name'),
                  controller: _name,
                  maxLength: WorkoutValidation.maxNameLength,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: strings.workoutName,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() => _error = null),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<WorkoutMode>(
                  key: const ValueKey('workout-mode'),
                  initialValue: _mode,
                  decoration: InputDecoration(
                    labelText: strings.workoutMode,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: WorkoutMode.intervals,
                      child: Text(strings.workoutIntervals),
                    ),
                    DropdownMenuItem(
                      value: WorkoutMode.stopwatch,
                      child: Text(strings.workoutStopwatch),
                    ),
                  ],
                  onChanged: (mode) {
                    if (mode != null) setState(() => _mode = mode);
                  },
                ),
                if (_mode == WorkoutMode.intervals) ...[
                  const SizedBox(height: 20),
                  _numberField(
                    keyName: 'workout-preparation',
                    controller: _preparation,
                    label: strings.workoutPreparation,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    strings.workoutBlocks,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  for (var index = 0; index < _blocks.length; index++)
                    _buildBlock(strings, index),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    key: const ValueKey('add-workout-block'),
                    onPressed: _addBlock,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(strings.workoutAddBlock),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _numberField(
                    keyName: 'workout-rounds',
                    controller: _rounds,
                    label: strings.workoutRounds,
                  ),
                  const SizedBox(height: 14),
                  _numberField(
                    keyName: 'workout-sets',
                    controller: _sets,
                    label: strings.workoutSets,
                  ),
                  const SizedBox(height: 14),
                  _numberField(
                    keyName: 'workout-round-rest',
                    controller: _roundRest,
                    label: strings.workoutRoundRest,
                  ),
                  const SizedBox(height: 14),
                  _numberField(
                    keyName: 'workout-set-rest',
                    controller: _setRest,
                    label: strings.workoutSetRest,
                  ),
                  const SizedBox(height: 14),
                  _numberField(
                    keyName: 'workout-cooldown',
                    controller: _cooldown,
                    label: strings.workoutCooldown,
                  ),
                ],
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  key: const ValueKey('save-workout'),
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(strings.workoutSave),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBlock(AppLocalizations strings, int index) {
    final fields = _blocks[index];
    return Card(
      key: ValueKey('workout-block-${fields.id}'),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: ValueKey('workout-block-name-${fields.id}'),
                    controller: fields.name,
                    decoration: InputDecoration(
                      labelText: strings.workoutBlockName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: strings.workoutRemoveBlock,
                  onPressed: () => _removeBlock(index),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _numberField(
                    keyName: 'workout-block-work-${fields.id}',
                    controller: fields.work,
                    label: strings.workoutWorkSeconds,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _numberField(
                    keyName: 'workout-block-rest-${fields.id}',
                    controller: fields.rest,
                    label: strings.workoutRestSeconds,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField({
    required String keyName,
    required TextEditingController controller,
    required String label,
  }) => TextField(
    key: ValueKey(keyName),
    controller: controller,
    keyboardType: const TextInputType.numberWithOptions(decimal: false),
    inputFormatters: const [],
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    onChanged: (_) => setState(() => _error = null),
  );
}

class _BlockFields {
  _BlockFields({
    required this.id,
    required String name,
    required String work,
    required String rest,
  }) : name = TextEditingController(text: name),
       work = TextEditingController(text: work),
       rest = TextEditingController(text: rest);

  final String id;
  final TextEditingController name;
  final TextEditingController work;
  final TextEditingController rest;

  void dispose() {
    name.dispose();
    work.dispose();
    rest.dispose();
  }
}
