import 'package:flutter/material.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:islamic_app/core/providers/theme_provider.dart';

class BottomSheetLayout extends StatelessWidget {
  Size screenSize;
  ThemeData theme;
  String text1;
  String text2;
  bool isLangButtonPressed;

  void Function() function1, function2;

  BottomSheetLayout(
      {super.key,
      required this.screenSize,
      required this.theme,
      required this.text1,
      required this.text2,
      required this.function1,
      required this.function2,
      required this.isLangButtonPressed});

  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = ThemeProvider.get(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    return SizedBox(
      height: screenSize.height * 0.4,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // first Option:
            MaterialButton(
              onPressed: function1,
              child: !isLangButtonPressed
                  ? !themeProvider.isDarkEnabled()
                      ? getSelectedItem(text1)
                      : getUnSelectedItem(text1)
                  : localeProvider.isArabicChosen()
                      ? getSelectedItem(text1)
                      : getUnSelectedItem(text1),
            ),
            // Second Option:
            MaterialButton(
              onPressed: function2,
              child: !isLangButtonPressed
                  ? themeProvider.isDarkEnabled()
                      ? getSelectedItem(text2)
                      : getUnSelectedItem(text2)
                  : !localeProvider.isArabicChosen()
                      ? getSelectedItem(text2)
                      : getUnSelectedItem(text2),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSelectedItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: theme.textTheme.bodyMedium!
              .copyWith(color: theme.primaryIconTheme.color),
        ),
        Visibility(
            visible: true,
            child: Icon(
              Icons.check,
              color: theme.primaryIconTheme.color,
              size: 35,
            ))
      ],
    );
  }

  Widget getUnSelectedItem(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
