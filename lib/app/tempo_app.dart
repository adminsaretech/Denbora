import 'package:material_ui/material_ui.dart';

class TempoApp extends StatelessWidget {
  const TempoApp({super.key});

  static const _ink = Color(0xFF14201E);
  static const _ivory = Color(0xFFF6F4ED);
  static const _green = Color(0xFF145A50);
  static const _turquoise = Color(0xFF48C8B0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tempo: Workout Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _green,
          surface: _ivory,
        ),
        scaffoldBackgroundColor: _ivory,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _turquoise,
          brightness: Brightness.dark,
          surface: _ink,
        ),
        scaffoldBackgroundColor: _ink,
        useMaterial3: true,
      ),
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tempo')),
      body: Center(
        child: FilledButton(
          onPressed: () {},
          child: const Text('Entrenamientos'),
        ),
      ),
    );
  }
}
