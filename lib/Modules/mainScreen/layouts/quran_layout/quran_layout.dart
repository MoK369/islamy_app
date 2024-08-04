import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/list_of_suras.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/search_text_field.dart';

class QuranLayout extends StatefulWidget {
  QuranLayout({super.key});

  @override
  State<QuranLayout> createState() => _QuranLayoutState();
}

class _QuranLayoutState extends State<QuranLayout> {
  late ThemeData theme;
  List<String> foundUser = [];

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
                  ListOfSuras(foundUser: foundUser),
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
