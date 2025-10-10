import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/ads/start_io_ad_provider.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/providers/theme_provider.dart';
import 'package:islamy_app/presentation/core/routes/defined_routes.dart';
import 'package:islamy_app/presentation/core/routes/route_methods.dart';
import 'package:islamy_app/presentation/core/themes/app_themes.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/constants/quran_layout_constants.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/list_of_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/pages/text_page/view_model/surah_text_page_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/surah_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'quran_layout_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NavigatorObserver>(),
  MockSpec<MainScreenProvider>(),
  MockSpec<LocaleProvider>(),
  MockSpec<StartIoAdProvider>(),
  MockSpec<SurahScreenProvider>(),
  MockSpec<ThemeProvider>(),
  MockSpec<SurahTextPageViewModel>(),
])
void main() {
  group(
    "Testing the QuranLayout() Widget",
    () {
      late AppLocalizations appLocalizations;
      late MockNavigatorObserver navigatorObserver;
      late MockMainScreenProvider mainScreenProvider;
      late MockLocaleProvider localeProvider;
      late MockStartIoAdProvider startIoAdProvider;
      late MockSurahScreenProvider surahScreenProvider;
      late MockThemeProvider themeProvider;
      late MockSurahTextPageViewModel surahTextPageViewModel;
      setUpAll(
        () async {
          appLocalizations =
              await AppLocalizations.delegate.load(const Locale("ar"));
          navigatorObserver = MockNavigatorObserver();
          surahScreenProvider = MockSurahScreenProvider();
          getIt.registerFactory<SurahScreenProvider>(
            () => surahScreenProvider,
          );
          surahTextPageViewModel = MockSurahTextPageViewModel();
          getIt.registerFactory<SurahTextPageViewModel>(
            () => surahTextPageViewModel,
          );
        },
      );
      setUp(
        () {
          mainScreenProvider = MockMainScreenProvider();
          localeProvider = MockLocaleProvider();
          startIoAdProvider = MockStartIoAdProvider();
          themeProvider = MockThemeProvider();

          // basic arrange
          TextEditingController searchFieldController = TextEditingController();
          when(mainScreenProvider.searchFieldController)
              .thenReturn(searchFieldController);
          when(mainScreenProvider.getSurasListEnglishOrArabic())
              .thenReturn(Suras.arabicAuranSuras);
          when(mainScreenProvider.markedSurahIndex).thenReturn("");
        },
      );

      Widget buildWidget({String languageCode = 'ar'}) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<MainScreenProvider>(
              create: (context) => mainScreenProvider,
            ),
            ChangeNotifierProvider<LocaleProvider>(
              create: (context) => localeProvider,
            ),
            ChangeNotifierProvider<StartIoAdProvider>(
              create: (context) => startIoAdProvider,
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (context) => themeProvider,
            )
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: ThemeMode.light,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            locale: Locale(languageCode),
            onGenerateRoute: RouteMethods.onGenerateRoute,
            home: const Material(child: QuranLayout()),
            navigatorObservers: [navigatorObserver],
          ),
        );
      }

      group(
        "Testing the existence and appearance of items",
        () {
          testWidgets(
              'When the QuranLayout() widget is opened, expected items (widgets) should be rendered',
              (widgetTester) async {
            // arrange
            await widgetTester.pumpWidget(buildWidget());

            // act
            Finder quranIconHeader =
                find.byKey(const Key(QuranLayoutConstants.quranHeaderIconKey));
            Finder goToBookmarkedSurahButton = find.byKey(
                const Key(QuranLayoutConstants.goToBookmarkedSurahButtonKey));
            Finder searchField =
                find.byKey(const Key(QuranLayoutConstants.searchTextFieldKey));
            Finder upperDivider =
                find.byKey(const Key(QuranLayoutConstants.upperDividerKey));
            Finder lowerDivider =
                find.byKey(const Key(QuranLayoutConstants.lowerDividerKey));
            Finder numberOfSuraText =
                find.byKey(const Key(QuranLayoutConstants.numberOfSuraTextKey));
            Finder numberOfVersesText = find
                .byKey(const Key(QuranLayoutConstants.numberOfVersesTextKey));
            Finder surasList =
                find.byKey(const Key(QuranLayoutConstants.surasListKey));

            // assert
            expect(quranIconHeader, findsOneWidget);
            expect(goToBookmarkedSurahButton, findsNothing);
            expect(searchField, findsOneWidget);
            expect(upperDivider, findsOneWidget);
            expect(lowerDivider, findsOneWidget);
            expect(numberOfSuraText, findsOneWidget);
            expect(numberOfVersesText, findsOneWidget);
            expect(surasList, findsOneWidget);
          });
        },
      );
      group(
        "Testing the behavior of Search Field",
        () {
          testWidgets(
            "Testing that the expected Sura will appear when searching for its name in the search field",
            (widgetTester) async {
              // arrange
              const String surahName = "عبس";
              await widgetTester.pumpWidget(buildWidget());

              // act
              Finder searchField = find
                  .byKey(const Key(QuranLayoutConstants.searchTextFieldKey));
              await widgetTester.enterText(searchField, surahName);
              await widgetTester.pump();
              Finder searchedSura = find.widgetWithText(ListOfSuras, surahName);
              var surasList = widgetTester
                  .widgetList(
                      find.byKey(const Key(QuranLayoutConstants.suraItemKey)))
                  .toList();

              // assert
              expect(surasList.length, 1);
              expect(searchedSura, findsExactly(1));
            },
          );
          testWidgets(
            "Testing that there isn no Sura will appear when searching for a name that's not a sura name",
            (widgetTester) async {
              // arrange
              const String surahName = "ليس";
              await widgetTester.pumpWidget(buildWidget());
              // act

              Finder searchField = find
                  .byKey(const Key(QuranLayoutConstants.searchTextFieldKey));
              await widgetTester.enterText(searchField, surahName);
              await widgetTester.pump();
              Finder searchedSura = find.widgetWithText(ListOfSuras, surahName);
              var surasList = widgetTester
                  .widgetList(
                      find.byKey(const Key(QuranLayoutConstants.suraItemKey)))
                  .toList();

              // assert
              expect(surasList.length, 0);
              expect(searchedSura, findsExactly(0));
            },
          );
        },
      );
      group(
        "Testing the behavior of Sura Button",
        () {
          testWidgets(
            "Testing when clicking on a sura button, a navigation to sura screen will happen",
            (widgetTester) async {
              // arrange
              await widgetTester.pumpWidget(buildWidget());
              provideDummy<BaseViewState<List<List<String>>>>(
                  SuccessState<List<List<String>>>(data: [
                [""],
                [""]
              ]));
              when(surahScreenProvider.fontSizeOfSurahVerses).thenReturn(14);
              // act
              Finder surasButtons =
                  find.byKey(const Key(QuranLayoutConstants.suraItemKey));
              await widgetTester.tap(surasButtons.first);
              await widgetTester.pumpAndSettle();
              //await widgetTester.pump(const Duration(seconds: 2));
              Finder surasScreen = find.byType(SurahScreen);

              // assert
              expect(surasScreen, findsOneWidget);
              verify(navigatorObserver.didPush(argThat(
                predicate<Route>(
                  (route) {
                    return route.settings.name == DefinedRoutes.surahScreen;
                  },
                ),
              ), any))
                  .called(1);
            },
          );
        },
      );
    },
  );
}
