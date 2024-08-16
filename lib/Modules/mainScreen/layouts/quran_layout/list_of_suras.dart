import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';

class ListOfSuras extends StatelessWidget {
  final List<String> foundUser;
  final void Function(int) onClick;

  const ListOfSuras(
      {super.key, required this.foundUser, required this.onClick});

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    ThemeData theme = Theme.of(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    return Expanded(
      child: ListView.builder(
        itemCount: foundUser.length,
        itemBuilder: (context, indexOfFoundUserList) {
          String numberOfayas = Suras.ayaNumber[mainScreenProvider
              .getSurasListEnglishOrArabic()
              .indexOf(foundUser[indexOfFoundUserList])];
          return InkWell(
            onLongPress: () {
              surahToMark(localeProvider, indexOfFoundUserList) ==
                      mainScreenProvider.markedSurahIndex
                  ? mainScreenProvider.changeMarkedSurah('')
                  : mainScreenProvider.changeMarkedSurah(
                      surahToMark(localeProvider, indexOfFoundUserList));
            },
            onTap: () {
              onClick(indexOfFoundUserList);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (mainScreenProvider.markedSurahIndex != '') ...[
                      if (mainScreenProvider.markedSurahIndex ==
                          surahToMark(localeProvider, indexOfFoundUserList))
                        const Icon(
                          Icons.bookmark,
                          size: 30,
                        )
                    ],
                    Expanded(
                      child: Center(
                        child: Text(
                          numberOfayas,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: Center(
                        child: Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: FittedBox(
                    child: Text(
                      foundUser[indexOfFoundUserList],
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ))),
              ],
            ),
          );
        },
      ),
    );
  }

  String surahToMark(LocaleProvider localeProvider, int index) {
    return localeProvider.isArabicChosen()
        ? '${Suras.arabicAuranSuras.indexOf(foundUser[index])}'
        : '${Suras.englishQuranSurahs.indexOf(foundUser[index])}';
  }
}
