import 'package:flutter_test/flutter_test.dart';
import 'package:tempo_workout_timer/features/workouts/data/workout_templates.dart';
import 'package:tempo_workout_timer/features/workouts/domain/workout_plan.dart';

void main() {
  test('contains six original presets', () {
    expect(WorkoutTemplates.all, hasLength(6));
    expect(
      WorkoutTemplates.all.map((plan) => plan.name),
      containsAll(<String>[
        'HIIT 20/10',
        'Tabata 20/10',
        'EMOM',
        'Circuito',
        'Cardio libre',
        'Estiramientos',
      ]),
    );
  });

  test('Tabata has eight twenty-second work blocks with ten-second rests', () {
    final tabata = WorkoutTemplates.byId('tabata-20-10');

    expect(tabata.mode, WorkoutMode.intervals);
    expect(tabata.rounds, 8);
    expect(tabata.blocks.single.workSeconds, 20);
    expect(tabata.blocks.single.restAfterSeconds, 10);
  });

  test('free cardio is an unbounded stopwatch preset', () {
    final cardio = WorkoutTemplates.byId('free-cardio');

    expect(cardio.mode, WorkoutMode.stopwatch);
    expect(cardio.blocks, isEmpty);
  });

  test('preset catalog and preset block lists are immutable', () {
    expect(() => WorkoutTemplates.all.clear(), throwsUnsupportedError);
    expect(
      () => WorkoutTemplates.byId('tabata-20-10').blocks.clear(),
      throwsUnsupportedError,
    );
  });
}
