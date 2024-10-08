import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/surah_screen/surah_screen.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:islamy_app/Modules/mainScreen/main_screen.dart';
import 'package:islamy_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamy_app/core/providers/locale_provider.dart';
import 'package:islamy_app/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/themes/app_themes.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);
  final RadioViewModel radioViewModel = RadioViewModel();
  initAudioService(radioViewModel);
  PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
    initAudioService(radioViewModel);
  };
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) {
      return ThemeProvider(sharedPreferences);
    }),
    ChangeNotifierProvider(create: (_) => LocaleProvider(sharedPreferences)),
    ChangeNotifierProvider(
        create: (_) => MainScreenProvider(sharedPreferences, radioViewModel)),
  ], child: const MyApp()));
}

void initAudioService(RadioViewModel radioViewModel) async {
  final Brightness brightness = PlatformDispatcher.instance.platformBrightness;
  await AudioService.init(
    builder: () => radioViewModel,
    config: AudioServiceConfig(
        androidNotificationChannelId: 'com.main369.islamy.radioQuran.channel',
        androidNotificationChannelName: 'Quran Audio playback',
        androidNotificationIcon: "drawable/ic_launcher_foreground",
        notificationColor: brightness == Brightness.light
            ? const Color(0xFFB7935F)
            : const Color(0xFF1e2949),
        androidNotificationOngoing: true),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
  }

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
        MainScreen.routeName: (context) => const MainScreen(),
        SurahScreen.routeName: (context) => const SurahScreen(),
        HadeethScreen.routeName: (context) => const HadeethScreen(),
      },
      initialRoute: MainScreen.routeName,
    );
  }
}
