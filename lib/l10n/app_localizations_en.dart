// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tempo: Workout Timer';

  @override
  String get brandName => 'Tempo';

  @override
  String get homeTitle => 'Workouts';

  @override
  String get homeTagline => 'Your session, at your pace.';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeHistory => 'History';

  @override
  String get navTabata => 'Tabata';

  @override
  String get navWorkouts => 'Rounds';

  @override
  String get navStopwatch => 'Stopwatch';

  @override
  String get navMore => 'More';

  @override
  String get tabataQuickIntro =>
      'Set your work, rest, and rounds before you start.';

  @override
  String get tabataWork => 'Work (s)';

  @override
  String get tabataRest => 'Rest (s)';

  @override
  String get tabataRounds => 'Rounds';

  @override
  String get tabataDuration => 'Estimated duration';

  @override
  String get tabataStart => 'Start Tabata';

  @override
  String get tabataHint =>
      'Changes apply to this session. Save custom workouts in Rounds.';

  @override
  String get tabataDecreaseWork => 'Decrease work seconds';

  @override
  String get tabataIncreaseWork => 'Increase work seconds';

  @override
  String get tabataDecreaseRest => 'Decrease rest seconds';

  @override
  String get tabataIncreaseRest => 'Increase rest seconds';

  @override
  String get tabataDecreaseRounds => 'Decrease rounds';

  @override
  String get tabataIncreaseRounds => 'Increase rounds';

  @override
  String get stopwatchIntro => 'Time a free session without intervals.';

  @override
  String get stopwatchStart => 'Start stopwatch';

  @override
  String get stopwatchHint =>
      'Your session is added to history when you finish.';

  @override
  String get moreTitle => 'More';

  @override
  String get moreLead => 'Your progress and preferences, all in one place.';

  @override
  String get moreHistory => 'Session history';

  @override
  String get moreSettings => 'Tempo settings';

  @override
  String get morePrivacy =>
      'No account, ads, or purchases. Your activity stays on this device.';

  @override
  String get onboardingTitle => 'Move at your pace';

  @override
  String get onboardingLead => 'A clear timer for intervals, rounds, and rest.';

  @override
  String get onboardingOffline => 'No account or connection needed';

  @override
  String get onboardingOfflineDetail => 'Your workouts stay on this device.';

  @override
  String get onboardingPersonalize => 'Routines made yours';

  @override
  String get onboardingPersonalizeDetail =>
      'Build intervals or start from an original template.';

  @override
  String get onboardingCues => 'Cues your way';

  @override
  String get onboardingCuesDetail =>
      'Combine sound, voice, and vibration when you want.';

  @override
  String get onboardingSkip => 'Not now';

  @override
  String get onboardingContinue => 'Get started';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageSpanish => 'Spanish';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsThemeSystem => 'Automatic';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsUnits => 'Units';

  @override
  String get settingsCues => 'Cues';

  @override
  String get settingsUnitsMetric => 'Metric';

  @override
  String get settingsUnitsImperial => 'Imperial';

  @override
  String get settingsSound => 'Sound cues';

  @override
  String get settingsVoice => 'Voice cues';

  @override
  String get settingsHaptics => 'Vibration';

  @override
  String get settingsKeepScreenOn => 'Keep screen on';

  @override
  String get settingsBackgroundCues => 'Cues with screen off';

  @override
  String get settingsBackgroundCuesNote =>
      'Not available yet. The timer catches up when you return, but it cannot cue while the app is suspended.';

  @override
  String get settingsPrivacy => 'No account, ads, or purchases.';

  @override
  String get workoutsTitle => 'Workouts';

  @override
  String get workoutsSearch => 'Search workouts';

  @override
  String get workoutsCreate => 'Create workout';

  @override
  String get workoutsEmpty => 'No workouts match that name.';

  @override
  String get workoutsSortName => 'Name';

  @override
  String get workoutsSortRecent => 'Recently updated';

  @override
  String get workoutsDuplicate => 'Duplicate';

  @override
  String get workoutsEdit => 'Edit';

  @override
  String get workoutsDelete => 'Delete';

  @override
  String get workoutsCancel => 'Cancel';

  @override
  String get workoutsDeleteTitle => 'Delete workout';

  @override
  String get workoutsDeleteMessage =>
      'This workout will be deleted. Saved history sessions will be kept.';

  @override
  String get workoutsCreateTitle => 'New workout';

  @override
  String get workoutsEditTitle => 'Edit workout';

  @override
  String get workoutName => 'Name';

  @override
  String get workoutMode => 'Timer type';

  @override
  String get workoutIntervals => 'Intervals';

  @override
  String get workoutStopwatch => 'Stopwatch';

  @override
  String get workoutPreparation => 'Start countdown (s)';

  @override
  String get workoutBlocks => 'Blocks';

  @override
  String get workoutAddBlock => 'Add block';

  @override
  String get workoutBlockName => 'Block name';

  @override
  String get workoutWorkSeconds => 'Work (s)';

  @override
  String get workoutRestSeconds => 'Rest (s)';

  @override
  String get workoutRounds => 'Rounds';

  @override
  String get workoutSets => 'Sets';

  @override
  String get workoutRoundRest => 'Rest between rounds (s)';

  @override
  String get workoutSetRest => 'Rest between sets (s)';

  @override
  String get workoutCooldown => 'Cool down (s)';

  @override
  String get workoutSave => 'Save workout';

  @override
  String get workoutNameRequired => 'Enter a workout name.';

  @override
  String get workoutAtLeastOneBlock => 'Add at least one work block.';

  @override
  String get workoutInvalidNumber => 'Check the times and counts you entered.';

  @override
  String workoutIntervalSummary(
    int rounds,
    int sets,
    int blocks,
    String duration,
  ) {
    return '$rounds rounds · $sets sets · $blocks blocks · $duration';
  }

  @override
  String get workoutStopwatchSummary => 'Free stopwatch';

  @override
  String get workoutBuiltIn => 'Template';

  @override
  String get workoutStart => 'Start workout';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerResume => 'Resume';

  @override
  String get timerRestart => 'Restart from beginning';

  @override
  String get timerSkip => 'Skip phase';

  @override
  String get timerStop => 'End session';

  @override
  String get timerPaused => 'Paused';

  @override
  String get timerCompleted => 'Workout complete!';

  @override
  String get timerStartError =>
      'The device clock could not start. Please try again.';

  @override
  String get timerPhasePreparation => 'Get ready';

  @override
  String get timerPhaseWork => 'Work';

  @override
  String get timerPhaseRest => 'Rest';

  @override
  String get timerPhaseRoundRest => 'Rest between rounds';

  @override
  String get timerPhaseSetRest => 'Rest between sets';

  @override
  String get timerPhaseCooldown => 'Cool down';

  @override
  String get timerPhaseStopwatch => 'Stopwatch';

  @override
  String get timerPhaseFinished => 'Finished';

  @override
  String timerRoundLabel(int current, int total) {
    return 'Round $current of $total';
  }

  @override
  String timerSetLabel(int current, int total) {
    return 'Set $current of $total';
  }

  @override
  String timerElapsedLabel(String time) {
    return 'Elapsed: $time';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get historyLoadError => 'History could not be loaded.';

  @override
  String get historySessions => 'Sessions';

  @override
  String get historyEmpty =>
      'Complete your first workout to see your history here.';

  @override
  String get historyWeekTitle => 'Last 7 days';

  @override
  String historyWeekSummary(int count, String duration) {
    return '$count sessions · $duration';
  }

  @override
  String historyChartLabel(int count, int minutes) {
    return 'In the last 7 days: $count sessions and $minutes minutes of activity.';
  }

  @override
  String historySessionSummary(String duration, int rounds) {
    return '$duration · $rounds rounds completed';
  }

  @override
  String historyStopwatchSummary(String duration) {
    return '$duration · free stopwatch';
  }

  @override
  String historyDurationHours(int hours, int minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String get workoutCircuit => 'Circuit';

  @override
  String get workoutFreeCardio => 'Free cardio';

  @override
  String get workoutStretching => 'Stretching';

  @override
  String get workoutActions => 'Workout actions';

  @override
  String get workoutDuplicated => 'Workout duplicated.';

  @override
  String get workoutRemoveBlock => 'Remove block';

  @override
  String durationSeconds(int value) {
    return '$value sec';
  }

  @override
  String durationMinutes(int value) {
    return '$value min';
  }

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';
}
