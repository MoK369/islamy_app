import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  String currentLocale = 'ar';
  late SharedPreferences sharedPreferences;

  LocaleProvider() {
    getLocaleData();
  }

  static LocaleProvider get(BuildContext context) {
    return Provider.of<LocaleProvider>(context);
  }

  getLocaleData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String savedLocale = sharedPreferences.getString('savedLocale') ?? 'ar';
    currentLocale = savedLocale;
    notifyListeners();
  }

  void saveLocal(String locale) async {
    sharedPreferences.setString('savedLocale', locale);
  }

  void changeLocale(String newLocale) {
    currentLocale = newLocale;
    notifyListeners();
  }

  bool isArabicChosen() {
    return currentLocale == 'ar' ? true : false;
  }
}
