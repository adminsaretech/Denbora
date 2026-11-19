import 'dart:convert';
import 'dart:math';

import 'package:hive_ce/hive.dart';

import '../domain/workout_plan.dart';
import '../domain/workout_validation.dart';
import 'workout_templates.dart';

class WorkoutRepository {
  WorkoutRepository(
    this._box, {
    String Function()? createId,
    DateTime Function()? now,
  })  : _createId = createId ?? _randomId,
        _now = now ?? DateTime.now;

  final Box<String> _box;
  final String Function() _createId;
  final DateTime Function() _now;

  Future<List<WorkoutPlan>> list() async {
    final custom = _box.values.map(_decodePlan).toList()
      ..sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return List<WorkoutPlan>.unmodifiable([...WorkoutTemplates.all, ...custom]);
  }

  Future<WorkoutPlan?> getById(String id) async {
    final builtIn = _builtInById(id);
    if (builtIn != null) return builtIn;
    final json = _box.get(id);
    return json == null ? null : _decodePlan(json);
  }

  Future<void> save(WorkoutPlan plan) async {
    if (plan.isBuiltIn || _builtInById(plan.id) != null) {
      throw StateError('Built-in templates are read-only; duplicate first.');
    }
    final validation = WorkoutValidation.validate(plan);
    if (!validation.isValid) {
      throw ArgumentError.value(
        validation.errors.map((error) => error.code).toList(),
        'plan',
        'Workout plan is invalid.',
      );
    }
    final saved = plan.copyWith(
      isBuiltIn: false,
      updatedAt: _now().toUtc(),
    );
    await _box.put(saved.id, _encodePlan(saved));
  }

  Future<WorkoutPlan> duplicate(String id) async {
    final source = await getById(id);
    if (source == null) throw ArgumentError.value(id, 'id', 'Unknown workout.');
    final newId = _uniqueId();
    final copy = source.copyWith(
      id: newId,
      name: '${source.name} (copia)',
      createdAt: _now().toUtc(),
      updatedAt: _now().toUtc(),
      clearLastUsedAt: true,
      isBuiltIn: false,
    );
    await save(copy);
    return copy;
  }

  Future<void> delete(String id) async {
    if (_builtInById(id) != null) {
      throw StateError('Built-in templates cannot be deleted.');
    }
    await _box.delete(id);
  }

  Future<List<WorkoutPlan>> search(String query) async {
    final normalized = query.trim().toLowerCase();
    final plans = await list();
    if (normalized.isEmpty) return plans;
    return List<WorkoutPlan>.unmodifiable(
      plans.where((plan) => plan.name.toLowerCase().contains(normalized)),
    );
  }

  Future<List<WorkoutPlan>> sortByName() async {
    final plans = (await list()).toList();
    plans.sort((left, right) =>
        left.name.toLowerCase().compareTo(right.name.toLowerCase()));
    return List<WorkoutPlan>.unmodifiable(plans);
  }

  Future<List<WorkoutPlan>> sortByUpdatedAt() async {
    final plans = (await list()).toList();
    plans.sort((left, right) => right.updatedAt.compareTo(left.updatedAt));
    return List<WorkoutPlan>.unmodifiable(plans);
  }

  String _uniqueId() {
    final id = _createId();
    if (_builtInById(id) != null || _box.containsKey(id)) {
      throw StateError('The workout ID generator returned a duplicate ID.');
    }
    return id;
  }

  WorkoutPlan? _builtInById(String id) {
    for (final template in WorkoutTemplates.all) {
      if (template.id == id) return template;
    }
    return null;
  }

  static String _randomId() {
    final random = Random.secure();
    return List<int>.generate(16, (_) => random.nextInt(256))
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  static String _encodePlan(WorkoutPlan plan) => jsonEncode({
        'id': plan.id,
        'name': plan.name,
        'mode': plan.mode.name,
        'blocks': plan.blocks
            .map((block) => {
                  'id': block.id,
                  'name': block.name,
                  'workSeconds': block.workSeconds,
                  'restAfterSeconds': block.restAfterSeconds,
                })
            .toList(growable: false),
        'preparationSeconds': plan.preparationSeconds,
        'rounds': plan.rounds,
        'sets': plan.sets,
        'restBetweenRoundsSeconds': plan.restBetweenRoundsSeconds,
        'restBetweenSetsSeconds': plan.restBetweenSetsSeconds,
        'cooldownSeconds': plan.cooldownSeconds,
        'createdAt': plan.createdAt.toIso8601String(),
        'updatedAt': plan.updatedAt.toIso8601String(),
        'lastUsedAt': plan.lastUsedAt?.toIso8601String(),
        'isBuiltIn': false,
      });

  static WorkoutPlan _decodePlan(String value) {
    final json = jsonDecode(value) as Map<String, dynamic>;
    final blocks = (json['blocks'] as List<dynamic>)
        .map((value) {
          final block = value as Map<String, dynamic>;
          return WorkoutBlock(
            id: block['id'] as String,
            name: block['name'] as String,
            workSeconds: block['workSeconds'] as int,
            restAfterSeconds: block['restAfterSeconds'] as int,
          );
        })
        .toList(growable: false);
    return WorkoutPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      mode: WorkoutMode.values.byName(json['mode'] as String),
      blocks: blocks,
      preparationSeconds: json['preparationSeconds'] as int,
      rounds: json['rounds'] as int,
      sets: json['sets'] as int,
      restBetweenRoundsSeconds: json['restBetweenRoundsSeconds'] as int,
      restBetweenSetsSeconds: json['restBetweenSetsSeconds'] as int,
      cooldownSeconds: json['cooldownSeconds'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastUsedAt: (json['lastUsedAt'] as String?) == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      isBuiltIn: false,
    );
  }
}
