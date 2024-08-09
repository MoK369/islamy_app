import 'package:flutter/material.dart';
import 'package:islamic_app/core/app_locals/locals.dart';

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
                  dialogTitle: Locals.getLocals(context).languages,
                  dialogText1: 'English',
                  dialogFunc1: () {},
                  dialogText2: 'العربية',
                  dialogFunc2: () {},
                );
              },
              child: Text(
                Locals.getLocals(context).language,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            MaterialButton(
              onPressed: () {
                SettingsFunctions().onClick(
                  context,
                  dialogTitle: Locals.getLocals(context).modes,
                  dialogText1: Locals.getLocals(context).lightTheme,
                  dialogFunc1: () {},
                  dialogText2: Locals.getLocals(context).darkTheme,
                  dialogFunc2: () {},
                );
              },
              child: Text(
                Locals.getLocals(context).themeMode,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
