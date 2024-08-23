import 'package:flutter/material.dart';
import 'package:islamy_app/Modules/mainScreen/custom_widgets/custom_bottom_bar.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/hadeeth_layout/hadeeth_layout.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/radio_layout/radio_layout.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/sebha_layout/sebha_layout.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/settings_layout/settings_layout.dart';
import 'package:islamy_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamy_app/core/app_locals/locales.dart';
import 'package:islamy_app/core/providers/locale_provider.dart';
import 'package:islamy_app/core/widgets/background_container.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  static const String routeName = "MainScreen";

  MainScreen({super.key});

  final List<Widget> layouts = [
    const SebhaLayout(),
    const RadioLayout(),
    const QuranLayout(),
    const HadeethLayout(),
    const SettingsLayout(),
  ];

  final PageController pgController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    mainScreenProvider.localeProvider = LocaleProvider.get(context);
    return Consumer<MainScreenProvider>(
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
    );
  }
}
