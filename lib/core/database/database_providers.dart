import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/history/data/session_repository.dart';
import '../../features/timer/data/active_session_store.dart';
import '../../features/workouts/data/workout_repository.dart';
import 'database_provider.dart';

final databaseProvider = Provider<DatabaseProvider>(
  (ref) => throw StateError('DatabaseProvider must be initialized in main.'),
);

final workoutRepositoryProvider = Provider<WorkoutRepository>(
  (ref) => WorkoutRepository(ref.watch(databaseProvider).workouts),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(ref.watch(databaseProvider).sessions),
);

final activeSessionStoreProvider = Provider<ActiveSessionStore>(
  (ref) => HiveActiveSessionStore(ref.watch(databaseProvider).activeSession),
);
