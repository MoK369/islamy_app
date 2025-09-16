import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/utils/constants/locale_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class LocaleProvider extends ChangeNotifier {
  String currentLocale;
  late String oldLocale;
  final SharedPreferences sharedPreferences;

  LocaleProvider(this.sharedPreferences,
      @Named(LocaleConstants.getSavedLocale) this.currentLocale) {
    oldLocale = currentLocale;
  }

  static LocaleProvider get(BuildContext context, {bool listen = true}) {
    return Provider.of<LocaleProvider>(context, listen: listen);
  }

  void saveLocal(String localeToSave) {
    sharedPreferences.setString(LocaleConstants.localeKey, localeToSave);
  }

  void changeLocale(String newLocale) async {
    oldLocale = currentLocale;
    currentLocale = newLocale;
    var appLocalization = await AppLocalizations.delegate.load(
      Locale(newLocale),
    );
    if (getIt.isRegistered<AppLocalizations>()) {
      await getIt.unregister<AppLocalizations>();
    }
    getIt.registerSingleton<AppLocalizations>(appLocalization);
    notifyListeners();
    saveLocal(newLocale);
  }

  bool isArabicChosen() {
    return currentLocale == 'ar' ? true : false;
  }

  bool didLocaleChange() {
    return currentLocale != oldLocale;
  }
}
