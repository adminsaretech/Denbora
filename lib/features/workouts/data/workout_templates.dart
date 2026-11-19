import '../domain/workout_plan.dart';

class WorkoutTemplates {
  WorkoutTemplates._();

  static final List<WorkoutPlan> all = List<WorkoutPlan>.unmodifiable([
    WorkoutPlan(
      id: 'hiit-20-10',
      name: 'HIIT 20/10',
      blocks: const [
        WorkoutBlock(id: 'hiit-work', name: 'Trabajo', workSeconds: 20, restAfterSeconds: 10),
      ],
      rounds: 10,
      isBuiltIn: true,
    ),
    WorkoutPlan(
      id: 'tabata-20-10',
      name: 'Tabata 20/10',
      blocks: const [
        WorkoutBlock(id: 'tabata-work', name: 'Trabajo', workSeconds: 20, restAfterSeconds: 10),
      ],
      rounds: 8,
      isBuiltIn: true,
    ),
    WorkoutPlan(
      id: 'emom',
      name: 'EMOM',
      blocks: const [
        WorkoutBlock(id: 'emom-minute', name: 'Minuto', workSeconds: 60),
      ],
      rounds: 12,
      preparationSeconds: 5,
      isBuiltIn: true,
    ),
    WorkoutPlan(
      id: 'circuit',
      name: 'Circuito',
      blocks: const [
        WorkoutBlock(id: 'circuit-a', name: 'Bloque A', workSeconds: 40, restAfterSeconds: 20),
        WorkoutBlock(id: 'circuit-b', name: 'Bloque B', workSeconds: 40, restAfterSeconds: 20),
        WorkoutBlock(id: 'circuit-c', name: 'Bloque C', workSeconds: 40),
      ],
      rounds: 3,
      restBetweenRoundsSeconds: 60,
      isBuiltIn: true,
    ),
    WorkoutPlan(
      id: 'free-cardio',
      name: 'Cardio libre',
      mode: WorkoutMode.stopwatch,
      blocks: const [],
      preparationSeconds: 0,
      isBuiltIn: true,
    ),
    WorkoutPlan(
      id: 'stretching',
      name: 'Estiramientos',
      blocks: const [
        WorkoutBlock(id: 'stretch-a', name: 'Tramo A', workSeconds: 45, restAfterSeconds: 15),
        WorkoutBlock(id: 'stretch-b', name: 'Tramo B', workSeconds: 45, restAfterSeconds: 15),
        WorkoutBlock(id: 'stretch-c', name: 'Tramo C', workSeconds: 45, restAfterSeconds: 15),
        WorkoutBlock(id: 'stretch-d', name: 'Tramo D', workSeconds: 45, restAfterSeconds: 15),
        WorkoutBlock(id: 'stretch-e', name: 'Tramo E', workSeconds: 45),
      ],
      rounds: 1,
      cooldownSeconds: 60,
      isBuiltIn: true,
    ),
  ]);

  static WorkoutPlan byId(String id) {
    return all.firstWhere(
      (plan) => plan.id == id,
      orElse: () => throw ArgumentError.value(id, 'id', 'Unknown workout template.'),
    );
  }
}
