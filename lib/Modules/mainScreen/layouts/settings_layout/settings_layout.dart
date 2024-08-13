import 'package:flutter/material.dart';
import 'package:islamic_app/core/app_locals/locals.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:islamic_app/core/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_sheet_layout.dart';

typedef BtnFunc = void Function();

class SettingsLayout extends StatelessWidget {
  SettingsLayout({super.key});

  late Size size;

  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider.get(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
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
                  onSettingsButtonClick(
                    context,
                    isLangButtonPressed: true,
                    option1Text: 'العربية',
                    option1Func: () {
                      localeProvider.changeLocale('ar');
                      saveLocal('ar');
                    },
                    option2Text: 'English',
                    option2Func: () {
                      localeProvider.changeLocale('en');
                      saveLocal('en');
                    },
                  );
                },
                child: Text(
                  Locals.getTranslations(context).language,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  onSettingsButtonClick(
                    context,
                    isLangButtonPressed: false,
                    option1Text: Locals.getTranslations(context).lightTheme,
                    option1Func: () {
                      themeProvider.changeTheme(ThemeMode.light);
                      saveTheme(ThemeMode.light);
                    },
                    option2Text: Locals.getTranslations(context).darkTheme,
                    option2Func: () {
                      themeProvider.changeTheme(ThemeMode.dark);
                      saveTheme(ThemeMode.dark);
                    },
                  );
                },
                child: Text(
                  Locals.getTranslations(context).themeMode,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveLocal(String locale) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('savedLocale', locale);
  }

  Future<void> saveTheme(ThemeMode theme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("savedTheme", '$theme');
  }

  void onSettingsButtonClick(BuildContext context,
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
