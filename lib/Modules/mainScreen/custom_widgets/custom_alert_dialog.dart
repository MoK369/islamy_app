import 'package:flutter/material.dart';
import 'package:islamy_app/core/app_locals/locales.dart';

class CustAlertDialog {
  static void showBookMarkAlertDialog(BuildContext context,
      {required ThemeData theme,
      required String message,
      required void Function() okButtonFunction}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          actionsAlignment: MainAxisAlignment.spaceBetween,
          title: Text(
            textAlign: TextAlign.center,
            Locales.getTranslations(context).alert,
            style: theme.textTheme.bodyMedium,
          ),
          content: Text(
            textAlign: TextAlign.center,
            message,
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 35, vertical: 2))),
              child: Text(Locales.getTranslations(context).cancel,
                  style: const TextStyle(fontSize: 35)),
            ),
            ElevatedButton(
              onPressed: okButtonFunction,
              style: const ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 35, vertical: 2))),
              child: Text(
                Locales.getTranslations(context).ok,
                style: const TextStyle(fontSize: 35),
              ),
            ),
            //Spacer()
          ],
        );
      },
    );
  }
}
