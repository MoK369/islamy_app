import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/custom_widgets/custom_alert_dialog.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class MainScreenProvider extends ChangeNotifier {
  static const barEnablementKey = 'barEnablement';
  /// initialize localeProvider before getting Suras List.
  late LocaleProvider _localeProvider;

  void getLocaleProvider(LocaleProvider localeProvider) {
    _localeProvider = localeProvider;
  }

  final SharedPreferences sharedPreferences;
  int bottomBarCurrentIndex = 2;
  bool isBottomBarEnabled = true;

  MainScreenProvider(this.sharedPreferences) {
    getMainScreenData();
  }

  static MainScreenProvider get(BuildContext context) {
    return Provider.of<MainScreenProvider>(context);
  }

  void getMainScreenData() {
    isBottomBarEnabled = sharedPreferences.getBool(barEnablementKey) ?? true;
    markedHadeethIndex = sharedPreferences.getString(markedHadeethKey) ?? '';
    markedSurahIndex = sharedPreferences.getString(markedSurahKey) ?? '';
    notifyListeners();
  }

  void saveBarEnablement(bool newValue) {
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

  // Hadeeth Layout:-------------------------------
  static const markedHadeethKey = 'markedHadeeth';
  String markedHadeethIndex = '';

  void changeMarkedHadeeth(String hadeethIndex) {
    markedHadeethIndex = hadeethIndex;
    notifyListeners();
    sharedPreferences.setString(markedHadeethKey, hadeethIndex);
  }

  void showAlertAboutHadeethMarking(
      BuildContext context, ThemeData theme, String hadeethToMarkIndex) {
    CustAlertDialog.showBookMarkAlertDialog(
      context,
      theme: theme,
      message: _localeProvider.isArabicChosen()
          ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها على الحديث رقم ${int.parse(markedHadeethIndex) + 1}"
          : 'If you perceed, you\'re going to lose the old bookmark made on hadeeth number ${int.parse(markedHadeethIndex) + 1}',
      okButtonFunction: () {
        changeMarkedHadeeth(hadeethToMarkIndex);
        Navigator.pop(context);
      },
    );
  }

  // Quran layout:-------------------------------
  final TextEditingController searchFieldController = TextEditingController();

  List<String> getSurasListEnglishOrArabic() {
    if (_localeProvider.isArabicChosen()) {
      return Suras.arabicAuranSuras;
    } else {
      return Suras.englishQuranSurahs;
    }
  }

  // Surahs list:
  static const markedSurahKey = 'markedSurah';

  String markedSurahIndex = '';
  void changeMarkedSurah(String index) {
    markedSurahIndex = index;
    notifyListeners();
    // Saving Info
    sharedPreferences.setString(markedSurahKey, index);
  }

  void showAlertAboutSurasMarking(
      BuildContext context, ThemeData theme, String surahToMarkIndex) {
    CustAlertDialog.showBookMarkAlertDialog(context,
        theme: theme,
        message: _getAlertMessageAboutSurasMarking(), okButtonFunction: () {
      changeMarkedSurah(surahToMarkIndex);
      Navigator.pop(context);
    });
  }

  String _getAlertMessageAboutSurasMarking() {
    if (_localeProvider.isArabicChosen()) {
      return "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها على ${(int.parse(markedSurahIndex) == 114) ? Suras.arabicAuranSuras[int.parse(markedSurahIndex)] : "سورة ${Suras.arabicAuranSuras[int.parse(markedSurahIndex)]}"}";
    } else {
      return "If you perceed, you're going to lose the old bookmark made on ${(int.parse(markedSurahIndex) == 114) ? Suras.englishQuranSurahs[int.parse(markedSurahIndex)] : "${Suras.englishQuranSurahs[int.parse(markedSurahIndex)]} surah"}";
    }
  }


//----------------------------------------------------------------------
}
