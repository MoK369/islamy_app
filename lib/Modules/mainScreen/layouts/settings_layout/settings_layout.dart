import 'package:flutter/material.dart';

import 'settings_functions.dart';

class SettingsLayout extends StatelessWidget {
  SettingsLayout({super.key});

  late Size size;
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return Center(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: theme.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: () {
                SettingsFunctions().onClick(
                  context,
                  dialogTitle: 'Languages',
                  dialogText1: 'English',
                  dialogFunc1: () {},
                  dialogText2: 'Arabic',
                  dialogFunc2: () {},
                );
              },
              child: Text(
                "Language",
                style: theme.textTheme.bodyMedium,
              ),
            ),
            MaterialButton(
              onPressed: () {
                SettingsFunctions().onClick(
                  context,
                  dialogTitle: 'Modes',
                  dialogText1: 'Light Mode',
                  dialogFunc1: () {},
                  dialogText2: 'Dark Mode',
                  dialogFunc2: () {},
                );
              },
              child: Text(
                "Theme Mode",
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
