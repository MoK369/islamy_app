import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/providers/theme_provider.dart';
import 'package:islamy_app/presentation/core/themes/app_themes.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class VersesList extends StatefulWidget {
  final List<String> arList;
  final List<String> enList;
  final int surahIndex;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const VersesList(
      {super.key,
      required this.arList,
      required this.enList,
      required this.surahIndex,
      required this.itemPositionsListener,
      required this.itemScrollController});

  @override
  State<VersesList> createState() => _VersesListState();
}

class _VersesListState extends State<VersesList> {
  List<String> eachDoaLine = [], eachEnDoaLine = [];
  late SurahScreenProvider surahScreenProvider;
  late LocaleProvider localeProvider;
  late ThemeProvider themeProvider;
  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    surahScreenProvider = Provider.of<SurahScreenProvider>(context);
    localeProvider = LocaleProvider.get(context);
    theme = Theme.of(context);
    themeProvider = ThemeProvider.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      itemScrollController: widget.itemScrollController,
      itemPositionsListener: widget.itemPositionsListener,
      itemCount: (widget.arList.length == widget.enList.length) ||
              localeProvider.isArabicChosen()
          ? widget.arList.length + 1
          : 0,
      itemBuilder: (context, index) {
        int verseNumber = index + 1;
        String currentVerseIndex = '${widget.surahIndex} $verseNumber';
        return index > widget.arList.length - 1
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.surahIndex != 0 && index == 0)
                    Text(
                      textAlign: TextAlign.center,
                      "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم\n",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize:
                              surahScreenProvider.fontSizeOfSurahVerses + 5),
                    ),
                  SelectableText.rich(
                    textDirection: TextDirection.rtl,
                    TextSpan(children: [
                      TextSpan(
                        text: "${widget.arList[index]} ",
                        style: theme.textTheme.displayLarge!.copyWith(
                            height: 2,
                            fontSize:
                                surahScreenProvider.fontSizeOfSurahVerses),
                      ),
                      WidgetSpan(
                        baseline: TextBaseline.alphabetic,
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          child: widget.surahIndex == 114
                              ? Text(
                                  textScaler: const TextScaler.linear(1.0),
                                  textDirection: TextDirection.rtl,
                                  surahScreenProvider.markedVerseIndex ==
                                          currentVerseIndex
                                      ? "۞📖"
                                      : "۞",
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      fontSize: surahScreenProvider
                                              .fontSizeOfSurahVerses +
                                          15),
                                )
                              : Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          ImageIcon(
                                            AssetImage(
                                                AssetsPaths.ayatNumberIcon),
                                            color: themeProvider.isDarkEnabled()
                                                ? Themes.darkPrimaryColor
                                                : Colors.black,
                                            size: surahScreenProvider
                                                    .fontSizeOfSurahVerses +
                                                15,
                                          ),
                                          SizedBox(
                                            width: surahScreenProvider
                                                .fontSizeOfSurahVerses,
                                            height: surahScreenProvider
                                                .fontSizeOfSurahVerses,
                                            child: FittedBox(
                                              child: Text(
                                                "$verseNumber",
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                        fontSize:
                                                            surahScreenProvider
                                                                    .fontSizeOfSurahVerses -
                                                                10),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      if (surahScreenProvider
                                              .markedVerseIndex ==
                                          currentVerseIndex)
                                        Text("📖",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    fontSize: surahScreenProvider
                                                        .fontSizeOfSurahVerses))
                                    ],
                                  ),
                                ),
                          onLongPress: () {
                            surahScreenProvider.markedVerseIndex == ''
                                ? surahScreenProvider
                                    .changeMarkedVerse(currentVerseIndex)
                                : surahScreenProvider.markedVerseIndex ==
                                        currentVerseIndex
                                    ? surahScreenProvider.changeMarkedVerse('')
                                    : surahScreenProvider
                                        .showAlertAboutVersesMarking(
                                            theme, currentVerseIndex);
                          },
                        ),
                      )
                    ]),
                  ),
                ],
              );
      },
      separatorBuilder: (context, index) {
        return localeProvider.isArabicChosen() ||
                index > widget.enList.length - 1
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    textDirection: TextDirection.ltr,
                    widget.enList[index],
                    style: theme.textTheme.displayLarge!.copyWith(
                        fontFamily: GoogleFonts.notoSans().fontFamily,
                        height: 2,
                        fontSize: surahScreenProvider.fontSizeOfSurahVerses),
                  ),
                  Divider(
                    color: theme.textTheme.bodyMedium!.color!.withAlpha(125),
                    thickness: 1.5,
                  )
                ],
              );
      },
    );
  }
}
