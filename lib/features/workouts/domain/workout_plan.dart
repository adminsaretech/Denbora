enum WorkoutMode { intervals, stopwatch }

class WorkoutBlock {
  const WorkoutBlock({
    required this.id,
    required this.name,
    required this.workSeconds,
    this.restAfterSeconds = 0,
  });

  final String id;
  final String name;
  final int workSeconds;
  final int restAfterSeconds;

  WorkoutBlock copyWith({
    String? id,
    String? name,
    int? workSeconds,
    int? restAfterSeconds,
  }) {
    return WorkoutBlock(
      id: id ?? this.id,
      name: name ?? this.name,
      workSeconds: workSeconds ?? this.workSeconds,
      restAfterSeconds: restAfterSeconds ?? this.restAfterSeconds,
    );
  }
}

class WorkoutPlan {
  WorkoutPlan({
    required this.id,
    required this.name,
    required List<WorkoutBlock> blocks,
    this.mode = WorkoutMode.intervals,
    this.preparationSeconds = 5,
    this.rounds = 1,
    this.sets = 1,
    this.restBetweenRoundsSeconds = 0,
    this.restBetweenSetsSeconds = 0,
    this.cooldownSeconds = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastUsedAt,
    this.isBuiltIn = false,
  }) : blocks = List<WorkoutBlock>.unmodifiable(blocks),
       createdAt = (createdAt ?? DateTime.now()).toUtc(),
       updatedAt = (updatedAt ?? createdAt ?? DateTime.now()).toUtc();

  final String id;
  final String name;
  final WorkoutMode mode;
  final List<WorkoutBlock> blocks;
  final int preparationSeconds;
  final int rounds;
  final int sets;
  final int restBetweenRoundsSeconds;
  final int restBetweenSetsSeconds;
  final int cooldownSeconds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastUsedAt;
  final bool isBuiltIn;

  int get totalDurationSeconds {
    if (mode == WorkoutMode.stopwatch) return 0;

    final oneRoundSeconds = blocks.fold<int>(
      0,
      (total, block) => total + block.workSeconds + block.restAfterSeconds,
    );
    final allRoundsSeconds = rounds * oneRoundSeconds +
        (rounds - 1) * restBetweenRoundsSeconds;
    final allSetsSeconds = sets * allRoundsSeconds +
        (sets - 1) * restBetweenSetsSeconds;

    return preparationSeconds + allSetsSeconds + cooldownSeconds;
  }

  WorkoutPlan copyWith({
    String? id,
    String? name,
    WorkoutMode? mode,
    List<WorkoutBlock>? blocks,
    int? preparationSeconds,
    int? rounds,
    int? sets,
    int? restBetweenRoundsSeconds,
    int? restBetweenSetsSeconds,
    int? cooldownSeconds,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastUsedAt,
    bool clearLastUsedAt = false,
    bool? isBuiltIn,
  }) {
    return WorkoutPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      mode: mode ?? this.mode,
      blocks: blocks ?? this.blocks,
      preparationSeconds: preparationSeconds ?? this.preparationSeconds,
      rounds: rounds ?? this.rounds,
      sets: sets ?? this.sets,
      restBetweenRoundsSeconds:
          restBetweenRoundsSeconds ?? this.restBetweenRoundsSeconds,
      restBetweenSetsSeconds:
          restBetweenSetsSeconds ?? this.restBetweenSetsSeconds,
      cooldownSeconds: cooldownSeconds ?? this.cooldownSeconds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUsedAt: clearLastUsedAt ? null : lastUsedAt ?? this.lastUsedAt,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    );
  }
}
