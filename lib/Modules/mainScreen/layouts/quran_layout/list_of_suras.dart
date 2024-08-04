import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/surah_screen.dart';

class ListOfSuras extends StatelessWidget {
  List<String> foundUser;

  ListOfSuras({super.key, required this.foundUser});

  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return Expanded(
      child: ListView.builder(
        itemCount: foundUser.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, SurahScreen.routeName,
                  arguments: Send(
                      surahIndex:
                          Suras.arabicAuranSuras.indexOf(foundUser[index]),
                      surahName: foundUser[index]));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                  Suras.ayaNumber[
                      Suras.arabicAuranSuras.indexOf(foundUser[index])],
                  style: theme.textTheme.bodyMedium,
                ))),
                Expanded(
                    child: Center(
                        child: Text(
                  foundUser[index],
                  style: theme.textTheme.bodyMedium,
                ))),
              ],
            ),
          );
        },
      ),
    );
  }
}
