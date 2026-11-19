import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'app/tempo_app.dart';
import 'core/database/database_provider.dart';
import 'core/database/database_providers.dart';
import 'features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await DatabaseProvider.create();
  await database.initialize();
  final settingsRepository = SettingsRepository(
    SharedPreferencesSettingsStorage(),
  );
  final settings = await settingsRepository.load();

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        settingsRepositoryProvider.overrideWithValue(settingsRepository),
        initialAppSettingsProvider.overrideWithValue(settings),
      ],
      child: const TempoApp(),
    ),
  );
}
