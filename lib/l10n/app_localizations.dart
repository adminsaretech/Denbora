import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Tempo: temporizador de entrenamiento'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In es, this message translates to:
  /// **'Tempo'**
  String get brandName;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Entrenamientos'**
  String get homeTitle;

  /// No description provided for @homeTagline.
  ///
  /// In es, this message translates to:
  /// **'Tu sesión, a tu ritmo.'**
  String get homeTagline;

  /// No description provided for @homeSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get homeSettings;

  /// No description provided for @homeHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get homeHistory;

  /// No description provided for @navTabata.
  ///
  /// In es, this message translates to:
  /// **'Tabata'**
  String get navTabata;

  /// No description provided for @navWorkouts.
  ///
  /// In es, this message translates to:
  /// **'Rutinas'**
  String get navWorkouts;

  /// No description provided for @navStopwatch.
  ///
  /// In es, this message translates to:
  /// **'Cronómetro'**
  String get navStopwatch;

  /// No description provided for @navMore.
  ///
  /// In es, this message translates to:
  /// **'Más'**
  String get navMore;

  /// No description provided for @tabataQuickIntro.
  ///
  /// In es, this message translates to:
  /// **'Define los intervalos y las pausas entre ciclos.'**
  String get tabataQuickIntro;

  /// No description provided for @tabataTimingSection.
  ///
  /// In es, this message translates to:
  /// **'Intervalos'**
  String get tabataTimingSection;

  /// No description provided for @tabataCycleSection.
  ///
  /// In es, this message translates to:
  /// **'Ciclos'**
  String get tabataCycleSection;

  /// No description provided for @tabataFinishSection.
  ///
  /// In es, this message translates to:
  /// **'Cierre'**
  String get tabataFinishSection;

  /// No description provided for @tabataPreparation.
  ///
  /// In es, this message translates to:
  /// **'Preparación'**
  String get tabataPreparation;

  /// No description provided for @tabataWork.
  ///
  /// In es, this message translates to:
  /// **'Trabajo'**
  String get tabataWork;

  /// No description provided for @tabataRest.
  ///
  /// In es, this message translates to:
  /// **'Descanso tras cada ronda'**
  String get tabataRest;

  /// No description provided for @tabataRounds.
  ///
  /// In es, this message translates to:
  /// **'Rondas por ciclo'**
  String get tabataRounds;

  /// No description provided for @tabataCycles.
  ///
  /// In es, this message translates to:
  /// **'Ciclos'**
  String get tabataCycles;

  /// No description provided for @tabataRestBetweenCycles.
  ///
  /// In es, this message translates to:
  /// **'Descanso entre ciclos'**
  String get tabataRestBetweenCycles;

  /// No description provided for @tabataCooldown.
  ///
  /// In es, this message translates to:
  /// **'Enfriamiento'**
  String get tabataCooldown;

  /// No description provided for @tabataCycleSummary.
  ///
  /// In es, this message translates to:
  /// **'{rounds} rondas por ciclo · {cycles} ciclos'**
  String tabataCycleSummary(int rounds, int cycles);

  /// No description provided for @tabataDuration.
  ///
  /// In es, this message translates to:
  /// **'Duración aproximada'**
  String get tabataDuration;

  /// No description provided for @tabataStart.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Tabata'**
  String get tabataStart;

  /// No description provided for @tabataHint.
  ///
  /// In es, this message translates to:
  /// **'Los ajustes solo se aplican a esta sesión; crea una rutina para guardarlos.'**
  String get tabataHint;

  /// No description provided for @tabataDecreasePreparation.
  ///
  /// In es, this message translates to:
  /// **'Reducir segundos de preparación'**
  String get tabataDecreasePreparation;

  /// No description provided for @tabataIncreasePreparation.
  ///
  /// In es, this message translates to:
  /// **'Aumentar segundos de preparación'**
  String get tabataIncreasePreparation;

  /// No description provided for @tabataDecreaseWork.
  ///
  /// In es, this message translates to:
  /// **'Reducir segundos de trabajo'**
  String get tabataDecreaseWork;

  /// No description provided for @tabataIncreaseWork.
  ///
  /// In es, this message translates to:
  /// **'Aumentar segundos de trabajo'**
  String get tabataIncreaseWork;

  /// No description provided for @tabataDecreaseRest.
  ///
  /// In es, this message translates to:
  /// **'Reducir segundos de descanso'**
  String get tabataDecreaseRest;

  /// No description provided for @tabataIncreaseRest.
  ///
  /// In es, this message translates to:
  /// **'Aumentar segundos de descanso'**
  String get tabataIncreaseRest;

  /// No description provided for @tabataDecreaseRounds.
  ///
  /// In es, this message translates to:
  /// **'Reducir rondas por ciclo'**
  String get tabataDecreaseRounds;

  /// No description provided for @tabataIncreaseRounds.
  ///
  /// In es, this message translates to:
  /// **'Aumentar rondas por ciclo'**
  String get tabataIncreaseRounds;

  /// No description provided for @tabataDecreaseCycles.
  ///
  /// In es, this message translates to:
  /// **'Reducir ciclos'**
  String get tabataDecreaseCycles;

  /// No description provided for @tabataIncreaseCycles.
  ///
  /// In es, this message translates to:
  /// **'Aumentar ciclos'**
  String get tabataIncreaseCycles;

  /// No description provided for @tabataDecreaseCycleRest.
  ///
  /// In es, this message translates to:
  /// **'Reducir descanso entre ciclos'**
  String get tabataDecreaseCycleRest;

  /// No description provided for @tabataIncreaseCycleRest.
  ///
  /// In es, this message translates to:
  /// **'Aumentar descanso entre ciclos'**
  String get tabataIncreaseCycleRest;

  /// No description provided for @tabataDecreaseCooldown.
  ///
  /// In es, this message translates to:
  /// **'Reducir enfriamiento'**
  String get tabataDecreaseCooldown;

  /// No description provided for @tabataIncreaseCooldown.
  ///
  /// In es, this message translates to:
  /// **'Aumentar enfriamiento'**
  String get tabataIncreaseCooldown;

  /// No description provided for @stopwatchIntro.
  ///
  /// In es, this message translates to:
  /// **'Cronometra una sesión libre, sin intervalos.'**
  String get stopwatchIntro;

  /// No description provided for @stopwatchReady.
  ///
  /// In es, this message translates to:
  /// **'Listo para empezar'**
  String get stopwatchReady;

  /// No description provided for @stopwatchStart.
  ///
  /// In es, this message translates to:
  /// **'Iniciar cronómetro'**
  String get stopwatchStart;

  /// No description provided for @stopwatchHint.
  ///
  /// In es, this message translates to:
  /// **'La sesión queda registrada en tu historial al terminar.'**
  String get stopwatchHint;

  /// No description provided for @moreTitle.
  ///
  /// In es, this message translates to:
  /// **'Más'**
  String get moreTitle;

  /// No description provided for @moreLead.
  ///
  /// In es, this message translates to:
  /// **'Tu progreso y tus preferencias, en un solo lugar.'**
  String get moreLead;

  /// No description provided for @moreActivitySection.
  ///
  /// In es, this message translates to:
  /// **'Actividad'**
  String get moreActivitySection;

  /// No description provided for @morePreferencesSection.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get morePreferencesSection;

  /// No description provided for @moreHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de sesiones'**
  String get moreHistory;

  /// No description provided for @moreSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes de Tempo'**
  String get moreSettings;

  /// No description provided for @morePrivacy.
  ///
  /// In es, this message translates to:
  /// **'Sin cuenta, anuncios ni compras. Tu actividad se guarda en este dispositivo.'**
  String get morePrivacy;

  /// No description provided for @onboardingTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu ritmo, a tu manera'**
  String get onboardingTitle;

  /// No description provided for @onboardingLead.
  ///
  /// In es, this message translates to:
  /// **'Un temporizador claro para intervalos, rondas y descansos.'**
  String get onboardingLead;

  /// No description provided for @onboardingOffline.
  ///
  /// In es, this message translates to:
  /// **'Sin cuenta y sin conexión'**
  String get onboardingOffline;

  /// No description provided for @onboardingOfflineDetail.
  ///
  /// In es, this message translates to:
  /// **'Tus entrenamientos se quedan en este dispositivo.'**
  String get onboardingOfflineDetail;

  /// No description provided for @onboardingPersonalize.
  ///
  /// In es, this message translates to:
  /// **'Rutinas a tu medida'**
  String get onboardingPersonalize;

  /// No description provided for @onboardingPersonalizeDetail.
  ///
  /// In es, this message translates to:
  /// **'Crea intervalos o parte de una plantilla original.'**
  String get onboardingPersonalizeDetail;

  /// No description provided for @onboardingCues.
  ///
  /// In es, this message translates to:
  /// **'Avisos a tu gusto'**
  String get onboardingCues;

  /// No description provided for @onboardingCuesDetail.
  ///
  /// In es, this message translates to:
  /// **'Combina sonido, voz y vibración cuando quieras.'**
  String get onboardingCuesDetail;

  /// No description provided for @onboardingSkip.
  ///
  /// In es, this message translates to:
  /// **'Ahora no'**
  String get onboardingSkip;

  /// No description provided for @onboardingContinue.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get onboardingContinue;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In es, this message translates to:
  /// **'Sistema'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsAppearance.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get settingsAppearance;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In es, this message translates to:
  /// **'Automático'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get settingsThemeDark;

  /// No description provided for @settingsUnits.
  ///
  /// In es, this message translates to:
  /// **'Unidades'**
  String get settingsUnits;

  /// No description provided for @settingsCues.
  ///
  /// In es, this message translates to:
  /// **'Avisos'**
  String get settingsCues;

  /// No description provided for @settingsUnitsMetric.
  ///
  /// In es, this message translates to:
  /// **'Métricas'**
  String get settingsUnitsMetric;

  /// No description provided for @settingsUnitsImperial.
  ///
  /// In es, this message translates to:
  /// **'Imperiales'**
  String get settingsUnitsImperial;

  /// No description provided for @settingsSound.
  ///
  /// In es, this message translates to:
  /// **'Avisos sonoros'**
  String get settingsSound;

  /// No description provided for @settingsVoice.
  ///
  /// In es, this message translates to:
  /// **'Avisos de voz'**
  String get settingsVoice;

  /// No description provided for @settingsHaptics.
  ///
  /// In es, this message translates to:
  /// **'Vibración'**
  String get settingsHaptics;

  /// No description provided for @settingsKeepScreenOn.
  ///
  /// In es, this message translates to:
  /// **'Mantener pantalla encendida'**
  String get settingsKeepScreenOn;

  /// No description provided for @settingsBackgroundCues.
  ///
  /// In es, this message translates to:
  /// **'Avisos con pantalla apagada'**
  String get settingsBackgroundCues;

  /// No description provided for @settingsBackgroundCuesNote.
  ///
  /// In es, this message translates to:
  /// **'Aún no disponible. El tiempo se actualiza al volver a la app, pero no hay avisos mientras está suspendida.'**
  String get settingsBackgroundCuesNote;

  /// No description provided for @settingsPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Sin cuenta, anuncios ni compras.'**
  String get settingsPrivacy;

  /// No description provided for @workoutsTitle.
  ///
  /// In es, this message translates to:
  /// **'Rutinas'**
  String get workoutsTitle;

  /// No description provided for @workoutsSearch.
  ///
  /// In es, this message translates to:
  /// **'Buscar entrenamiento'**
  String get workoutsSearch;

  /// No description provided for @workoutsCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear entrenamiento'**
  String get workoutsCreate;

  /// No description provided for @workoutsEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay entrenamientos con ese nombre.'**
  String get workoutsEmpty;

  /// No description provided for @workoutsSortName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get workoutsSortName;

  /// No description provided for @workoutsSortRecent.
  ///
  /// In es, this message translates to:
  /// **'Actualizados'**
  String get workoutsSortRecent;

  /// No description provided for @workoutsDuplicate.
  ///
  /// In es, this message translates to:
  /// **'Duplicar'**
  String get workoutsDuplicate;

  /// No description provided for @workoutsEdit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get workoutsEdit;

  /// No description provided for @workoutsDelete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get workoutsDelete;

  /// No description provided for @workoutsCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get workoutsCancel;

  /// No description provided for @workoutsDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar entrenamiento'**
  String get workoutsDeleteTitle;

  /// No description provided for @workoutsDeleteMessage.
  ///
  /// In es, this message translates to:
  /// **'Se eliminará este entrenamiento. Las sesiones guardadas en el historial se conservan.'**
  String get workoutsDeleteMessage;

  /// No description provided for @workoutsCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo entrenamiento'**
  String get workoutsCreateTitle;

  /// No description provided for @workoutsEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar entrenamiento'**
  String get workoutsEditTitle;

  /// No description provided for @workoutName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get workoutName;

  /// No description provided for @workoutMode.
  ///
  /// In es, this message translates to:
  /// **'Tipo de temporizador'**
  String get workoutMode;

  /// No description provided for @workoutIntervals.
  ///
  /// In es, this message translates to:
  /// **'Intervalos'**
  String get workoutIntervals;

  /// No description provided for @workoutStopwatch.
  ///
  /// In es, this message translates to:
  /// **'Cronómetro'**
  String get workoutStopwatch;

  /// No description provided for @workoutPreparation.
  ///
  /// In es, this message translates to:
  /// **'Cuenta atrás inicial (s)'**
  String get workoutPreparation;

  /// No description provided for @workoutBlocks.
  ///
  /// In es, this message translates to:
  /// **'Bloques'**
  String get workoutBlocks;

  /// No description provided for @workoutAddBlock.
  ///
  /// In es, this message translates to:
  /// **'Añadir bloque'**
  String get workoutAddBlock;

  /// No description provided for @workoutBlockName.
  ///
  /// In es, this message translates to:
  /// **'Nombre del bloque'**
  String get workoutBlockName;

  /// No description provided for @workoutWorkSeconds.
  ///
  /// In es, this message translates to:
  /// **'Trabajo (s)'**
  String get workoutWorkSeconds;

  /// No description provided for @workoutRestSeconds.
  ///
  /// In es, this message translates to:
  /// **'Descanso (s)'**
  String get workoutRestSeconds;

  /// No description provided for @workoutRounds.
  ///
  /// In es, this message translates to:
  /// **'Rondas'**
  String get workoutRounds;

  /// No description provided for @workoutSets.
  ///
  /// In es, this message translates to:
  /// **'Series'**
  String get workoutSets;

  /// No description provided for @workoutRoundRest.
  ///
  /// In es, this message translates to:
  /// **'Descanso entre rondas (s)'**
  String get workoutRoundRest;

  /// No description provided for @workoutSetRest.
  ///
  /// In es, this message translates to:
  /// **'Descanso entre series (s)'**
  String get workoutSetRest;

  /// No description provided for @workoutCooldown.
  ///
  /// In es, this message translates to:
  /// **'Vuelta a la calma (s)'**
  String get workoutCooldown;

  /// No description provided for @workoutSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar entrenamiento'**
  String get workoutSave;

  /// No description provided for @workoutNameRequired.
  ///
  /// In es, this message translates to:
  /// **'Escribe un nombre para el entrenamiento.'**
  String get workoutNameRequired;

  /// No description provided for @workoutAtLeastOneBlock.
  ///
  /// In es, this message translates to:
  /// **'Añade al menos un bloque de trabajo.'**
  String get workoutAtLeastOneBlock;

  /// No description provided for @workoutInvalidNumber.
  ///
  /// In es, this message translates to:
  /// **'Revisa los tiempos y cantidades indicados.'**
  String get workoutInvalidNumber;

  /// No description provided for @workoutIntervalSummary.
  ///
  /// In es, this message translates to:
  /// **'{rounds} rondas · {sets} series · {blocks} bloques · {duration}'**
  String workoutIntervalSummary(
    int rounds,
    int sets,
    int blocks,
    String duration,
  );

  /// No description provided for @workoutStopwatchSummary.
  ///
  /// In es, this message translates to:
  /// **'Cronómetro libre'**
  String get workoutStopwatchSummary;

  /// No description provided for @workoutBuiltIn.
  ///
  /// In es, this message translates to:
  /// **'Plantilla'**
  String get workoutBuiltIn;

  /// No description provided for @workoutStart.
  ///
  /// In es, this message translates to:
  /// **'Iniciar entrenamiento'**
  String get workoutStart;

  /// No description provided for @timerStart.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In es, this message translates to:
  /// **'Pausar'**
  String get timerPause;

  /// No description provided for @timerResume.
  ///
  /// In es, this message translates to:
  /// **'Reanudar'**
  String get timerResume;

  /// No description provided for @timerRestart.
  ///
  /// In es, this message translates to:
  /// **'Reiniciar desde el principio'**
  String get timerRestart;

  /// No description provided for @timerSkip.
  ///
  /// In es, this message translates to:
  /// **'Saltar fase'**
  String get timerSkip;

  /// No description provided for @timerStop.
  ///
  /// In es, this message translates to:
  /// **'Terminar sesión'**
  String get timerStop;

  /// No description provided for @timerPaused.
  ///
  /// In es, this message translates to:
  /// **'En pausa'**
  String get timerPaused;

  /// No description provided for @timerCompleted.
  ///
  /// In es, this message translates to:
  /// **'¡Sesión completada!'**
  String get timerCompleted;

  /// No description provided for @timerStartError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar el reloj del dispositivo. Inténtalo de nuevo.'**
  String get timerStartError;

  /// No description provided for @timerPhasePreparation.
  ///
  /// In es, this message translates to:
  /// **'Preparación'**
  String get timerPhasePreparation;

  /// No description provided for @timerPhaseWork.
  ///
  /// In es, this message translates to:
  /// **'Trabajo'**
  String get timerPhaseWork;

  /// No description provided for @timerPhaseRest.
  ///
  /// In es, this message translates to:
  /// **'Descanso'**
  String get timerPhaseRest;

  /// No description provided for @timerPhaseRoundRest.
  ///
  /// In es, this message translates to:
  /// **'Descanso entre rondas'**
  String get timerPhaseRoundRest;

  /// No description provided for @timerPhaseSetRest.
  ///
  /// In es, this message translates to:
  /// **'Descanso entre series'**
  String get timerPhaseSetRest;

  /// No description provided for @timerPhaseCycleRest.
  ///
  /// In es, this message translates to:
  /// **'Descanso entre ciclos'**
  String get timerPhaseCycleRest;

  /// No description provided for @timerPhaseCooldown.
  ///
  /// In es, this message translates to:
  /// **'Vuelta a la calma'**
  String get timerPhaseCooldown;

  /// No description provided for @timerPhaseStopwatch.
  ///
  /// In es, this message translates to:
  /// **'Cronómetro'**
  String get timerPhaseStopwatch;

  /// No description provided for @timerPhaseFinished.
  ///
  /// In es, this message translates to:
  /// **'Terminado'**
  String get timerPhaseFinished;

  /// No description provided for @timerRoundLabel.
  ///
  /// In es, this message translates to:
  /// **'Ronda {current} de {total}'**
  String timerRoundLabel(int current, int total);

  /// No description provided for @timerSetLabel.
  ///
  /// In es, this message translates to:
  /// **'Serie {current} de {total}'**
  String timerSetLabel(int current, int total);

  /// No description provided for @timerCycleLabel.
  ///
  /// In es, this message translates to:
  /// **'Ciclo {current} de {total}'**
  String timerCycleLabel(int current, int total);

  /// No description provided for @timerElapsedLabel.
  ///
  /// In es, this message translates to:
  /// **'Tiempo transcurrido: {time}'**
  String timerElapsedLabel(String time);

  /// No description provided for @historyTitle.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get historyTitle;

  /// No description provided for @historyLoadError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el historial.'**
  String get historyLoadError;

  /// No description provided for @historySessions.
  ///
  /// In es, this message translates to:
  /// **'Sesiones'**
  String get historySessions;

  /// No description provided for @historyEmpty.
  ///
  /// In es, this message translates to:
  /// **'Completa tu primer entrenamiento para ver aquí el historial.'**
  String get historyEmpty;

  /// No description provided for @historyWeekTitle.
  ///
  /// In es, this message translates to:
  /// **'Últimos 7 días'**
  String get historyWeekTitle;

  /// No description provided for @historyWeekSummary.
  ///
  /// In es, this message translates to:
  /// **'{count} sesiones · {duration}'**
  String historyWeekSummary(int count, String duration);

  /// No description provided for @historyChartLabel.
  ///
  /// In es, this message translates to:
  /// **'En los últimos 7 días: {count} sesiones y {minutes} minutos de actividad.'**
  String historyChartLabel(int count, int minutes);

  /// No description provided for @historySessionSummary.
  ///
  /// In es, this message translates to:
  /// **'{duration} · {rounds} rondas completadas'**
  String historySessionSummary(String duration, int rounds);

  /// No description provided for @historyStopwatchSummary.
  ///
  /// In es, this message translates to:
  /// **'{duration} · cronómetro libre'**
  String historyStopwatchSummary(String duration);

  /// No description provided for @historyDurationHours.
  ///
  /// In es, this message translates to:
  /// **'{hours} h {minutes} min'**
  String historyDurationHours(int hours, int minutes);

  /// No description provided for @workoutCircuit.
  ///
  /// In es, this message translates to:
  /// **'Circuito'**
  String get workoutCircuit;

  /// No description provided for @workoutFreeCardio.
  ///
  /// In es, this message translates to:
  /// **'Cardio libre'**
  String get workoutFreeCardio;

  /// No description provided for @workoutStretching.
  ///
  /// In es, this message translates to:
  /// **'Estiramientos'**
  String get workoutStretching;

  /// No description provided for @workoutActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones del entrenamiento'**
  String get workoutActions;

  /// No description provided for @workoutDuplicated.
  ///
  /// In es, this message translates to:
  /// **'Entrenamiento duplicado.'**
  String get workoutDuplicated;

  /// No description provided for @workoutRemoveBlock.
  ///
  /// In es, this message translates to:
  /// **'Quitar bloque'**
  String get workoutRemoveBlock;

  /// No description provided for @durationSeconds.
  ///
  /// In es, this message translates to:
  /// **'{value} s'**
  String durationSeconds(int value);

  /// No description provided for @durationMinutes.
  ///
  /// In es, this message translates to:
  /// **'{value} min'**
  String durationMinutes(int value);

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get back;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
