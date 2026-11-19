// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tempo: temporizador de entrenamiento';

  @override
  String get brandName => 'Tempo';

  @override
  String get homeTitle => 'Entrenamientos';

  @override
  String get homeTagline => 'Tu sesión, a tu ritmo.';

  @override
  String get homeSettings => 'Ajustes';

  @override
  String get homeHistory => 'Historial';

  @override
  String get onboardingTitle => 'Tu ritmo, a tu manera';

  @override
  String get onboardingLead =>
      'Un temporizador claro para intervalos, rondas y descansos.';

  @override
  String get onboardingOffline => 'Sin cuenta y sin conexión';

  @override
  String get onboardingOfflineDetail =>
      'Tus entrenamientos se quedan en este dispositivo.';

  @override
  String get onboardingPersonalize => 'Rutinas a tu medida';

  @override
  String get onboardingPersonalizeDetail =>
      'Crea intervalos o parte de una plantilla original.';

  @override
  String get onboardingCues => 'Avisos a tu gusto';

  @override
  String get onboardingCuesDetail =>
      'Combina sonido, voz y vibración cuando quieras.';

  @override
  String get onboardingSkip => 'Ahora no';

  @override
  String get onboardingContinue => 'Empezar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageSystem => 'Sistema';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageEnglish => 'Inglés';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsThemeSystem => 'Automático';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsUnits => 'Unidades';

  @override
  String get settingsCues => 'Avisos';

  @override
  String get settingsUnitsMetric => 'Métricas';

  @override
  String get settingsUnitsImperial => 'Imperiales';

  @override
  String get settingsSound => 'Avisos sonoros';

  @override
  String get settingsVoice => 'Avisos de voz';

  @override
  String get settingsHaptics => 'Vibración';

  @override
  String get settingsKeepScreenOn => 'Mantener pantalla encendida';

  @override
  String get settingsBackgroundCues => 'Avisos con pantalla apagada';

  @override
  String get settingsBackgroundCuesNote =>
      'Aún no disponible. El tiempo se actualiza al volver a la app, pero no hay avisos mientras está suspendida.';

  @override
  String get settingsPrivacy => 'Sin cuenta, anuncios ni compras.';

  @override
  String get workoutsTitle => 'Entrenamientos';

  @override
  String get workoutsSearch => 'Buscar entrenamiento';

  @override
  String get workoutsCreate => 'Crear entrenamiento';

  @override
  String get workoutsEmpty => 'No hay entrenamientos con ese nombre.';

  @override
  String get workoutsSortName => 'Nombre';

  @override
  String get workoutsSortRecent => 'Actualizados';

  @override
  String get workoutsDuplicate => 'Duplicar';

  @override
  String get workoutsEdit => 'Editar';

  @override
  String get workoutsDelete => 'Eliminar';

  @override
  String get workoutsCancel => 'Cancelar';

  @override
  String get workoutsDeleteTitle => 'Eliminar entrenamiento';

  @override
  String get workoutsDeleteMessage =>
      'Se eliminará este entrenamiento. Las sesiones guardadas en el historial se conservan.';

  @override
  String get workoutsCreateTitle => 'Nuevo entrenamiento';

  @override
  String get workoutsEditTitle => 'Editar entrenamiento';

  @override
  String get workoutName => 'Nombre';

  @override
  String get workoutMode => 'Tipo de temporizador';

  @override
  String get workoutIntervals => 'Intervalos';

  @override
  String get workoutStopwatch => 'Cronómetro';

  @override
  String get workoutPreparation => 'Cuenta atrás inicial (s)';

  @override
  String get workoutBlocks => 'Bloques';

  @override
  String get workoutAddBlock => 'Añadir bloque';

  @override
  String get workoutBlockName => 'Nombre del bloque';

  @override
  String get workoutWorkSeconds => 'Trabajo (s)';

  @override
  String get workoutRestSeconds => 'Descanso (s)';

  @override
  String get workoutRounds => 'Rondas';

  @override
  String get workoutSets => 'Series';

  @override
  String get workoutRoundRest => 'Descanso entre rondas (s)';

  @override
  String get workoutSetRest => 'Descanso entre series (s)';

  @override
  String get workoutCooldown => 'Vuelta a la calma (s)';

  @override
  String get workoutSave => 'Guardar entrenamiento';

  @override
  String get workoutNameRequired => 'Escribe un nombre para el entrenamiento.';

  @override
  String get workoutAtLeastOneBlock => 'Añade al menos un bloque de trabajo.';

  @override
  String get workoutInvalidNumber =>
      'Revisa los tiempos y cantidades indicados.';

  @override
  String workoutIntervalSummary(
    int rounds,
    int sets,
    int blocks,
    String duration,
  ) {
    return '$rounds rondas · $sets series · $blocks bloques · $duration';
  }

  @override
  String get workoutStopwatchSummary => 'Cronómetro libre';

  @override
  String get workoutBuiltIn => 'Plantilla';

  @override
  String get workoutStart => 'Iniciar entrenamiento';

  @override
  String get timerStart => 'Empezar';

  @override
  String get timerPause => 'Pausar';

  @override
  String get timerResume => 'Reanudar';

  @override
  String get timerRestart => 'Reiniciar desde el principio';

  @override
  String get timerSkip => 'Saltar fase';

  @override
  String get timerStop => 'Terminar sesión';

  @override
  String get timerPaused => 'En pausa';

  @override
  String get timerCompleted => '¡Sesión completada!';

  @override
  String get timerStartError =>
      'No se pudo iniciar el reloj del dispositivo. Inténtalo de nuevo.';

  @override
  String get timerPhasePreparation => 'Preparación';

  @override
  String get timerPhaseWork => 'Trabajo';

  @override
  String get timerPhaseRest => 'Descanso';

  @override
  String get timerPhaseRoundRest => 'Descanso entre rondas';

  @override
  String get timerPhaseSetRest => 'Descanso entre series';

  @override
  String get timerPhaseCooldown => 'Vuelta a la calma';

  @override
  String get timerPhaseStopwatch => 'Cronómetro';

  @override
  String get timerPhaseFinished => 'Terminado';

  @override
  String timerRoundLabel(int current, int total) {
    return 'Ronda $current de $total';
  }

  @override
  String timerSetLabel(int current, int total) {
    return 'Serie $current de $total';
  }

  @override
  String timerElapsedLabel(String time) {
    return 'Tiempo transcurrido: $time';
  }

  @override
  String get historyTitle => 'Historial';

  @override
  String get historyLoadError => 'No se pudo cargar el historial.';

  @override
  String get historySessions => 'Sesiones';

  @override
  String get historyEmpty =>
      'Completa tu primer entrenamiento para ver aquí el historial.';

  @override
  String get historyWeekTitle => 'Últimos 7 días';

  @override
  String historyWeekSummary(int count, String duration) {
    return '$count sesiones · $duration';
  }

  @override
  String historyChartLabel(int count, int minutes) {
    return 'En los últimos 7 días: $count sesiones y $minutes minutos de actividad.';
  }

  @override
  String historySessionSummary(String duration, int rounds) {
    return '$duration · $rounds rondas completadas';
  }

  @override
  String historyStopwatchSummary(String duration) {
    return '$duration · cronómetro libre';
  }

  @override
  String historyDurationHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get workoutCircuit => 'Circuito';

  @override
  String get workoutFreeCardio => 'Cardio libre';

  @override
  String get workoutStretching => 'Estiramientos';

  @override
  String get workoutActions => 'Acciones del entrenamiento';

  @override
  String get workoutDuplicated => 'Entrenamiento duplicado.';

  @override
  String get workoutRemoveBlock => 'Quitar bloque';

  @override
  String durationSeconds(int value) {
    return '$value s';
  }

  @override
  String durationMinutes(int value) {
    return '$value min';
  }

  @override
  String get back => 'Volver';

  @override
  String get close => 'Cerrar';
}
