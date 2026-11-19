import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
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
        ...GlobalMaterialLocalizations.delegates,
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
  /// **'Algunos avisos dependen de los permisos de notificación del dispositivo.'**
  String get settingsBackgroundCuesNote;

  /// No description provided for @settingsPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Sin cuenta, anuncios ni compras.'**
  String get settingsPrivacy;

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
