import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/core/providers/locale_provider.dart';

import '../../../../../../core/defined_fonts/defined_font_families.dart';
import '../../../../provider/main_screen_provider.dart';

class VersesList extends StatefulWidget {
  final SendSurahInfo args;

  const VersesList({super.key, required this.args});

  @override
  State<VersesList> createState() => _VersesListState();
}

class _VersesListState extends State<VersesList> {
  List<String> surahVerses = [];
  List<String> enSurahVerses = [];
  late MainScreenProvider mainScreenProvider;
  late LocaleProvider localeProvider;
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    mainScreenProvider = MainScreenProvider.get(context);
    localeProvider = LocaleProvider.get(context);
    theme = Theme.of(context);
    if (surahVerses.isEmpty) {
      readSurah();
      if (!localeProvider.isArabicChosen()) {
        readEnSurah();
      }
    }
    return Expanded(
        child: surahVerses.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: theme.indicatorColor,
                ),
              )
            : versesList());
  }

  Widget versesList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          int verseNumber = index + 1;
          String currentVerseIndex = '${widget.args.surahIndex} $verseNumber';
          return index > surahVerses.length - 1
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
                            text: surahVerses[index],
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
                                    ? " $verseNumber📖 "
                                    : ' $verseNumber ',
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: mainScreenProvider
                                            .fontSizeOfSurahVerses +
                                        25,
                                    fontFamily: DefinedFontFamilies.naskh),
                              ),
                              onLongPress: () {
                                mainScreenProvider.markedVerseIndex == ''
                                    ? mainScreenProvider
                                        .changeMarkedVerse(currentVerseIndex)
                                    : mainScreenProvider.markedVerseIndex ==
                                            currentVerseIndex
                                        ? mainScreenProvider
                                            .changeMarkedVerse('')
                                        : mainScreenProvider
                                            .showAlertAboutVersesMarking(
                                                context,
                                                theme,
                                                currentVerseIndex);
                              },
                            ),
                          )
                        ])),
                  ],
                );
        },
        separatorBuilder: (context, index) {
          return localeProvider.isArabicChosen() ||
                  index > enSurahVerses.length - 1
              ? const SizedBox(
                  width: 0,
                  height: 0,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textDirection: TextDirection.ltr,
                      enSurahVerses[index],
                      style: theme.textTheme.displayLarge!.copyWith(
                          fontFamily: GoogleFonts.notoSans().fontFamily,
                          height: 2,
                          fontSize: mainScreenProvider.fontSizeOfSurahVerses),
                    ),
                    Divider(
                      color:
                          theme.textTheme.bodyMedium!.color!.withOpacity(0.5),
                      thickness: 1.5,
                    )
                  ],
                );
        },
        itemCount: (surahVerses.length == enSurahVerses.length) ||
                localeProvider.isArabicChosen()
            ? surahVerses.length + 1
            : 0);
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

  @override
  void dispose() {
    super.dispose();
    rootBundle.clear();
  }
}
