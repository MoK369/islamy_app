import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/main.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/utils/dialog_service/dialog_service.dart';
import 'package:islamy_app/presentation/core/utils/handlers/execute_handler.dart';
import 'package:islamy_app/presentation/core/utils/handlers/system_ui_handler/system_ui_mode_handler.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class SurahScreenProvider extends ChangeNotifier {
  SharedPreferences sharedPreferences;
  final LocaleProvider _localeProvider;
  final SystemUiModeHandler _systemUiModeHandler;
  final DialogService _dialogService;

  SurahScreenProvider(this.sharedPreferences, this._localeProvider,
      this._systemUiModeHandler, this._dialogService) {
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

  Future<void> changeMarkedVerse(String index) async {
    await executeHandler(() async {
      markedVerseIndex = index;
      notifyListeners();
      // Saving Info
      await sharedPreferences.setString(markedVerseKey, index);
    }, errorMessage: getIt.get<AppLocalizations>().errorSavingNewMarkedVerse);
  }

  Future<void> changeMarkedSurahPDFPage(String index) async {
    await executeHandler(() async {
      markedSurahPDFPageIndex = index;
      notifyListeners();
      // Saving Info
      await sharedPreferences.setString(markedSurahPDFPageKey, index);
    }, errorMessage: getIt.get<AppLocalizations>().errorSavingNewMarkedPDFPage);
  }

  Future<void> changeSurahOrHadeethScreenAppBarStatus(bool newValue) async {
    await executeHandler(() async {
      isSurahOrHadeethScreenAppBarVisible = newValue;
      if (isSurahOrHadeethScreenAppBarVisible) {
        await _systemUiModeHandler
            .setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      } else {
        await _systemUiModeHandler
            .setEnabledSystemUIMode(SystemUiMode.immersive);
      }
      notifyListeners();
    },
        errorMessage:
            getIt.get<AppLocalizations>().errorChangingAppBarVisibility);
  }

  Future<void> showAlertAboutVersesMarking(String verseToMarkIndex) async {
    await executeHandler(() async {
      List<String> verseMarkInfo = markedVerseIndex.split(' ');
      int surahIndexOfMarkedVerse = int.parse(verseMarkInfo[0]);
      int numberOfMarkedVerseInSurah = int.parse(verseMarkInfo[1]);
      await _dialogService.showBookMarkAlertDialog(
          message: _getAlertMessageAboutVersesMarking(
              numberOfMarkedVerseInSurah, surahIndexOfMarkedVerse),
          okButtonFunction: () {
            changeMarkedVerse(verseToMarkIndex);
            globalNavigatorKey.currentState?.pop();
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

  Future<void> showAlertAboutMarkedSurahPDFPage(String pageToMarkIndex) async {
    await executeHandler(() async {
      List<String> pageMarkInfo = markedSurahPDFPageIndex.split(' ');
      int surahIndexOfMarkedPage = int.parse(pageMarkInfo[0]),
          indexOfMarkedPage = int.parse(pageMarkInfo[1]);

      await _dialogService.showBookMarkAlertDialog(
          message: _localeProvider.isArabicChosen()
              ? "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في سورة ${Suras.arabicAuranSuras[surahIndexOfMarkedPage]}صفحة رقم $indexOfMarkedPage "
              : 'If you proceed, you\'re going to lose the old bookmark made in ${Suras.englishQuranSurahs[surahIndexOfMarkedPage]} surah page number $indexOfMarkedPage',
          okButtonFunction: () {
            changeMarkedSurahPDFPage(pageToMarkIndex);
            globalNavigatorKey.currentState?.pop();
          });
    },
        errorMessage: getIt
            .get<AppLocalizations>()
            .errorShowingAlertPDFPageMarkingDialog);
  }
}
