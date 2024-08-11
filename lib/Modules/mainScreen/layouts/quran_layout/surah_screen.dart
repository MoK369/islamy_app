import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamic_app/core/defined_fonts/defined_font_families.dart';
import 'package:islamic_app/core/widgets/background_container.dart';

class SurahScreen extends StatefulWidget {
  static const String routeName = "SurahScreen";

  SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  List<String> surahVerses = [];
  late Send args;
  late ThemeData theme;
  List<TextSpan> spans = [];

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Send;
    if (surahVerses.isEmpty) {
      readSurah();
    }
    theme = Theme.of(context);
    return SafeArea(
      child: BgContainer(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  size: 40,
                  Icons.arrow_back,
                )),
            title: const Text("إسلامي"),
          ),
          body: Center(
            child: FractionallySizedBox(
              widthFactor: 0.95,
              heightFactor: 0.9,
              child: Card(
                child: Column(
                  children: [
                    Text(
                      'سورة ${args.surahName}',
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.titleMedium,
                    ),
                    const Divider(
                      indent: 15,
                      endIndent: 15,
                    ),
                    Expanded(
                        child: surahVerses.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: theme.indicatorColor,
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (args.surahIndex != 0)
                                      Text(
                                        "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ",
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    RichText(
                                      textDirection: TextDirection.rtl,
                                      text: TextSpan(
                                        children:
                                            surahVerses.map<TextSpan>((e) {
                                          return TextSpan(
                                              text: e,
                                              style: GoogleFonts.amiriQuran(
                                                  textStyle: theme
                                                      .textTheme.bodyLarge!
                                                      .copyWith(fontSize: 40)),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        " ${surahVerses.indexOf(e) + 1} ",
                                                    style: theme
                                                        .textTheme.bodyLarge!
                                                        .copyWith(
                                                            fontSize: 60,
                                                            fontFamily:
                                                                DefinedFontFamilies
                                                                    .ayatQuran11))
                                              ]);
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void readSurah() async {
    String surah =
        await rootBundle.loadString('assets/suras/${args.surahIndex + 1}.txt');
    surahVerses = surah.trim().split('\n');

    setState(() {
      surahVerses = surahVerses.map((e) => e = e.trim()).toList();
    });
  }
}
