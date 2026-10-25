import 'package:flutter/widgets.dart';
import 'package:novasight_app/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('id', 'ID'));
}
