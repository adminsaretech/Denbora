import 'package:material_ui/material_ui.dart';

import 'tempo_tokens.dart';

abstract final class AppTheme {
  static ThemeData get light => _make(
        brightness: Brightness.light,
        background: TempoTokens.ivory,
        surface: TempoTokens.lightSurface,
        primary: TempoTokens.mineralGreen,
        onPrimary: Colors.white,
        onBackground: TempoTokens.ink,
        onSurface: TempoTokens.ink,
      );

  static ThemeData get dark => _make(
        brightness: Brightness.dark,
        background: TempoTokens.ink,
        surface: TempoTokens.darkSurface,
        primary: TempoTokens.turquoise,
        onPrimary: TempoTokens.ink,
        onBackground: TempoTokens.ivory,
        onSurface: TempoTokens.ivory,
      );

  static ThemeData _make({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color primary,
    required Color onPrimary,
    required Color onBackground,
    required Color onSurface,
  }) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      secondary: brightness == Brightness.light
          ? TempoTokens.coral
          : TempoTokens.amber,
      onSecondary: brightness == Brightness.light
          ? Colors.white
          : TempoTokens.ink,
      error: brightness == Brightness.light
          ? TempoTokens.coral
          : TempoTokens.amber,
      onError: brightness == Brightness.light
          ? Colors.white
          : TempoTokens.ink,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: brightness == Brightness.light
          ? const Color(0xFFEAE8E1)
          : const Color(0xFF34413E),
      onSurfaceVariant: brightness == Brightness.light
          ? TempoTokens.mutedInk
          : TempoTokens.mutedIvory,
      outline: brightness == Brightness.light
          ? const Color(0xFF65726E)
          : const Color(0xFF899590),
      outlineVariant: brightness == Brightness.light
          ? const Color(0xFFBCC5C0)
          : const Color(0xFF4A5854),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: onBackground,
      onInverseSurface: background,
      inversePrimary: brightness == Brightness.light
          ? TempoTokens.turquoise
          : TempoTokens.mineralGreen,
      surfaceTint: primary,
    );
    final rounded = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Manrope',
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onBackground,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: rounded,
        margin: const EdgeInsets.only(bottom: TempoTokens.controlGap),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(TempoTokens.touchTarget),
          shape: rounded,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(TempoTokens.touchTarget),
          shape: rounded,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
