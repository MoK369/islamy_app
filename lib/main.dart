import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:islamy_app/presentation/core/ads/start_io_ad_provider.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/providers/theme_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/surah_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di.dart';
import 'presentation/core/themes/app_themes.dart';

late final AudioSession audioSession;
GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await configureDependencies();
  final RadioViewModel radioViewModel = getIt<RadioViewModel>();
  StartIoAdProvider startIoAdProvider = getIt.get<StartIoAdProvider>();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) {
      return ThemeProvider(sharedPreferences);
    }),
    ChangeNotifierProvider(create: (_) => LocaleProvider(sharedPreferences)),
    ChangeNotifierProvider(
      create: (_) => radioViewModel,
    ),
    ChangeNotifierProvider(
      create: (_) => startIoAdProvider,
    )
  ], child: const MyApp()));

  WidgetsBinding.instance.addPostFrameCallback(
    (timeStamp) async {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitUp,
      ]);

      initAudioService(radioViewModel);
      await setupAudioSession();
      PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
        initAudioService(radioViewModel);
      };

      // Initializing Appodeal
      await startIoAdProvider.initialize();

      Future.delayed(const Duration(seconds: 1), () async {
        FlutterNativeSplash.remove();
      });
    },
  );
}

void initAudioService(RadioViewModel radioViewModel) async {
  final Brightness brightness = PlatformDispatcher.instance.platformBrightness;
  await AudioService.init(
    builder: () => radioViewModel,
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.main369.islamy.radioQuran.channel',
      androidNotificationChannelName: 'Quran Audio playback',
      androidNotificationIcon: "drawable/ic_launcher_foreground",
      androidNotificationOngoing: true,
      notificationColor: brightness == Brightness.light
          ? const Color(0xFFB7935F)
          : const Color(0xFF1e2949),
    ),
  );
}

Future<void> setupAudioSession() async {
  audioSession = await AudioSession.instance;
  //await session.configure(const AudioSessionConfiguration.music());
  await audioSession.configure(const AudioSessionConfiguration(
    avAudioSessionCategory: AVAudioSessionCategory.playback,
    avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.mixWithOthers,
    avAudioSessionMode: AVAudioSessionMode.defaultMode,
    androidAudioAttributes: AndroidAudioAttributes(
      contentType: AndroidAudioContentType.music,
      usage: AndroidAudioUsage.media,
      flags: AndroidAudioFlags.none,
    ),
    androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientExclusive,
    androidWillPauseWhenDucked: true,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
      navigatorKey: globalNavigatorKey,
      routes: {
        MainScreen.routeName: (context) => const MainScreen(),
        SurahScreen.routeName: (context) => const SurahScreen(),
        HadeethScreen.routeName: (context) => const HadeethScreen(),
      },
      initialRoute: MainScreen.routeName,
    );
  }
}
