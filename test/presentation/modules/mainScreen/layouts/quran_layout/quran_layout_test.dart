import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/themes/app_themes.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/constants/quran_layout_constants.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/list_of_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'quran_layout_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NavigatorObserver>(),
  MockSpec<MainScreenProvider>(),
  MockSpec<LocaleProvider>()
])
void main() {
  group(
    "Testing the QuranLayout() Widget",
    () {
      late AppLocalizations appLocalizations;
      late MockNavigatorObserver navigatorObserver;
      late MockMainScreenProvider mainScreenProvider;
      late MockLocaleProvider localeProvider;
      setUpAll(
        () async {
          appLocalizations =
              await AppLocalizations.delegate.load(const Locale("ar"));
          navigatorObserver = MockNavigatorObserver();
        },
      );
      setUp(
        () {
          mainScreenProvider = MockMainScreenProvider();
          localeProvider = MockLocaleProvider();
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
            )
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: ThemeMode.light,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            locale: Locale(languageCode),
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
            TextEditingController searchFieldController =
                TextEditingController();
            when(mainScreenProvider.searchFieldController)
                .thenReturn(searchFieldController);
            when(mainScreenProvider.markedSurahIndex).thenReturn("");
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
              TextEditingController searchFieldController =
                  TextEditingController();
              when(mainScreenProvider.searchFieldController)
                  .thenReturn(searchFieldController);
              when(mainScreenProvider.getSurasListEnglishOrArabic())
                  .thenReturn(Suras.arabicAuranSuras);

              // act
              const String surahName = "عبس";
              await widgetTester.pumpWidget(buildWidget());
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
        },
      );
    },
  );
}
