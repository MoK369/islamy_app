// Observable - Subject - Provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.light;

  ThemeProvider() {
    getThemeData();
  }

  getThemeData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedTheme =
        sharedPreferences.getString('savedTheme') ?? 'ThemeMode.light';
    currentTheme =
        savedTheme == 'ThemeMode.light' ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  static ThemeProvider get(BuildContext context) {
    return Provider.of<ThemeProvider>(context);
  }

  void changeTheme(ThemeMode newTheme) {
    currentTheme = newTheme;
    notifyListeners();
  }

  bool isDarkEnabled() {
    return currentTheme == ThemeMode.dark ? true : false;
  }
}
