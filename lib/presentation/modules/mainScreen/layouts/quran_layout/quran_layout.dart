import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/list_of_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/search_text_field.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/surah_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';

class QuranLayout extends StatefulWidget {
  const QuranLayout({super.key});

  @override
  State<QuranLayout> createState() => _QuranLayoutState();
}

class _QuranLayoutState extends State<QuranLayout> {
  late MainScreenProvider mainScreenProvider;
  late ThemeData theme;
  List<String>? foundUser;
  late LocaleProvider localeProvider;

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
    Size size = MediaQuery.of(context).size;
    localeProvider = LocaleProvider.get(context);
    theme = Theme.of(context);
    foundUser ??= mainScreenProvider.getSurasListEnglishOrArabic();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/quran_header_icn.png',
            height: size.height * 0.19,
          ),
          SearchTextField(
            onChange: (value) {
              runFilter(value);
            },
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    //Expanded(child: VerticalDivider()),
                  ],
                ),
                Column(
                  children: [
                    const Divider(),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Center(
                                  child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              height: size.height * 0.05,
                              child: FittedBox(
                                child: Text(
                                    Locales.getTranslations(context)
                                        .numberOfVerses,
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ))),
                          Transform.scale(
                              scaleY: 1.4, child: const VerticalDivider()),
                          Expanded(
                              child: Center(
                                  child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SizedBox(
                              height: size.height * 0.05,
                              child: FittedBox(
                                child: Text(
                                  Locales.getTranslations(context).nameOfSura,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ))),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 0,
                    ),
                    ListOfSuras(
                      foundUser: foundUser!,
                      onClick: (index) async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (!context.mounted) return;
                        Navigator.pushNamed(context, SurahScreen.routeName,
                            arguments: SendSurahInfo(
                                surahIndex: mainScreenProvider
                                    .getSurasListEnglishOrArabic()
                                    .indexOf(foundUser![index]),
                                surahName: foundUser![index]));
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            clearSearchResults();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void clearSearchResults() async {
    setState(() {
      mainScreenProvider.searchFieldController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
      runFilter('');
    });
  }
}

class SendSurahInfo {
  int surahIndex;
  String surahName;

  SendSurahInfo({required this.surahIndex, required this.surahName});
}
