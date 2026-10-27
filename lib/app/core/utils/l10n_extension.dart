import 'package:flutter/widgets.dart';
import 'package:lydera_app/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n =>
      AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('id', 'ID'));
}
