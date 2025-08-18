import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const localeKey = 'savedLocale';
  String currentLocale = 'ar', oldLocale = '';
  final SharedPreferences sharedPreferences;

  LocaleProvider(this.sharedPreferences) {
    getLocaleData();
  }

  static LocaleProvider get(BuildContext context) {
    return Provider.of<LocaleProvider>(context);
  }

  void getLocaleData() {
    currentLocale = sharedPreferences.getString(localeKey) ?? 'ar';
    oldLocale = currentLocale;
    notifyListeners();
  }

  void saveLocal(String localeToSave) {
    sharedPreferences.setString(localeKey, localeToSave);
  }

  void changeLocale(String newLocale) {
    oldLocale = currentLocale;
    currentLocale = newLocale;
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
