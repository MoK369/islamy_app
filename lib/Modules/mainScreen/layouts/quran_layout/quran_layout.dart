import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/list_of_suras.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/search_text_field.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/surah_screen.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamic_app/core/app_locals/locales.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';

class QuranLayout extends StatefulWidget {
  const QuranLayout({super.key});

  @override
  State<QuranLayout> createState() => QuranLayoutState();
}

class QuranLayoutState extends State<QuranLayout> {
  late MainScreenProvider mainScreenProvider;
  late ThemeData theme;
  List<String>? foundUser;
  late LocaleProvider localeProvider;
  static TextEditingController searchFieldController = TextEditingController();

  void runFilter(String enteredKeyWord) {
    List<String> results = [];
    if (enteredKeyWord.isEmpty) {
      results = mainScreenProvider.getSurasListEnglishOrArabic();
    } else {
      results = mainScreenProvider
          .getSurasListEnglishOrArabic()
          .where((element) =>
              element.toLowerCase().contains(enteredKeyWord.toLowerCase()))
          .toList();
    }
    setState(() {
      foundUser = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    mainScreenProvider = MainScreenProvider.get(context);
    localeProvider = LocaleProvider.get(context);
    theme = Theme.of(context);
    foundUser ??= mainScreenProvider.getSurasListEnglishOrArabic();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/icons/quran_header_icn.png',
          height: mainScreenProvider.mainScreenSize.height * 0.2,
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const VerticalDivider(indent: 70),
              Column(
                children: [
                  SearchTextField(
                    onChange: (value) {
                      runFilter(value);
                    },
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Center(
                              child: Padding(
                        padding: const EdgeInsets.only(left: 3, right: 3),
                        child: FittedBox(
                          child: Text(
                              Locales.getTranslations(context).numberOfVerses,
                              style: theme.textTheme.titleSmall),
                        ),
                      ))),
                      Expanded(
                          child: Center(
                              child: FittedBox(
                        child: Text(
                          Locales.getTranslations(context).nameOfSura,
                        style: theme.textTheme.titleSmall,
                        ),
                      ))),
                    ],
                  ),
                  const Divider(),
                  ListOfSuras(
                    foundUser: foundUser!,
                    onClick: (index) {
                      Navigator.pushNamed(context, SurahScreen.routeName,
                          arguments: Send(
                              surahIndex: mainScreenProvider
                                  .getSurasListEnglishOrArabic()
                                  .indexOf(foundUser![index]),
                              surahName: foundUser![index]));
                      clearSearchResults();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void clearSearchResults() async {
    searchFieldController.clear();
    FocusScope.of(context).unfocus();
    runFilter('');
  }
}

class Send {
  int surahIndex;
  String surahName;

  Send({required this.surahIndex, required this.surahName});
}
