import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/widgets/background_container.dart';
import 'package:islamy_app/presentation/modules/mainScreen/custom_widgets/custom_bottom_bar.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
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

class _MainScreenState extends State<MainScreen> {
  final List<Widget> layouts = [
    const SebhaLayout(),
    const RadioLayout(),
    const QuranLayout(),
    const HadeethLayout(),
    const SettingsLayout(),
  ];

  final PageController pgController = PageController(initialPage: 2);
  DateTime? lastPressed;
  late MainScreenProvider mainScreenProvider;

  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = LocaleProvider.get(context);
    mainScreenProvider = MainScreenProvider.get(context);
    mainScreenProvider.getLocaleProvider(LocaleProvider.get(context));
    if (mainScreenProvider.radioViewModel.isRadioChannelsEmpty ||
        localeProvider.didLocaleChange()) {
      mainScreenProvider.radioViewModel.getQuranRadioChannels(
          localeProvider.isArabicChosen() ? "ar" : "eng");
      localeProvider.oldLocale = localeProvider.currentLocale;
    }
    return ChangeNotifierProvider(
      create: (context) => mainScreenProvider.radioViewModel,
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
                    pgController.animateToPage(provider.bottomBarCurrentIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
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
    mainScreenProvider.radioViewModel.dispose();
    mainScreenProvider.dispose();
  }
}
