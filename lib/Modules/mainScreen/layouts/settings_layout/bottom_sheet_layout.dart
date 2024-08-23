import 'package:flutter/material.dart';
import 'package:islamy_app/core/providers/locale_provider.dart';
import 'package:islamy_app/core/providers/theme_provider.dart';

class BottomSheetLayout extends StatelessWidget {
  final Size screenSize;
  final ThemeData theme;
  final String text1;
  final String text2;
  final bool isLangButtonPressed;
  final void Function() function1, function2;

  const BottomSheetLayout(
      {super.key,
      required this.screenSize,
      required this.theme,
      required this.text1,
      required this.text2,
      required this.function1,
      required this.function2,
      required this.isLangButtonPressed});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider.get(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    return SizedBox(
      height: screenSize.height * 0.4,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        : getUnSelectedItem(text1, themeProvider)
                    : localeProvider.isArabicChosen()
                        ? getSelectedItem(text1)
                        : getUnSelectedItem(text1, themeProvider),
              ),
              // Second Option:
              MaterialButton(
                onPressed: function2,
                child: !isLangButtonPressed
                    ? themeProvider.isDarkEnabled()
                        ? getSelectedItem(text2)
                        : getUnSelectedItem(text2, themeProvider)
                    : !localeProvider.isArabicChosen()
                        ? getSelectedItem(text2)
                        : getUnSelectedItem(text2, themeProvider),
              ),
            ],
          ),
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
          style:
              theme.textTheme.bodyMedium!.copyWith(color: theme.indicatorColor),
        ),
        Visibility(
            visible: true,
            child: Icon(
              Icons.check,
              color: theme.indicatorColor,
              size: 35,
            ))
      ],
    );
  }

  Widget getUnSelectedItem(String text, ThemeProvider themeProvider) {
    return Row(
      children: [
        Text(
          text,
          style: theme.textTheme.bodyMedium!.copyWith(
              color:
                  themeProvider.isDarkEnabled() ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
