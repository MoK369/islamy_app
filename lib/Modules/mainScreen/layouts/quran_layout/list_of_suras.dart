import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';

class ListOfSuras extends StatelessWidget {
  List<String> foundUser;
  void Function(int) onClick;

  ListOfSuras({super.key, required this.foundUser, required this.onClick});

  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    theme = Theme.of(context);
    return Expanded(
      child: ListView.builder(
        itemCount: foundUser.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              onClick(index);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                  Suras.ayaNumber[mainScreenProvider
                      .getSurasListEnglishOrArabic()
                      .indexOf(foundUser[index])],
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
