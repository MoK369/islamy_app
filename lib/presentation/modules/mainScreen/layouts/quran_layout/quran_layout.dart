import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/list_of_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/search_text_field.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/surah_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Image.asset(
              AssetsPaths.quranHeaderIcon,
              height: size.height * 0.19,
            ),
            if (mainScreenProvider.markedSurahIndex.isNotEmpty)
              Positioned(
                left: localeProvider.isArabicChosen() ? null : 0,
                right: localeProvider.isArabicChosen() ? 0 : null,
                child: Transform.flip(
                  flipX: localeProvider.isArabicChosen(),
                  child: IconButton(
                      onPressed: () async {
                        await itemScrollController.scrollTo(
                            index:
                                int.parse(mainScreenProvider.markedSurahIndex),
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.flag)),
                ),
              )
          ],
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
                  Row(
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
                                Locales.getTranslations(context).numberOfVerses,
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
                  const Divider(
                    height: 0,
                  ),
                  ListOfSuras(
                    itemScrollController: itemScrollController,
                    itemPositionsListener: itemPositionsListener,
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
