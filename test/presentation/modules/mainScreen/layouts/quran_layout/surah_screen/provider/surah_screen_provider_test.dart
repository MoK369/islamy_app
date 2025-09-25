import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/utils/dialog_service/dialog_service.dart';
import 'package:islamy_app/presentation/core/utils/handlers/system_ui_handler/system_ui_mode_handler.dart';
import 'package:islamy_app/presentation/core/widgets/toast_widget.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'surah_screen_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferences>(),
  MockSpec<LocaleProvider>(),
  MockSpec<FToast>(),
  MockSpec<SystemUiModeHandler>(),
  MockSpec<DialogService>()
])
void main() {
  group(
    "Testing SurahScreenProvider",
    () {
      late SurahScreenProvider surahScreenProvider;
      late MockSharedPreferences sharedPreferences;
      late MockLocaleProvider localeProvider;
      late AppLocalizations appLocalizations;
      late MockFToast mockFToast;
      late MockSystemUiModeHandler mockSystemUiModeHandler;
      late MockDialogService mockDialogService;
      final Exception sharedPreferencesException =
          Exception("error getting or saving a value using sharedPreferences");
      setUpAll(
        () async {
          mockSystemUiModeHandler = MockSystemUiModeHandler();
          mockDialogService = MockDialogService();

          mockFToast = MockFToast();
          getIt.registerLazySingleton<FToast>(
            () => mockFToast,
          );

          appLocalizations =
              await AppLocalizations.delegate.load(const Locale("ar"));
          getIt.registerLazySingleton(
            () => appLocalizations,
          );
        },
      );
      setUp(
        () async {
          sharedPreferences = MockSharedPreferences();
          localeProvider = MockLocaleProvider();
          surahScreenProvider = SurahScreenProvider(sharedPreferences,
              localeProvider, mockSystemUiModeHandler, mockDialogService);
        },
      );

      VerificationResult verifyShowToastFunction(
          String appLocalizationErrorMessage) {
        return verify(mockFToast.showToast(
            fadeDuration: anyNamed("fadeDuration"),
            gravity: anyNamed("gravity"),
            ignorePointer: anyNamed("ignorePointer"),
            isDismissible: anyNamed("isDismissible"),
            positionedToastBuilder: anyNamed("positionedToastBuilder"),
            toastDuration: anyNamed("toastDuration"),
            child: argThat(
                predicate<ToastWidget>(
                  (widget) => widget.text == appLocalizationErrorMessage,
                ),
                named: "child")));
      }

      group(
        "Testing getSurahScreenData() method",
        () {
          test(
            "testing the getSurahScreenData() method if it would successfully initialize the surah dependencies",
            () async {
              // arrange
              when(sharedPreferences.getDouble(argThat(
                      equals(SurahScreenProvider.fontSizeOfSurahVersesKey))))
                  .thenReturn(22);
              when(sharedPreferences.getString(
                      argThat(equals(SurahScreenProvider.markedVerseKey))))
                  .thenReturn("0 2");
              when(sharedPreferences.getString(argThat(
                      equals(SurahScreenProvider.markedSurahPDFPageKey))))
                  .thenReturn("0 1");
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider.getSurahScreenData();
              // assert
              expect(notifyCounts, 1);
              expect(surahScreenProvider.fontSizeOfSurahVerses, 22);
              expect(surahScreenProvider.markedVerseIndex, "0 2");
              expect(surahScreenProvider.markedSurahPDFPageIndex, "0 1");
              surahScreenProvider.dispose();
            },
          );
          test(
            "testing the getSurahScreenData() method if it would initialize the surah dependencies but a failure happens",
            () async {
              // arrange
              when(sharedPreferences.getDouble(argThat(
                      equals(SurahScreenProvider.fontSizeOfSurahVersesKey))))
                  .thenReturn(22);
              when(sharedPreferences.getString(
                      argThat(equals(SurahScreenProvider.markedVerseKey))))
                  .thenReturn("0 2");
              when(sharedPreferences.getString(argThat(
                      equals(SurahScreenProvider.markedSurahPDFPageKey))))
                  .thenThrow(sharedPreferencesException);
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider.getSurahScreenData();
              // assert
              expect(notifyCounts, 0);
              expect(surahScreenProvider.fontSizeOfSurahVerses, 22);
              expect(surahScreenProvider.markedVerseIndex, "0 2");
              expect(surahScreenProvider.markedSurahPDFPageIndex, "");

              verifyShowToastFunction(appLocalizations.errorLoadingSavedData)
                  .called(1);
            },
          );
        },
      );
      group(
        "Testing changeFontSizeOfSurahVerses() method",
        () {
          test(
            "testing the changeFontSizeOfSurahVerses() method if it would successfully change the surah verses font size value",
            () async {
              // arrange
              const double fontSize = 25.0;
              when(sharedPreferences.setDouble(
                      argThat(
                          equals(SurahScreenProvider.fontSizeOfSurahVersesKey)),
                      argThat(equals(fontSize))))
                  .thenAnswer(
                (realInvocation) => Future.value(true),
              );
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider.changeFontSizeOfSurahVerses(fontSize);
              // assert
              verify(sharedPreferences.setDouble(
                      argThat(
                          equals(SurahScreenProvider.fontSizeOfSurahVersesKey)),
                      argThat(equals(fontSize))))
                  .called(1);
              expect(notifyCounts, 1);
              expect(surahScreenProvider.fontSizeOfSurahVerses, fontSize);
            },
          );
          test(
            "testing the changeFontSizeOfSurahVerses() method if it would change the surah verses font size value but a failure happens",
            () async {
              // arrange
              const fontSize = 25.0;
              when(sharedPreferences.setDouble(
                      argThat(
                          equals(SurahScreenProvider.fontSizeOfSurahVersesKey)),
                      argThat(equals(fontSize))))
                  .thenThrow(sharedPreferencesException);
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider.changeFontSizeOfSurahVerses(fontSize);
              // assert
              expect(notifyCounts, 1);
              expect(surahScreenProvider.fontSizeOfSurahVerses, fontSize);
              verify(sharedPreferences.setDouble(
                      argThat(
                          equals(SurahScreenProvider.fontSizeOfSurahVersesKey)),
                      argThat(equals(fontSize))))
                  .called(1);
              verifyShowToastFunction(appLocalizations.errorSavingFontSize)
                  .called(1);
            },
          );
        },
      );
      group(
        "Testing changeMarkedVerse() method",
        () {
          test(
            "testing the changeMarkedVerse() method if it would successfully change the marked verse index",
            () async {
              // arrange
              const String newVerseIndex = "0 2";
              when(sharedPreferences.setString(
                      argThat(equals(SurahScreenProvider.markedVerseKey)),
                      argThat(equals(newVerseIndex))))
                  .thenAnswer(
                (realInvocation) => Future.value(true),
              );
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider.changeMarkedVerse(newVerseIndex);
              // assert
              verify(sharedPreferences.setString(
                      argThat(equals(SurahScreenProvider.markedVerseKey)),
                      argThat(equals(newVerseIndex))))
                  .called(1);
              expect(notifyCounts, 1);
              expect(surahScreenProvider.markedVerseIndex, newVerseIndex);
            },
          );
          test(
            "testing the changeMarkedVerse() method if it would change the marked verse index but a failure happens",
            () async {
              // arrange
              const String newVerseIndex = "0 2";
              when(sharedPreferences.setString(
                      argThat(equals(SurahScreenProvider.markedVerseKey)),
                      argThat(equals(newVerseIndex))))
                  .thenThrow(sharedPreferencesException);
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider.changeMarkedVerse(newVerseIndex);
              // assert
              expect(notifyCounts, 1);
              expect(surahScreenProvider.markedVerseIndex, newVerseIndex);
              verify(sharedPreferences.setString(
                      argThat(equals(SurahScreenProvider.markedVerseKey)),
                      argThat(equals(newVerseIndex))))
                  .called(1);
              verifyShowToastFunction(
                      appLocalizations.errorSavingNewMarkedVerse)
                  .called(1);
            },
          );
        },
      );
      group(
        "Testing changeMarkedSurahPDFPage() method",
        () {
          test(
            "testing the changeMarkedSurahPDFPage() method if it would successfully change the marked PDF Page index",
            () async {
              // arrange
              const String newPdfPageIndex = "0 1";
              when(sharedPreferences.setString(
                      argThat(
                          equals(SurahScreenProvider.markedSurahPDFPageKey)),
                      argThat(equals(newPdfPageIndex))))
                  .thenAnswer(
                (realInvocation) => Future.value(true),
              );
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .changeMarkedSurahPDFPage(newPdfPageIndex);
              // assert
              verify(sharedPreferences.setString(
                      argThat(
                          equals(SurahScreenProvider.markedSurahPDFPageKey)),
                      argThat(equals(newPdfPageIndex))))
                  .called(1);
              expect(notifyCounts, 1);
              expect(
                  surahScreenProvider.markedSurahPDFPageIndex, newPdfPageIndex);
            },
          );
          test(
            "testing the changeMarkedSurahPDFPage() method if it would change the marked PDF Page index but a failure happens",
            () async {
              // arrange
              const String newPdfPageIndex = "0 1";
              when(sharedPreferences.setString(
                      argThat(
                          equals(SurahScreenProvider.markedSurahPDFPageKey)),
                      argThat(equals(newPdfPageIndex))))
                  .thenThrow(sharedPreferencesException);
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .changeMarkedSurahPDFPage(newPdfPageIndex);
              // assert
              expect(notifyCounts, 1);
              expect(
                  surahScreenProvider.markedSurahPDFPageIndex, newPdfPageIndex);
              verify(sharedPreferences.setString(
                      argThat(
                          equals(SurahScreenProvider.markedSurahPDFPageKey)),
                      argThat(equals(newPdfPageIndex))))
                  .called(1);
              verifyShowToastFunction(
                      appLocalizations.errorSavingNewMarkedPDFPage)
                  .called(1);
            },
          );
        },
      );
      group(
        "Testing changeSurahOrHadeethScreenAppBarStatus() method",
        () {
          test(
            "testing the changeSurahOrHadeethScreenAppBarStatus() method if it would successfully hide the system status and navigation Bars",
            () async {
              // arrange
              bool newVisibilityValue = false;
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .changeSurahOrHadeethScreenAppBarStatus(newVisibilityValue);
              // assert
              verify(mockSystemUiModeHandler.setEnabledSystemUIMode(
                      argThat(equals(SystemUiMode.immersive))))
                  .called(1);
              expect(notifyCounts, 1);
              expect(surahScreenProvider.isSurahOrHadeethScreenAppBarVisible,
                  newVisibilityValue);
            },
          );
          test(
            "testing the changeSurahOrHadeethScreenAppBarStatus() method if it would successfully show the system status and navigation Bars",
            () async {
              // arrange
              bool newVisibilityValue = true;
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .changeSurahOrHadeethScreenAppBarStatus(newVisibilityValue);
              // assert
              verify(mockSystemUiModeHandler.setEnabledSystemUIMode(
                      argThat(equals(SystemUiMode.edgeToEdge))))
                  .called(1);
              expect(notifyCounts, 1);
              expect(surahScreenProvider.isSurahOrHadeethScreenAppBarVisible,
                  newVisibilityValue);
            },
          );
          test(
            "testing the changeSurahOrHadeethScreenAppBarStatus() method if it a failure happens when attempting to change the visibility of the system bars",
            () async {
              // arrange
              final Exception changeSystemBarStatusException = Exception(
                  "error when attempting to change the visibility of the system bars");
              bool newVisibilityValue = false;
              when(mockSystemUiModeHandler.setEnabledSystemUIMode(
                      argThat(equals(SystemUiMode.immersive))))
                  .thenThrow(changeSystemBarStatusException);
              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .changeSurahOrHadeethScreenAppBarStatus(newVisibilityValue);
              // assert
              expect(notifyCounts, 0);
              expect(surahScreenProvider.isSurahOrHadeethScreenAppBarVisible,
                  newVisibilityValue);
              verify(mockSystemUiModeHandler.setEnabledSystemUIMode(
                      argThat(equals(SystemUiMode.immersive))))
                  .called(1);
              verifyShowToastFunction(
                      appLocalizations.errorChangingAppBarVisibility)
                  .called(1);
            },
          );
        },
      );
      group(
        "Testing showAlertAboutVersesMarking() method",
        () {
          test(
            "testing the showAlertAboutVersesMarking() method if it would successfully show the alert dialog with Arabic alert message and change the marked verse when user clicks on ok button",
            () async {
              // arrange
              const String newVerseIndex = "1 2";
              surahScreenProvider.markedVerseIndex = "0 2";
              final List<String> indexes =
                  surahScreenProvider.markedVerseIndex.split(" ");
              final int surahIndexOfMarkedVerse = int.parse(indexes[0]);
              final int numberOfMarkedVerseInSurah = int.parse(indexes[1]);
              late VoidCallback onOkFunctionCapture;
              final String arAlertMessage =
                  "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في ${(surahIndexOfMarkedVerse == 114) ? "${Suras.arabicAuranSuras[surahIndexOfMarkedVerse]} الفقرة رقم $numberOfMarkedVerseInSurah" : " سورة ${Suras.arabicAuranSuras[surahIndexOfMarkedVerse]} الآية رقم $numberOfMarkedVerseInSurah"}";
              when(localeProvider.isArabicChosen()).thenReturn(true);
              when(mockDialogService.showBookMarkAlertDialog(
                      message: anyNamed("message"),
                      okButtonFunction: anyNamed("okButtonFunction")))
                  .thenAnswer(
                (Invocation realInvocation) {
                  onOkFunctionCapture = realInvocation
                      .namedArguments[const Symbol("okButtonFunction")];
                  return Future.value();
                },
              );
              WidgetsFlutterBinding.ensureInitialized();

              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .showAlertAboutVersesMarking(newVerseIndex);
              // assert
              verify(mockDialogService.showBookMarkAlertDialog(
                      message: arAlertMessage,
                      okButtonFunction: anyNamed("okButtonFunction")))
                  .called(1);

              expect(notifyCounts, 0);

              /// When user clicks on Ok Button: ==================
              // arrange
              when(sharedPreferences.setString(
                      argThat(equals(SurahScreenProvider.markedVerseKey)),
                      argThat(equals(newVerseIndex))))
                  .thenAnswer(
                (realInvocation) => Future.value(true),
              );

              // act
              onOkFunctionCapture();
              // assert
              verify(sharedPreferences.setString(
                      argThat(equals(SurahScreenProvider.markedVerseKey)),
                      argThat(equals(newVerseIndex))))
                  .called(1);
              expect(notifyCounts, 1);
              expect(surahScreenProvider.markedVerseIndex, newVerseIndex);
            },
          );
          test(
            "testing the showAlertAboutVersesMarking() method if it would successfully show the alert dialog with English alert message",
            () async {
              // arrange
              const String newVerseIndex = "1 2";
              surahScreenProvider.markedVerseIndex = "0 2";
              final List<String> indexes =
                  surahScreenProvider.markedVerseIndex.split(" ");
              final int surahIndexOfMarkedVerse = int.parse(indexes[0]);
              final int numberOfMarkedVerseInSurah = int.parse(indexes[1]);
              final String enAlertMessage =
                  "If you proceed, you're going to lose the old bookmark made in ${(surahIndexOfMarkedVerse == 114) ? "${Suras.englishQuranSurahs[surahIndexOfMarkedVerse]} the paragraph number $numberOfMarkedVerseInSurah" : "${Suras.englishQuranSurahs[surahIndexOfMarkedVerse]} surah the verse number $numberOfMarkedVerseInSurah"}";
              when(localeProvider.isArabicChosen()).thenReturn(false);
              WidgetsFlutterBinding.ensureInitialized();

              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .showAlertAboutVersesMarking(newVerseIndex);
              // assert
              verify(mockDialogService.showBookMarkAlertDialog(
                      message: enAlertMessage,
                      okButtonFunction: anyNamed("okButtonFunction")))
                  .called(1);

              expect(notifyCounts, 0);
            },
          );
          test(
            "testing the showAlertAboutVersesMarking() method, if a failure happens when showing the alert dialog",
            () async {
              // arrange
              const String newVerseIndex = "1 2";
              //surahScreenProvider.markedVerseIndex = "0 2";

              when(localeProvider.isArabicChosen()).thenReturn(false);
              WidgetsFlutterBinding.ensureInitialized();

              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .showAlertAboutVersesMarking(newVerseIndex);
              // assert
              verifyShowToastFunction(
                      appLocalizations.errorShowingAlertVersesMarkingDialog)
                  .called(1);

              expect(notifyCounts, 0);
            },
          );
        },
      );
      group(
        "Testing showAlertAboutMarkedSurahPDFPage() method",
        () {
          test(
            "testing the showAlertAboutMarkedSurahPDFPage() method if it would successfully show the alert dialog with Arabic alert message and change the marked verse when user clicks on ok button",
            () async {
              // arrange
              const String newPDFPageIndex = "1 2";
              surahScreenProvider.markedSurahPDFPageIndex = "0 1";
              final List<String> indexes =
                  surahScreenProvider.markedSurahPDFPageIndex.split(" ");
              final int surahIndexOfMarkedPage = int.parse(indexes[0]);
              final int indexOfMarkedPage = int.parse(indexes[1]);
              late VoidCallback onOkFunctionCapture;
              final String arAlertMessage =
                  "إذا تابعت، سوف تفقد العلامة المرجعية القديمة التي تم وضعها في سورة ${Suras.arabicAuranSuras[surahIndexOfMarkedPage]}صفحة رقم $indexOfMarkedPage ";
              when(localeProvider.isArabicChosen()).thenReturn(true);
              when(mockDialogService.showBookMarkAlertDialog(
                      message: anyNamed("message"),
                      okButtonFunction: anyNamed("okButtonFunction")))
                  .thenAnswer(
                (Invocation realInvocation) {
                  onOkFunctionCapture = realInvocation
                      .namedArguments[const Symbol("okButtonFunction")];
                  return Future.value();
                },
              );
              WidgetsFlutterBinding.ensureInitialized();

              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .showAlertAboutMarkedSurahPDFPage(newPDFPageIndex);
              // assert
              verify(mockDialogService.showBookMarkAlertDialog(
                      message: arAlertMessage,
                      okButtonFunction: anyNamed("okButtonFunction")))
                  .called(1);

              expect(notifyCounts, 0);

              /// When user clicks on Ok Button: ==================
              // arrange
              when(sharedPreferences.setString(
                      argThat(
                          equals(SurahScreenProvider.markedSurahPDFPageKey)),
                      argThat(equals(newPDFPageIndex))))
                  .thenAnswer(
                (realInvocation) => Future.value(true),
              );

              // act
              onOkFunctionCapture();
              // assert
              verify(sharedPreferences.setString(
                      argThat(
                          equals(SurahScreenProvider.markedSurahPDFPageKey)),
                      argThat(equals(newPDFPageIndex))))
                  .called(1);
              expect(notifyCounts, 1);
              expect(
                  surahScreenProvider.markedSurahPDFPageIndex, newPDFPageIndex);
            },
          );
          test(
            "testing the showAlertAboutMarkedSurahPDFPage() method if it would successfully show the alert dialog with English alert message",
            () async {
              // arrange
              const String newPDFPageIndex = "1 2";
              surahScreenProvider.markedSurahPDFPageIndex = "0 1";
              final List<String> indexes =
                  surahScreenProvider.markedSurahPDFPageIndex.split(" ");
              final int surahIndexOfMarkedPage = int.parse(indexes[0]);
              final int indexOfMarkedPage = int.parse(indexes[1]);
              final String enAlertMessage =
                  'If you proceed, you\'re going to lose the old bookmark made in ${Suras.englishQuranSurahs[surahIndexOfMarkedPage]} surah page number $indexOfMarkedPage';
              when(localeProvider.isArabicChosen()).thenReturn(false);
              WidgetsFlutterBinding.ensureInitialized();

              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .showAlertAboutMarkedSurahPDFPage(newPDFPageIndex);
              // assert
              verify(mockDialogService.showBookMarkAlertDialog(
                      message: enAlertMessage,
                      okButtonFunction: anyNamed("okButtonFunction")))
                  .called(1);

              expect(notifyCounts, 0);
            },
          );
          test(
            "testing the showAlertAboutMarkedSurahPDFPage() method, if a failure happens when showing the alert dialog",
            () async {
              // arrange
              const String newPDFPageIndex = "1 2";
              //surahScreenProvider.markedVerseIndex = "0 2";
              when(localeProvider.isArabicChosen()).thenReturn(false);
              WidgetsFlutterBinding.ensureInitialized();

              // act
              int notifyCounts = 0;
              surahScreenProvider.addListener(
                () {
                  notifyCounts++;
                },
              );
              await surahScreenProvider
                  .showAlertAboutMarkedSurahPDFPage(newPDFPageIndex);
              // assert
              verifyShowToastFunction(
                      appLocalizations.errorShowingAlertPDFPageMarkingDialog)
                  .called(1);

              expect(notifyCounts, 0);
            },
          );
        },
      );
    },
  );
}
