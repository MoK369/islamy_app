import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/ads/ads_provider.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/widgets/background_container.dart';
import 'package:islamy_app/presentation/modules/mainScreen/custom_widgets/custom_bottom_bar.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/radio_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/sebha_layout/sebha_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/settings_layout/settings_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "MainScreen";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late RadioViewModel radioViewModel;
  late LocaleProvider localeProvider;
  final List<Widget> layouts = [
    const SebhaLayout(),
    const RadioLayout(),
    const QuranLayout(),
    const HadeethLayout(),
    const SettingsLayout(),
  ];

  final PageController pgController = PageController(initialPage: 2);
  DateTime? lastPressed;
  MainScreenProvider mainScreenProvider = getIt.get<MainScreenProvider>();

  late AdsProvider appodealAdsProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getQuranRadioChannels();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    radioViewModel = Provider.of<RadioViewModel>(context);
    localeProvider = LocaleProvider.get(context);
    appodealAdsProvider = Provider.of<AdsProvider>(context);
    if (localeProvider.didLocaleChange()) {
      getQuranRadioChannels();
      localeProvider.oldLocale = localeProvider.currentLocale;
    }
    if (appodealAdsProvider.isInitializationFinished) {
      appodealAdsProvider.showInterstitialAd();
      appodealAdsProvider.showBannerAd();
    }
  }

  void getQuranRadioChannels() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        radioViewModel.getQuranRadioChannels(
            localeProvider.isArabicChosen() ? "ar" : "eng");
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      radioViewModel.audioPlayer.dispose();
      radioViewModel.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    mainScreenProvider.getLocaleProvider(LocaleProvider.get(context));
    return ChangeNotifierProvider(
      create: (_) => mainScreenProvider,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          DateTime now = DateTime.now();
          bool isWarning = lastPressed == null ||
              now.difference(lastPressed!) > const Duration(seconds: 2);

          if (isWarning) {
            lastPressed = DateTime.now();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(vertical: 25),
              content: Text(Locales.getTranslations(context).pressAgain),
              duration: const Duration(seconds: 2),
            ));
            return;
          }
          SystemNavigator.pop();
          lastPressed = null;
        },
        child: Consumer<MainScreenProvider>(
          builder: (context, provider, child) {
            return SafeArea(
                child: BgContainer(
                    child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(
                  Locales.getTranslations(context).islami,
                ),
                centerTitle: true,
              ),
              bottomNavigationBar: Visibility(
                visible: provider.isBottomBarEnabled,
                child: CustomBottomBar(
                  onClick: (value) {
                    provider.changeBarIndex(value);
                    pgController.jumpToPage(
                      provider.bottomBarCurrentIndex,
                    );
                  },
                ),
              ),
              body: PageView(
                controller: pgController,
                onPageChanged: (value) {
                  provider.changeBarIndex(value);
                },
                children: layouts,
              ),
            )));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    mainScreenProvider.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
