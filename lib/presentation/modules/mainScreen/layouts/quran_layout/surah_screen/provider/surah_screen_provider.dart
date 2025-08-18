import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/custom_widgets/custom_alert_dialog.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class SurahScreenProvider extends ChangeNotifier {
  SharedPreferences sharedPreferences;

  SurahScreenProvider(this.sharedPreferences) {
    getSurahScreenData();
  }

  late LocaleProvider _localeProvider;

  void getLocaleProvider(LocaleProvider localeProvider) {
    _localeProvider = localeProvider;
  }

  double fontSizeOfSurahVerses = 20;

  static const markedVerseKey = 'markedVerse';
  static const markedSurahPDFPageKey = 'markedPDFPage';

  String markedVerseIndex = '';
  String markedSurahPDFPageIndex = '';
  bool isSurahOrHadeethScreenAppBarVisible = true;

  static const fontSizeOfSurahVersesKey = 'fontSizeOfVerses';

  void getSurahScreenData() {
    fontSizeOfSurahVerses =
        sharedPreferences.getDouble(fontSizeOfSurahVersesKey) ?? 20;
    markedVerseIndex = sharedPreferences.getString(markedVerseKey) ?? '';
    markedSurahPDFPageIndex =
        sharedPreferences.getString(markedSurahPDFPageKey) ?? '';
    notifyListeners();
  }

  void changeFontSizeOfSurahVerses(double newSize) {
    fontSizeOfSurahVerses = newSize;
    notifyListeners();
    // Saving Info
    sharedPreferences.setDouble(fontSizeOfSurahVersesKey, newSize);
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

  void changeSurahOrHadeethScreenAppBarStatus(bool newValue) {
    isSurahOrHadeethScreenAppBarVisible = newValue;
    notifyListeners();
  }

  void showAlertAboutVersesMarking(
      BuildContext context, ThemeData theme, String verseToMarkIndex) {
    List<String> verseMarkInfo = markedVerseIndex.split(' ');
    int surahIndexOfMarkedVerse = int.parse(verseMarkInfo[0]);
    int numberOfMarkedVerseInSurah = int.parse(verseMarkInfo[1]);
    CustAlertDialog.showBookMarkAlertDialog(context,
        theme: theme,
        message: _getAlertMessageAboutVersesMarking(
            numberOfMarkedVerseInSurah, surahIndexOfMarkedVerse),
        okButtonFunction: () {
      changeMarkedVerse(verseToMarkIndex);
      Navigator.pop(context);
    });
  }

  String _getAlertMessageAboutVersesMarking(
      int numberOfMarkedVerseInSurah, int surahIndexOfMarkedVerse) {
    if (_localeProvider.isArabicChosen()) {
      return "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في ${(surahIndexOfMarkedVerse == 114) ? "${Suras.arabicAuranSuras[surahIndexOfMarkedVerse]} الفقرة رقم $numberOfMarkedVerseInSurah" : " سورة ${Suras.arabicAuranSuras[surahIndexOfMarkedVerse]} الآية رقم $numberOfMarkedVerseInSurah"}";
    } else {
      return "If you proceed, you're going to lose the old bookmark made in ${(surahIndexOfMarkedVerse == 114) ? "${Suras.englishQuranSurahs[surahIndexOfMarkedVerse]} the paragraph number $numberOfMarkedVerseInSurah" : "${Suras.englishQuranSurahs[surahIndexOfMarkedVerse]} surah the verse number $numberOfMarkedVerseInSurah"}";
    }
  }

  void showAlertAboutMarkedSurahPDFPage(
      BuildContext context, ThemeData theme, String pageToMarkIndex) {
    List<String> pageMarkInfo = markedSurahPDFPageIndex.split(' ');
    String surahIndexOfMarkedPage = pageMarkInfo[0],
        indexOfMarkedPage = pageMarkInfo[1];

    CustAlertDialog.showBookMarkAlertDialog(context,
        theme: theme,
        message: _localeProvider.isArabicChosen()
            ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في سورة ${Suras.arabicAuranSuras[int.parse(surahIndexOfMarkedPage)]}صفحة رقم $indexOfMarkedPage "
            : 'If you perceed, you\'re going to lose the old bookmark made in ${Suras.englishQuranSurahs[int.parse(surahIndexOfMarkedPage)]} surah page number $indexOfMarkedPage',
        okButtonFunction: () {
      changeMarkedSurahPDFPage(pageToMarkIndex);
      Navigator.pop(context);
    });
  }
}
