import 'package:flutter/material.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../layouts/quran_layout/quran_suras.dart';

class MainScreenProvider extends ChangeNotifier {
  static const barEnablementKey = 'barEnablement';
  static const markedSurahKey = 'markedSurah';
  static const markedVerseKey = 'markedVerse';

  /// initialize mainScreenSize with the true value before using it.
  Size mainScreenSize = const Size(0, 0);

  /// initialize localeProvider before getting Suras List.
  LocaleProvider? localeProvider;

  final SharedPreferences sharedPreferences;
  int bottomBarCurrentIndex = 2;
  bool isBottomBarEnabled = true;
  String markedSurahIndex = '';
  String markedVerseIndex = '';

  MainScreenProvider(this.sharedPreferences) {
    getMainScreenData();
  }

  static MainScreenProvider get(BuildContext context) {
    return Provider.of<MainScreenProvider>(context);
  }

  getMainScreenData() {
    isBottomBarEnabled = sharedPreferences.getBool(barEnablementKey) ?? true;
    markedSurahIndex = sharedPreferences.getString(markedSurahKey) ?? '';
    markedVerseIndex = sharedPreferences.getString(markedVerseKey) ?? '';
    notifyListeners();
  }

  saveBarEnablement(bool newValue) {
    sharedPreferences.setBool(barEnablementKey, newValue);
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

  void changeMarkedSurah(String index) {
    markedSurahIndex = index;
    notifyListeners();
    saveMarkedSurah(index);
  }

  void saveMarkedSurah(String index) {
    sharedPreferences.setString(markedSurahKey, index);
  }

  void changeMarkedVerse(String index) {
    markedVerseIndex = index;
    notifyListeners();
    saveMarkedVerse(index);
  }

  void saveMarkedVerse(String index) {
    sharedPreferences.setString(markedVerseKey, index);
  }
}
