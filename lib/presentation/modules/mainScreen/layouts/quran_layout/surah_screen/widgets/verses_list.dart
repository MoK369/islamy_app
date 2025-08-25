import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/providers/theme_provider.dart';
import 'package:islamy_app/presentation/core/themes/app_themes.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/core/utils/gzip_decompressor/gzip_decompressor.dart';
import 'package:islamy_app/presentation/core/utils/text_file_caching/text_file_caching.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class VersesList extends StatefulWidget {
  final SendSurahInfo args;
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;

  const VersesList({super.key,
    required this.args,
    required this.itemPositionsListener,
    required this.itemScrollController});

  @override
  State<VersesList> createState() => _VersesListState();
}

class _VersesListState extends State<VersesList> {
  List<String> surahVerses = [],
      enSurahVerses = [],
      eachDoaLine = [],
      eachEnDoaLine = [];
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
    return ScrollablePositionedList.separated(
      itemScrollController: widget.itemScrollController,
      itemPositionsListener: widget.itemPositionsListener,
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
                              surahScreenProvider.fontSizeOfSurahVerses + 5),
                    ),
                  SelectableText.rich(
                    textDirection: TextDirection.rtl,
                    TextSpan(children: [
                      TextSpan(
                        text: "${arList[index]} ",
                        style: theme.textTheme.displayLarge!.copyWith(
                            height: 2,
                            fontSize:
                                surahScreenProvider.fontSizeOfSurahVerses),
                      ),
                      WidgetSpan(
                        baseline: TextBaseline.alphabetic,
                        alignment: PlaceholderAlignment.middle,
                        child: GestureDetector(
                          child: widget.args.surahIndex == 114
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
                              : Row(
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
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                  fontSize: surahScreenProvider
                                                      .fontSizeOfSurahVerses -
                                                      10),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    if (surahScreenProvider.markedVerseIndex ==
                                        currentVerseIndex)
                                      Text("📖",
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                                  fontSize: surahScreenProvider
                                                      .fontSizeOfSurahVerses))
                                  ],
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
                                            context, theme, currentVerseIndex);
                          },
                        ),
                      )
                    ]),
                  ),
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
                  SelectableText(
                    textDirection: TextDirection.ltr,
                    enList[index],
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

  void readSurah() async {
    String surahKey = AssetsPaths.getArSurahTextFile(widget.args.surahIndex + 1)
        .split("/")
        .last
        .replaceAll(RegExp(r'.gz'), '');
    String? cachedSurah = await TextFileCaching.getCachedText(surahKey);

    if (cachedSurah != null) {
      surahVerses = cachedSurah.split('\n');
    } else {
      String surah = await GzipDecompressor.loadCompressedInBackground(
          AssetsPaths.getArSurahTextFile(widget.args.surahIndex + 1));
      await TextFileCaching.cacheText(surahKey, surah.trim());
      surahVerses = surah.trim().split('\n');
    }
    setState(() {
      surahVerses = surahVerses.map((e) => e = e.trim()).toList();
    });
  }

  void readEnSurah() async {
    String enSurahKey =
        AssetsPaths.getEnSurahTextFile(widget.args.surahIndex + 1)
            .split('/')
            .last
            .replaceAll(RegExp(r'.gz'), '');
    String? cachedSurah = await TextFileCaching.getCachedText(enSurahKey);

    if (cachedSurah != null) {
      enSurahVerses = cachedSurah.split('\n');
    } else {
      String enSurah = await GzipDecompressor.loadCompressedInBackground(
          AssetsPaths.getEnSurahTextFile(widget.args.surahIndex + 1));
      await TextFileCaching.cacheText(enSurahKey, enSurah.trim());
      enSurahVerses = enSurah.trim().split('\n');
    }

    setState(() {
      enSurahVerses = enSurahVerses.map((e) => e = e.trim()).toList();
    });
  }

  void readDoa() async {
    String doaKey = AssetsPaths.arDoaCompletingTheQuran
        .split('/')
        .last
        .replaceAll(RegExp(r'.gz'), '');

    String? cachedDoa = await TextFileCaching.getCachedText(doaKey);

    if (cachedDoa != null) {
      eachDoaLine = cachedDoa.split("۞");
    } else {
      String doa = await GzipDecompressor.loadCompressedInBackground(
          AssetsPaths.arDoaCompletingTheQuran);
      await TextFileCaching.cacheText(doaKey, doa.trim());
      eachDoaLine = doa.trim().split("۞");
    }

    setState(() {
      eachDoaLine = eachDoaLine.map(
        (e) {
          return e = e.trim();
        },
      ).toList();
    });
  }

  void readEnDoa() async {
    String enDoaKey = AssetsPaths.enDoaCompletingTheQuran
        .split('/')
        .last
        .replaceAll(RegExp(r'.gz'), '');

    String? cachedDoa = await TextFileCaching.getCachedText(enDoaKey);

    if (cachedDoa != null) {
      eachEnDoaLine = cachedDoa.split("۞");
    } else {
      String doa = await GzipDecompressor.loadCompressedInBackground(
          AssetsPaths.enDoaCompletingTheQuran);
      await TextFileCaching.cacheText(enDoaKey, doa);
      eachEnDoaLine = doa.trim().split("۞");
    }

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
