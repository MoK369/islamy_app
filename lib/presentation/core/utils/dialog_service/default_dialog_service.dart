import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/main.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/utils/dialog_service/dialog_service.dart';

@Injectable(as: DialogService)
class DefaultDialogService implements DialogService {
  @override
  Future<void> showBookMarkAlertDialog(
      {required String message, required void Function() okButtonFunction}) {
    final ThemeData theme = Theme.of(globalNavigatorKey.currentContext!);
    return showDialog<void>(
      context: globalNavigatorKey.currentContext!,
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
            LayoutBuilder(
              builder: (context, constraints) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (constraints.maxWidth / 2) - 5,
                        child: ElevatedButton(
                          onPressed: okButtonFunction,
                          style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2))),
                          child: Text(
                            Locales.getTranslations(context).ok,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (constraints.maxWidth / 2) - 5,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.red),
                              padding: WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2))),
                          child: Text(Locales.getTranslations(context).cancel,
                              style: const TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            //Spacer()
          ],
        );
      },
    );
  }
}
