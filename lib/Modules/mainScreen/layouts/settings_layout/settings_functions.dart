import 'package:flutter/material.dart';

typedef BtnFunc = void Function();

class SettingsFunctions {
  late ThemeData theme;
  late Size size;

  void onClick(context,
      {required String dialogTitle,
      required String dialogText1,
      required String dialogText2,
      required BtnFunc dialogFunc1,
      required BtnFunc dialogFunc2}) {
    theme = Theme.of(context);
    size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              dialogTitle,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          content: SizedBox(
            width: size.width * 0.9,
            height: size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MaterialButton(
                  onPressed: dialogFunc1,
                  child: Text(
                    dialogText1,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                MaterialButton(
                  onPressed: dialogFunc2,
                  child: Text(
                    dialogText2,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
