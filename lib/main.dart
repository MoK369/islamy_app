import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:islamy_app/presentation/core/ads/start_io_ad_provider.dart';
import 'package:islamy_app/presentation/core/app_version_checker/app_version_checker.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/providers/theme_provider.dart';
import 'package:islamy_app/presentation/core/widgets/custom_error_widget.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/surah_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/main_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

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

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) {
      return getIt.get<ThemeProvider>();
    }),
    ChangeNotifierProvider(create: (_) => getIt.get<LocaleProvider>()),
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

      await setupAudioSession();
      await initBackgroundAudio();
      getIt.registerLazySingleton<FToast>(
        () => FToast().init(globalNavigatorKey.currentContext!),
      );
      // check app version:
      getIt.get<AppVersionCheckerViewModel>().checkAppVersion();
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      FlutterNativeSplash.remove();
    },
  );
}

Future<void> initBackgroundAudio() {
  return JustAudioBackground.init(
    androidNotificationChannelId: 'com.main369.islamy.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: "drawable/ic_launcher_foreground",
  );
}

Future<void> setupAudioSession() async {
  audioSession = await AudioSession.instance;
  await audioSession.configure(const AudioSessionConfiguration.speech());
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
      builder: (context, child) {
        ErrorWidget.builder = (errorDetails) {
          debugPrint("errorDetails $errorDetails");
          return const CustomErrorWidget();
        };
        return Overlay(
          initialEntries: [
            if (child != null) ...[
              OverlayEntry(
                builder: (context) => child,
              ),
            ],
          ],
        );
      },
      initialRoute: MainScreen.routeName,
    );
  }
}
