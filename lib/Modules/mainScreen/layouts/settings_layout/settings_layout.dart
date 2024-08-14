import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamic_app/core/app_locals/locales.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:islamic_app/core/providers/theme_provider.dart';

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
        widthFactor: 0.9,
        heightFactor: 0.6,
        child: Card(
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
                      themeProvider.saveTheme(ThemeMode.light);
                    },
                    option2Text: Locales.getTranslations(context).darkTheme,
                    option2Func: () {
                      themeProvider.changeTheme(ThemeMode.dark);
                      themeProvider.saveTheme(ThemeMode.dark);
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
                  Text(
                    Locales.getTranslations(context).enableNavigationBar,
                    style: theme.textTheme.titleMedium,
                  ),
                  Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      activeColor: theme.indicatorColor,
                      value: mainScreenProvider.isBottomBarEnabled,
                      onChanged: (value) {
                        mainScreenProvider.changeBarEnablement(value);
                        mainScreenProvider.saveBarEnablement(value);
                      },
                    ),
                  )
                ],
              )
            ],
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
