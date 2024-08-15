import 'package:flutter/material.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../layouts/quran_layout/quran_suras.dart';

class MainScreenProvider extends ChangeNotifier {
  /// initialize mainScreenSize with the true value before using it.
  Size mainScreenSize = const Size(0, 0);

  /// initialize localeProvider before getting Suras List.
  LocaleProvider? localeProvider;

  final SharedPreferences sharedPreferences;
  int bottomBarCurrentIndex = 2;
  bool isBottomBarEnabled = true;

  MainScreenProvider(this.sharedPreferences) {
    getBarEnablementData();
  }

  static MainScreenProvider get(BuildContext context) {
    return Provider.of<MainScreenProvider>(context);
  }

  getBarEnablementData() {
    isBottomBarEnabled = sharedPreferences.getBool('barEnablement') ?? true;
    notifyListeners();
  }

  saveBarEnablement(bool newValue) {
    sharedPreferences.setBool('barEnablement', newValue);
  }
  void changeBarEnablement(bool newValue) {
    isBottomBarEnabled = newValue;
    notifyListeners();
    saveBarEnablement(newValue);
  }

  void changeBarIndex(int newIndex) {
    bottomBarCurrentIndex = newIndex;
    notifyListeners();
  }

  List<String> getSurasListEnglishOrArabic() {
    if (localeProvider!.isArabicChosen()) {
      return Suras.arabicAuranSuras;
    } else {
      return Suras.englishQuranSurahs;
    }
  }
}
