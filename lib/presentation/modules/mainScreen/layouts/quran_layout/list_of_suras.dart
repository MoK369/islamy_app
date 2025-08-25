import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ListOfSuras extends StatelessWidget {
  final List<String> foundUser;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  final void Function(int) onClick;

  const ListOfSuras({super.key,
    required this.foundUser,
    required this.onClick,
    required this.itemScrollController,
    required this.itemPositionsListener});

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    ThemeData theme = Theme.of(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    return Expanded(
      child: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: foundUser.length + 1,
        itemBuilder: (context, indexOfFoundUserList) {
          String numberOfAyas = indexOfFoundUserList == foundUser.length
              ? ''
              : Suras.ayaNumber[mainScreenProvider
                  .getSurasListEnglishOrArabic()
                  .indexOf(foundUser[indexOfFoundUserList])];
          return indexOfFoundUserList == foundUser.length
              ? const SizedBox(
                  height: 45,
                )
              : InkWell(
                  splashColor: Colors.transparent,
                  onLongPress: () {
                    mainScreenProvider.markedSurahIndex == ''
                        ? mainScreenProvider.changeMarkedSurah(
                            currentSurahIndex(
                                localeProvider, indexOfFoundUserList))
                        : currentSurahIndex(
                                    localeProvider, indexOfFoundUserList) ==
                                mainScreenProvider.markedSurahIndex
                            ? mainScreenProvider.changeMarkedSurah('')
                            : mainScreenProvider.showAlertAboutSurasMarking(
                                context,
                                theme,
                                currentSurahIndex(
                                    localeProvider, indexOfFoundUserList));
                  },
                  onTap: () {
                    onClick(indexOfFoundUserList);
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (indexOfFoundUserList != 114) ...[
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: mainScreenProvider.markedSurahIndex ==
                                    currentSurahIndex(
                                        localeProvider, indexOfFoundUserList),
                                child: const Icon(
                                  Icons.bookmark,
                                  size: 30,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    numberOfAyas,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                            ],
                          )),
                          Transform.scale(
                              scaleY: 1, child: const VerticalDivider()),
                        ] else ...[
                          Visibility(
                            visible: mainScreenProvider.markedSurahIndex ==
                                currentSurahIndex(
                                    localeProvider, indexOfFoundUserList),
                            child: const Icon(
                              Icons.bookmark,
                              size: 30,
                            ),
                          )
                        ],
                        Expanded(
                            child: Center(
                                child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: FittedBox(
                            child: Text(
                              foundUser[indexOfFoundUserList],
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ))),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  String currentSurahIndex(LocaleProvider localeProvider, int index) {
    return localeProvider.isArabicChosen()
        ? '${Suras.arabicAuranSuras.indexOf(foundUser[index])}'
        : '${Suras.englishQuranSurahs.indexOf(foundUser[index])}';
  }
}
