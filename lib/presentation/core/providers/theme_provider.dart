// Observable - Subject - Provider
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class ThemeProvider extends ChangeNotifier {
  static const themeKey = 'savedTheme';
  ThemeMode currentTheme = ThemeMode.light;
  final SharedPreferences sharedPreferences;

  ThemeProvider(this.sharedPreferences) {
    getThemeData();
  }

  static ThemeProvider get(BuildContext context) {
    return Provider.of<ThemeProvider>(context);
  }

  getThemeData() {
    String savedTheme =
        sharedPreferences.getString(themeKey) ?? 'ThemeMode.light';
    currentTheme =
        savedTheme == 'ThemeMode.light' ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void saveTheme(ThemeMode theme) {
    sharedPreferences.setString(themeKey, '$theme');
  }

  void changeTheme(ThemeMode newTheme) {
    currentTheme = newTheme;
    notifyListeners();
    saveTheme(newTheme);
  }

  bool isDarkEnabled() {
    return currentTheme == ThemeMode.dark ? true : false;
  }
}
