import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
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
                icon: Icon(
                  size: 40,
                  Icons.arrow_back,
                  color: theme.primaryColor,
                )),
            title: const Text("إسلامي"),
          ),
          body: Center(
            child: FractionallySizedBox(
              widthFactor: 0.9,
              heightFactor: 0.9,
              child: Container(
                decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [
                    Text(
                      'سورة ${args.surahName}',
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const Divider(
                      indent: 15,
                      endIndent: 15,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: surahVerses.length,
                        itemBuilder: (context, index) {
                          return RichText(
                            textDirection: TextDirection.rtl,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: surahVerses[index],
                                  style: theme.textTheme.bodyLarge),
                              TextSpan(
                                  text: '${index + 1}',
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                      fontSize: 60, fontFamily: 'AyatQuran11'))
                            ]),
                          );
                        },
                      ),
                    ),
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
