import 'package:flutter/material.dart';
import 'package:islamy_app/Modules/mainScreen/custom_widgets/custom_alert_dialog.dart';
import 'package:islamy_app/core/providers/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../layouts/quran_layout/quran_suras.dart';

class MainScreenProvider extends ChangeNotifier {
  static const barEnablementKey = 'barEnablement';

  /// initialize localeProvider before getting Suras List.
  LocaleProvider? localeProvider;

  final SharedPreferences sharedPreferences;
  int bottomBarCurrentIndex = 2;
  bool isBottomBarEnabled = true;

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
    markedHadeethIndex = sharedPreferences.getString(markedHadeethKey) ?? '';
    markedSurahPDFPageIndex =
        sharedPreferences.getString(markedSurahPDFPageKey) ?? '';
    fontSizeOfSurahVerses =
        sharedPreferences.getDouble(fontSizeOfSurahVersesKey) ?? 20;
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

  // Hadeeth Layout:-------------------------------
  static const markedHadeethKey = 'markedHadeeth';
  String markedHadeethIndex = '';

  void changeMarkedHadeeth(String hadeethIndex) {
    markedHadeethIndex = hadeethIndex;
    notifyListeners();
    sharedPreferences.setString(markedHadeethKey, hadeethIndex);
  }

  //Hadeeth Screen:
  bool isHadeethScreenAppBarVisible = true;

  void changeHadeethScreenAppBarStatus(bool newValue) {
    isHadeethScreenAppBarVisible = newValue;
    notifyListeners();
  }

  void showAlertAboutHadeethMarking(
      BuildContext context, ThemeData theme, String hadeethToMarkIndex) {
    CustAlertDialog.showBookMarkAlertDialog(
      context,
      theme: theme,
      message: localeProvider!.isArabicChosen()
          ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها على الحديث رقم ${int.parse(markedHadeethIndex) + 1}"
          : 'If you perceed, you\'re going to lose the old bookmark made on hadeeth number ${int.parse(markedHadeethIndex) + 1}',
      okButtonFunction: () {
        changeMarkedHadeeth(hadeethToMarkIndex);
        Navigator.pop(context);
      },
    );
  }

  // Quran layout:-------------------------------
  List<String> getSurasListEnglishOrArabic() {
    if (localeProvider!.isArabicChosen()) {
      return Suras.arabicAuranSuras;
    } else {
      return Suras.englishQuranSurahs;
    }
  }

  // Surah screen widget:
  static const markedSurahKey = 'markedSurah';
  static const markedVerseKey = 'markedVerse';
  static const markedSurahPDFPageKey = 'markedPDFPage';
  static const fontSizeOfSurahVersesKey = 'fontSizeOfVerses';

  String markedSurahIndex = '';
  String markedVerseIndex = '';
  String markedSurahPDFPageIndex = '';
  bool isSurahScreenAppBarVisible = true;
  double fontSizeOfSurahVerses = 20;

  void changeMarkedSurah(String index) {
    markedSurahIndex = index;
    notifyListeners();
    // Saving Info
    sharedPreferences.setString(markedSurahKey, index);
  }

  void changeMarkedVerse(String index) {
    markedVerseIndex = index;
    notifyListeners();
    // Saving Info
    sharedPreferences.setString(markedVerseKey, index);
  }

  void changeMarkedSurahPDFPage(String index) {
    markedSurahPDFPageIndex = index;
    notifyListeners();
    // Saving Info
    sharedPreferences.setString(markedSurahPDFPageKey, index);
  }

  void changeSurahScreenAppBarStatus(bool newValue) {
    isSurahScreenAppBarVisible = newValue;
    notifyListeners();
  }

  void changeFontSizeOfSurahVerses(double newSize) {
    fontSizeOfSurahVerses = newSize;
    notifyListeners();
    // Saving Info
    sharedPreferences.setDouble(fontSizeOfSurahVersesKey, newSize);
  }

  void showAlertAboutVersesMarking(
      BuildContext context, ThemeData theme, String verseToMarkIndex) {
    List<String> verseMarkInfo = markedVerseIndex.split(' ');
    int surahIndexOfMarkedVerse = int.parse(verseMarkInfo[0]);
    int numberOfMarkedVerseInSurah = int.parse(verseMarkInfo[1]);
    CustAlertDialog.showBookMarkAlertDialog(context,
        theme: theme,
        message: localeProvider!.isArabicChosen()
            ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في سورة ${Suras.arabicAuranSuras[surahIndexOfMarkedVerse]} الآية رقم $numberOfMarkedVerseInSurah"
            : 'If you proceed, you\'re going to lose the old bookmark made in ${Suras.englishQuranSurahs[surahIndexOfMarkedVerse]} surah the verse number $numberOfMarkedVerseInSurah',
        okButtonFunction: () {
      changeMarkedVerse(verseToMarkIndex);
      Navigator.pop(context);
    });
  }

  void showAlertAboutSurasMarking(
      BuildContext context, ThemeData theme, String surahToMarkIndex) {
    CustAlertDialog.showBookMarkAlertDialog(context,
        theme: theme,
        message: localeProvider!.isArabicChosen()
            ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها على سورة ${Suras.arabicAuranSuras[int.parse(markedSurahIndex)]}"
            : 'If you perceed, you\'re going to lose the old bookmark made on ${Suras.englishQuranSurahs[int.parse(markedSurahIndex)]} surah',
        okButtonFunction: () {
      changeMarkedSurah(surahToMarkIndex);
      Navigator.pop(context);
    });
  }

  void showAlertAboutMarkedSurahPDFPage(
      BuildContext context, ThemeData theme, String pageToMarkIndex) {
    List<String> pageMarkInfo = markedSurahPDFPageIndex.split(' ');
    String surahIndexOfMarkedPage = pageMarkInfo[0],
        indexOfMarkedPage = pageMarkInfo[1];

    CustAlertDialog.showBookMarkAlertDialog(context,
        theme: theme,
        message: localeProvider!.isArabicChosen()
            ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في سورة ${Suras.arabicAuranSuras[int.parse(surahIndexOfMarkedPage)]}صفحة رقم $indexOfMarkedPage "
            : 'If you perceed, you\'re going to lose the old bookmark made in ${Suras.englishQuranSurahs[int.parse(surahIndexOfMarkedPage)]} surah page number $indexOfMarkedPage',
        okButtonFunction: () {
      changeMarkedSurahPDFPage(pageToMarkIndex);
      Navigator.pop(context);
    });
  }
//----------------------------------------------------------------------
}
