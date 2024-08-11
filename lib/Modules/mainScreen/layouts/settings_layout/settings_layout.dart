import 'package:flutter/material.dart';
import 'package:islamic_app/core/app_locals/locals.dart';

import 'bottom_sheet_layout.dart';

typedef BtnFunc = void Function();

class SettingsLayout extends StatefulWidget {
  SettingsLayout({super.key});

  @override
  State<SettingsLayout> createState() => _SettingsLayoutState();
}

class _SettingsLayoutState extends State<SettingsLayout> {
  late Size size;

  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.6,
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  onClick(
                    option1Text: 'English',
                    option1Func: () {},
                    option2Text: 'العربية',
                    option2Func: () {},
                  );
                },
                child: Text(
                  Locals.getLocals(context).language,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  onClick(
                    option1Text: Locals.getLocals(context).lightTheme,
                    option1Func: () {},
                    option2Text: Locals.getLocals(context).darkTheme,
                    option2Func: () {},
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
      ),
    );
  }

  void onClick(
      {required String option1Text,
      required String option2Text,
      required BtnFunc option1Func,
      required BtnFunc option2Func}) {
    showModalBottomSheet(
      backgroundColor: theme.cardTheme.color,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      context: context,
      builder: (context) {
        return BottomSheetLayout(
          screenSize: size,
          theme: theme,
          text1: option1Text,
          text2: option2Text,
          function1: option1Func,
          function2: option2Func,
        );
      },
    );
  }
}
