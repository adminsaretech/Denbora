import 'package:flutter/widgets.dart' show LocalizationsDelegate;
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// Uses the Material localization implementation that matches material_ui.
/// Keeping this outside generated code makes `flutter gen-l10n` safe to rerun.
abstract final class TempoLocalizationDelegates {
  static const List<LocalizationsDelegate<dynamic>> all = [
    AppLocalizations.delegate,
    ...GlobalMaterialLocalizations.delegates,
  ];
}

