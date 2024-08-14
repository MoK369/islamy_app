import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/surah_screen.dart';
import 'package:islamic_app/Modules/mainScreen/main_screen.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamic_app/Modules/splash/splash_screen.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:islamic_app/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/themes/app_themes.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => MainScreenProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider.get(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(localeProvider.currentLocale),
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: themeProvider.currentTheme,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        SurahScreen.routeName: (context) => const SurahScreen(),
        HadeethScreen.routeName: (context) => const HadeethScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
