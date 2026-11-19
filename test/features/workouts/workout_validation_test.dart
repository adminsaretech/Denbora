import 'package:flutter_test/flutter_test.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_plan.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_validation.dart';

void main() {
  test('valid interval workout has no validation errors', () {
    final result = WorkoutValidation.validate(
      WorkoutPlan(
        id: 'valid',
        name: 'Intervals',
        blocks: const [WorkoutBlock(id: 'a', name: 'Work', workSeconds: 20)],
      ),
    );

    expect(result.isValid, isTrue);
    expect(result.errors, isEmpty);
  });

  test('empty name is rejected', () {
    final result = WorkoutValidation.validate(
      WorkoutPlan(
        id: 'empty-name',
        name: '  ',
        blocks: const [WorkoutBlock(id: 'a', name: 'Work', workSeconds: 20)],
      ),
    );

    expect(result.errors.map((error) => error.code), contains('emptyName'));
  });

  test('interval mode requires at least one block', () {
    final result = WorkoutValidation.validate(
      WorkoutPlan(id: 'empty', name: 'Empty', blocks: []),
    );

    expect(result.errors.map((error) => error.code), contains('noBlocks'));
  });

  test('work duration must be positive and rest duration non-negative', () {
    final result = WorkoutValidation.validate(
      WorkoutPlan(
        id: 'bad-times',
        name: 'Bad times',
        blocks: const [
          WorkoutBlock(
            id: 'a',
            name: 'Work',
            workSeconds: 0,
            restAfterSeconds: -1,
          ),
        ],
      ),
    );

    expect(result.errors.map((error) => error.code), contains('invalidWork'));
    expect(result.errors.map((error) => error.code), contains('invalidRest'));
  });

  test('rounds and sets must be positive', () {
    final result = WorkoutValidation.validate(
      WorkoutPlan(
        id: 'bad-counts',
        name: 'Bad counts',
        rounds: 0,
        sets: -1,
        blocks: const [WorkoutBlock(id: 'a', name: 'Work', workSeconds: 20)],
      ),
    );

    expect(result.errors.map((error) => error.code), contains('invalidRounds'));
    expect(result.errors.map((error) => error.code), contains('invalidSets'));
  });

  test('stopwatch mode allows an empty interval list', () {
    final result = WorkoutValidation.validate(
      WorkoutPlan(
        id: 'free',
        name: 'Cardio libre',
        mode: WorkoutMode.stopwatch,
        blocks: [],
        preparationSeconds: 0,
      ),
    );

    expect(result.isValid, isTrue);
  });
}
