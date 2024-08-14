import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_suras.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';

class ListOfSuras extends StatelessWidget {
  final List<String> foundUser;
  final void Function(int) onClick;

  const ListOfSuras(
      {super.key, required this.foundUser, required this.onClick});

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    ThemeData theme = Theme.of(context);
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
                        child: Padding(
                  padding: const EdgeInsets.only(left: 3, right: 3),
                  child: FittedBox(
                    child: Text(
                      foundUser[index],
                  style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ))),
              ],
            ),
          );
        },
      ),
    );
  }
}
