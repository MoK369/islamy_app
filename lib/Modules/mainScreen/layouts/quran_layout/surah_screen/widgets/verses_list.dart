import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/core/providers/locale_provider.dart';

import '../../../../provider/main_screen_provider.dart';

class VersesList extends StatefulWidget {
  final SendSurahInfo args;

  const VersesList({super.key, required this.args});

  @override
  State<VersesList> createState() => _VersesListState();
}

class _VersesListState extends State<VersesList> {
  List<String> surahVerses = [],
      enSurahVerses = [],
      eachDoaLine = [],
      eachEnDoaLine = [];
  late MainScreenProvider mainScreenProvider;
  late LocaleProvider localeProvider;
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    mainScreenProvider = MainScreenProvider.get(context);
    localeProvider = LocaleProvider.get(context);
    theme = Theme.of(context);
    if (widget.args.surahIndex == 114 && eachDoaLine.isEmpty) {
      readDoa();
      if (!localeProvider.isArabicChosen()) {
        readEnDoa();
      }
    } else if (widget.args.surahIndex != 114 && surahVerses.isEmpty) {
      readSurah();
      if (!localeProvider.isArabicChosen()) {
        readEnSurah();
      }
    }
    return Expanded(
        child: surahVerses.isEmpty && eachDoaLine.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.indicatorColor,
                ),
              )
            : widget.args.surahIndex == 114
                ? versesList(eachDoaLine, eachEnDoaLine)
                : versesList(surahVerses, enSurahVerses));
  }

  Widget versesList(List<String> arList, List<String> enList) {
    return ListView.separated(
      itemCount:
          (arList.length == enList.length) || localeProvider.isArabicChosen()
              ? arList.length + 1
              : 0,
      itemBuilder: (context, index) {
        int verseNumber = index + 1;
        String currentVerseIndex = '${widget.args.surahIndex} $verseNumber';
        return index > arList.length - 1
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.args.surahIndex != 0 && index == 0)
                    Text(
                      textAlign: TextAlign.center,
                      "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم\n",
                      style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize:
                              mainScreenProvider.fontSizeOfSurahVerses + 5),
                    ),
                  RichText(
                      textDirection: TextDirection.rtl,
                      text: TextSpan(children: [
                        TextSpan(
                          text: arList[index],
                          style: theme.textTheme.displayLarge!.copyWith(
                              height: 2,
                              fontSize:
                                  mainScreenProvider.fontSizeOfSurahVerses),
                        ),
                        WidgetSpan(
                          baseline: TextBaseline.alphabetic,
                          alignment: PlaceholderAlignment.baseline,
                          child: GestureDetector(
                            child: Text(
                              textScaler: const TextScaler.linear(1.0),
                              textDirection: TextDirection.rtl,
                              mainScreenProvider.markedVerseIndex ==
                                      currentVerseIndex
                                  ? widget.args.surahIndex == 114
                                      ? "۞📖"
                                      : " $verseNumber📖 "
                                  : widget.args.surahIndex == 114
                                      ? "۞"
                                      : ' $verseNumber ',
                              style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize:
                                      mainScreenProvider.fontSizeOfSurahVerses +
                                          15),
                            ),
                            onLongPress: () {
                              mainScreenProvider.markedVerseIndex == ''
                                  ? mainScreenProvider
                                      .changeMarkedVerse(currentVerseIndex)
                                  : mainScreenProvider.markedVerseIndex ==
                                          currentVerseIndex
                                      ? mainScreenProvider.changeMarkedVerse('')
                                      : mainScreenProvider
                                          .showAlertAboutVersesMarking(context,
                                              theme, currentVerseIndex);
                            },
                          ),
                        )
                      ])),
                ],
              );
      },
      separatorBuilder: (context, index) {
        return localeProvider.isArabicChosen() || index > enList.length - 1
            ? const SizedBox(
                width: 0,
                height: 0,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textDirection: TextDirection.ltr,
                    enList[index],
                    style: theme.textTheme.displayLarge!.copyWith(
                        fontFamily: GoogleFonts.notoSans().fontFamily,
                        height: 2,
                        fontSize: mainScreenProvider.fontSizeOfSurahVerses),
                  ),
                  Divider(
                    color: theme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                    thickness: 1.5,
                  )
                ],
              );
      },
    );
  }

  void readSurah() async {
    String surah = await rootBundle.loadString(
        'assets/suras/suras_text/${widget.args.surahIndex + 1}.txt');
    surahVerses = surah.trim().split('\n');

    setState(() {
      surahVerses = surahVerses.map((e) => e = e.trim()).toList();
    });
  }

  void readEnSurah() async {
    String enSurah = await rootBundle.loadString(
        'assets/suras/suras_text/${widget.args.surahIndex + 1}_en.txt');
    enSurahVerses = enSurah.trim().split('\n');
    setState(() {
      enSurahVerses = enSurahVerses.map((e) => e = e.trim()).toList();
    });
  }

  void readDoa() async {
    String doa = await rootBundle
        .loadString("assets/doas/doas_text/doa_completing_the_quran.txt");
    eachDoaLine = doa.trim().split("۞");
    setState(() {
      eachDoaLine = eachDoaLine.map(
        (e) {
          return e = e.trim();
        },
      ).toList();
    });
  }

  void readEnDoa() async {
    String doa = await rootBundle
        .loadString("assets/doas/doas_text/doa_completing_the_quran_en.txt");
    eachEnDoaLine = doa.trim().split("۞");
    setState(() {
      eachEnDoaLine = eachEnDoaLine.map(
        (e) {
          return e = e.trim();
        },
      ).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    rootBundle.clear();
  }
}
