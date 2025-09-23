import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/main.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/utils/handlers/execute_handler.dart';
import 'package:islamy_app/presentation/modules/mainScreen/custom_widgets/custom_alert_dialog.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class SurahScreenProvider extends ChangeNotifier {
  SharedPreferences sharedPreferences;
  final LocaleProvider _localeProvider;

  SurahScreenProvider(this.sharedPreferences, this._localeProvider) {
    getSurahScreenData();
  }

  double fontSizeOfSurahVerses = 20;

  static const markedVerseKey = 'markedVerse';
  static const markedSurahPDFPageKey = 'markedPDFPage';

  String markedVerseIndex = '';
  String markedSurahPDFPageIndex = '';
  bool isSurahOrHadeethScreenAppBarVisible = true;

  static const fontSizeOfSurahVersesKey = 'fontSizeOfVerses';

  Future<void> getSurahScreenData() async {
    await executeHandler(() {
      fontSizeOfSurahVerses =
          sharedPreferences.getDouble(fontSizeOfSurahVersesKey) ?? 20;
      markedVerseIndex = sharedPreferences.getString(markedVerseKey) ?? '';
      markedSurahPDFPageIndex =
          sharedPreferences.getString(markedSurahPDFPageKey) ?? '';
      notifyListeners();
    }, errorMessage: getIt.get<AppLocalizations>().errorLoadingSavedData);
  }

  Future<void> changeFontSizeOfSurahVerses(double newSize) async {
    await executeHandler(() async {
      fontSizeOfSurahVerses = newSize;
      notifyListeners();
      // Saving Info
      await sharedPreferences.setDouble(fontSizeOfSurahVersesKey, newSize);
    }, errorMessage: getIt.get<AppLocalizations>().errorSavingFontSize);
  }

  void changeMarkedVerse(String index) {
    executeHandler(() async {
      markedVerseIndex = index;
      notifyListeners();
      // Saving Info
      await sharedPreferences.setString(markedVerseKey, index);
    }, errorMessage: getIt.get<AppLocalizations>().errorSavingNewMarkedVerse);
  }

  void changeMarkedSurahPDFPage(String index) {
    executeHandler(() async {
      markedSurahPDFPageIndex = index;
      notifyListeners();
      // Saving Info
      await sharedPreferences.setString(markedSurahPDFPageKey, index);
    }, errorMessage: getIt.get<AppLocalizations>().errorSavingNewMarkedPDFPage);
  }

  void changeSurahOrHadeethScreenAppBarStatus(bool newValue) async {
    await executeHandler(() async {
      isSurahOrHadeethScreenAppBarVisible = newValue;
      if (isSurahOrHadeethScreenAppBarVisible) {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      }
      notifyListeners();
    },
        errorMessage:
            getIt.get<AppLocalizations>().errorChangingAppBarVisibility);
  }

  void showAlertAboutVersesMarking(ThemeData theme, String verseToMarkIndex) {
    executeHandler(() {
      List<String> verseMarkInfo = markedVerseIndex.split(' ');
      int surahIndexOfMarkedVerse = int.parse(verseMarkInfo[0]);
      int numberOfMarkedVerseInSurah = int.parse(verseMarkInfo[1]);
      CustomAlertDialog.showBookMarkAlertDialog(
          globalNavigatorKey.currentContext!,
          theme: theme,
          message: _getAlertMessageAboutVersesMarking(
              numberOfMarkedVerseInSurah, surahIndexOfMarkedVerse),
          okButtonFunction: () {
        changeMarkedVerse(verseToMarkIndex);
        globalNavigatorKey.currentState!.pop();
      });
    },
        errorMessage:
            getIt.get<AppLocalizations>().errorShowingAlertVersesMarkingDialog);
  }

  String _getAlertMessageAboutVersesMarking(
      int numberOfMarkedVerseInSurah, int surahIndexOfMarkedVerse) {
    if (_localeProvider.isArabicChosen()) {
      return "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في ${(surahIndexOfMarkedVerse == 114) ? "${Suras.arabicAuranSuras[surahIndexOfMarkedVerse]} الفقرة رقم $numberOfMarkedVerseInSurah" : " سورة ${Suras.arabicAuranSuras[surahIndexOfMarkedVerse]} الآية رقم $numberOfMarkedVerseInSurah"}";
    } else {
      return "If you proceed, you're going to lose the old bookmark made in ${(surahIndexOfMarkedVerse == 114) ? "${Suras.englishQuranSurahs[surahIndexOfMarkedVerse]} the paragraph number $numberOfMarkedVerseInSurah" : "${Suras.englishQuranSurahs[surahIndexOfMarkedVerse]} surah the verse number $numberOfMarkedVerseInSurah"}";
    }
  }

  void showAlertAboutMarkedSurahPDFPage(ThemeData theme,
      String pageToMarkIndex) {
    executeHandler(() {
      List<String> pageMarkInfo = markedSurahPDFPageIndex.split(' ');
      String surahIndexOfMarkedPage = pageMarkInfo[0],
          indexOfMarkedPage = pageMarkInfo[1];

      CustomAlertDialog.showBookMarkAlertDialog(
          globalNavigatorKey.currentContext!,
          theme: theme,
          message: _localeProvider.isArabicChosen()
              ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في سورة ${Suras.arabicAuranSuras[int.parse(surahIndexOfMarkedPage)]}صفحة رقم $indexOfMarkedPage "
              : 'If you perceed, you\'re going to lose the old bookmark made in ${Suras.englishQuranSurahs[int.parse(surahIndexOfMarkedPage)]} surah page number $indexOfMarkedPage',
          okButtonFunction: () {
        changeMarkedSurahPDFPage(pageToMarkIndex);
        globalNavigatorKey.currentState!.pop();
      });
    },
        errorMessage: getIt
            .get<AppLocalizations>()
            .errorShowingAlertPDFPageMarkingDialog);
  }
}
