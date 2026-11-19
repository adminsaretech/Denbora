import 'workout_plan.dart';

class WorkoutValidationError {
  const WorkoutValidationError({required this.code, required this.message});

  final String code;
  final String message;
}

class WorkoutValidationResult {
  WorkoutValidationResult(List<WorkoutValidationError> errors)
    : errors = List<WorkoutValidationError>.unmodifiable(errors);

  final List<WorkoutValidationError> errors;

  bool get isValid => errors.isEmpty;
}

class WorkoutValidation {
  WorkoutValidation._();

  static const maxNameLength = 40;
  static const maxDurationSeconds = 24 * 60 * 60;
  static const maxPhaseCount = 10000;

  static WorkoutValidationResult validate(WorkoutPlan plan) {
    final errors = <WorkoutValidationError>[];
    final trimmedName = plan.name.trim();

    if (trimmedName.isEmpty) {
      errors.add(
        const WorkoutValidationError(
          code: 'emptyName',
          message: 'Add a workout name.',
        ),
      );
    } else if (trimmedName.length > maxNameLength) {
      errors.add(
        const WorkoutValidationError(
          code: 'nameTooLong',
          message: 'Workout names can contain up to 40 characters.',
        ),
      );
    }

    if (plan.id.trim().isEmpty) {
      errors.add(
        const WorkoutValidationError(
          code: 'emptyId',
          message: 'Workout ID must not be empty.',
        ),
      );
    }

    if (plan.mode == WorkoutMode.stopwatch) {
      if (plan.blocks.isNotEmpty) {
        errors.add(
          const WorkoutValidationError(
            code: 'stopwatchHasBlocks',
            message: 'A stopwatch workout cannot contain interval blocks.',
          ),
        );
      }
      return WorkoutValidationResult(errors);
    }

    if (plan.blocks.isEmpty) {
      errors.add(
        const WorkoutValidationError(
          code: 'noBlocks',
          message: 'Add at least one work block.',
        ),
      );
    }

    if (plan.rounds < 1) {
      errors.add(
        const WorkoutValidationError(
          code: 'invalidRounds',
          message: 'Rounds must be at least one.',
        ),
      );
    }
    if (plan.sets < 1) {
      errors.add(
        const WorkoutValidationError(
          code: 'invalidSets',
          message: 'Sets must be at least one.',
        ),
      );
    }

    _addDurationError(
      errors,
      value: plan.preparationSeconds,
      code: 'invalidPreparation',
      label: 'Preparation',
      allowZero: true,
    );
    _addDurationError(
      errors,
      value: plan.restBetweenRoundsSeconds,
      code: 'invalidRoundRest',
      label: 'Round rest',
      allowZero: true,
    );
    _addDurationError(
      errors,
      value: plan.restBetweenSetsSeconds,
      code: 'invalidSetRest',
      label: 'Set rest',
      allowZero: true,
    );
    _addDurationError(
      errors,
      value: plan.cooldownSeconds,
      code: 'invalidCooldown',
      label: 'Cooldown',
      allowZero: true,
    );

    for (final block in plan.blocks) {
      _addDurationError(
        errors,
        value: block.workSeconds,
        code: 'invalidWork',
        label: 'Work duration for ${block.name}',
        allowZero: false,
      );
      _addDurationError(
        errors,
        value: block.restAfterSeconds,
        code: 'invalidRest',
        label: 'Rest duration for ${block.name}',
        allowZero: true,
      );
    }

    if (plan.rounds >= 1 && plan.sets >= 1 && plan.blocks.isNotEmpty) {
      final repeatedBlocks = plan.rounds * plan.sets * plan.blocks.length;
      final estimatedPhases = repeatedBlocks * 2 + plan.rounds * plan.sets + 2;
      if (estimatedPhases > maxPhaseCount) {
        errors.add(
          const WorkoutValidationError(
            code: 'tooManyPhases',
            message: 'This workout contains too many repeated intervals.',
          ),
        );
      }
    }

    return WorkoutValidationResult(errors);
  }

  static void _addDurationError(
    List<WorkoutValidationError> errors, {
    required int value,
    required String code,
    required String label,
    required bool allowZero,
  }) {
    final tooSmall = allowZero ? value < 0 : value < 1;
    if (tooSmall || value > maxDurationSeconds) {
      errors.add(
        WorkoutValidationError(
          code: code,
          message: '$label must be ${allowZero ? 'zero or' : ''} at most 24 hours.',
        ),
      );
    }
  }
}
