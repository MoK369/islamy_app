import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/utils/constants/locale_constants.dart';

@module
abstract class AppLocalizationsProvider {
  @preResolve
  Future<AppLocalizations> provide(
      @Named(LocaleConstants.getSavedLocale) String currentLocale) {
    return AppLocalizations.delegate.load(Locale(currentLocale));
  }
}
