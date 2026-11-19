import 'package:material_ui/material_ui.dart';

import '../core/localization/app_localizations.dart';
import '../features/workouts/presentation/workout_library_screen.dart';
import 'home/more_home_screen.dart';
import 'home/stopwatch_home_screen.dart';
import 'home/tabata_home_screen.dart';

class TempoHomeScreen extends StatefulWidget {
  const TempoHomeScreen({super.key});

  @override
  State<TempoHomeScreen> createState() => _TempoHomeScreenState();
}

class _TempoHomeScreenState extends State<TempoHomeScreen> {
  int _selectedIndex = 0;
  final Set<int> _visitedDestinations = {0};

  void _selectDestination(int index) {
    setState(() {
      _selectedIndex = index;
      _visitedDestinations.add(index);
    });
  }

  Widget _destination(int index) {
    if (!_visitedDestinations.contains(index)) return const SizedBox.shrink();
    return switch (index) {
      0 => const TabataHomeScreen(),
      1 => const WorkoutLibraryScreen(),
      2 => const StopwatchHomeScreen(),
      3 => const MoreHomeScreen(),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List<Widget>.generate(4, _destination),
      ),
      bottomNavigationBar: NavigationBar(
        key: const ValueKey('tempo-bottom-navigation'),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
        destinations: [
          NavigationDestination(
            key: const ValueKey('nav-tabata'),
            icon: const Icon(Icons.repeat_rounded),
            selectedIcon: const Icon(Icons.repeat_on_rounded),
            label: strings.navTabata,
          ),
          NavigationDestination(
            key: const ValueKey('nav-workouts'),
            icon: const Icon(Icons.fitness_center_outlined),
            selectedIcon: const Icon(Icons.fitness_center_rounded),
            label: strings.navWorkouts,
          ),
          NavigationDestination(
            key: const ValueKey('nav-stopwatch'),
            icon: const Icon(Icons.av_timer_outlined),
            selectedIcon: const Icon(Icons.av_timer_rounded),
            label: strings.navStopwatch,
          ),
          NavigationDestination(
            key: const ValueKey('nav-more'),
            icon: const Icon(Icons.more_horiz_rounded),
            selectedIcon: const Icon(Icons.more_horiz_rounded),
            label: strings.navMore,
          ),
        ],
      ),
    );
  }
}

