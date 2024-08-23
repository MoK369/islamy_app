import 'package:flutter/material.dart';
import 'package:islamy_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamy_app/core/app_locals/locales.dart';
import 'package:islamy_app/core/providers/locale_provider.dart';
import 'package:islamy_app/core/providers/theme_provider.dart';

import 'bottom_sheet_layout.dart';

typedef BtnFunc = void Function();

class SettingsLayout extends StatelessWidget {
  const SettingsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider.get(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Center(
      child: FractionallySizedBox(
        widthFactor: 1,
        heightFactor: 0.7,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    onSettingsButtonClick(
                      context,
                      size,
                      theme,
                      isLangButtonPressed: true,
                      option1Text: 'العربية',
                      option1Func: () {
                        localeProvider.changeLocale('ar');
                        localeProvider.saveLocal('ar');
                      },
                      option2Text: 'English',
                      option2Func: () {
                        localeProvider.changeLocale('en');
                        localeProvider.saveLocal('en');
                      },
                    );
                  },
                  child: Text(
                    Locales.getTranslations(context).language,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    onSettingsButtonClick(
                      context,
                      size,
                      theme,
                      isLangButtonPressed: false,
                      option1Text: Locales.getTranslations(context).lightTheme,
                      option1Func: () {
                        themeProvider.changeTheme(ThemeMode.light);
                      },
                      option2Text: Locales.getTranslations(context).darkTheme,
                      option2Func: () {
                        themeProvider.changeTheme(ThemeMode.dark);
                      },
                    );
                  },
                  child: Text(
                    Locales.getTranslations(context).themeMode,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        textAlign: TextAlign.center,
                        Locales.getTranslations(context).enableNavigationBar,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      child: Transform.scale(
                        scale: 1.5,
                        alignment: localeProvider.isArabicChosen()
                            ? const Alignment(1, 0)
                            : const Alignment(-1, 0),
                        child: Switch(
                          activeColor: theme.indicatorColor,
                          value: mainScreenProvider.isBottomBarEnabled,
                          onChanged: (value) {
                            mainScreenProvider.changeBarEnablement(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSettingsButtonClick(BuildContext context, Size size, ThemeData theme,
      {required String option1Text,
      required String option2Text,
      required BtnFunc option1Func,
      required BtnFunc option2Func,
      required bool isLangButtonPressed}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetLayout(
          screenSize: size,
          theme: theme,
          text1: option1Text,
          text2: option2Text,
          function1: option1Func,
          function2: option2Func,
          isLangButtonPressed: isLangButtonPressed,
        );
      },
    );
  }
}
