import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/list_of_suras.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/search_text_field.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/surah_screen.dart';

class QuranLayout extends StatefulWidget {
  QuranLayout({super.key});

  @override
  State<QuranLayout> createState() => QuranLayoutState();
}

class QuranLayoutState extends State<QuranLayout> {
  late ThemeData theme;
  List<String> foundUser = [];
  static TextEditingController searchFieldController = TextEditingController();

  @override
  void initState() {
    foundUser = Suras.arabicAuranSuras;
    super.initState();
  }

  void runFilter(String enteredKeyWord) {
    List<String> results = [];
    if (enteredKeyWord.isEmpty) {
      results = Suras.arabicAuranSuras;
    } else {
      results = Suras.arabicAuranSuras
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
    theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FractionallySizedBox(
            widthFactor: 0.3,
            child: Image.asset('assets/icons/quran_header_icn.png')),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              const VerticalDivider(indent: 65),
              Column(
                children: [
                  SearchTextField(
                    onChange: (value) {
                      runFilter(value);
                    },
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("عدد الآيات"),
                      Text("اسم السورة"),
                    ],
                  ),
                  const Divider(),
                  ListOfSuras(
                    foundUser: foundUser,
                    onClick: (index) {
                      Navigator.pushNamed(context, SurahScreen.routeName,
                          arguments: Send(
                              surahIndex: Suras.arabicAuranSuras
                                  .indexOf(foundUser[index]),
                              surahName: foundUser[index]));
                      searchFieldController.clear();
                      FocusScope.of(context).unfocus();
                      runFilter('');
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
}

class Send {
  int surahIndex;
  String surahName;

  Send({required this.surahIndex, required this.surahName});
}
