import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/custom_widgets/custom_bottom_bar.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/hadeeth_layout/hadeeth_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/radio_layout/radio_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/sebha_layout/sebha_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/settings_layout/settings_layout.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamic_app/core/app_locals/locals.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:islamic_app/core/widgets/background_container.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "MainScreen";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> layouts = [
    SebhaLayout(),
    RadioLayout(),
    QuranLayout(),
    HadeethLayout(),
    SettingsLayout(),
  ];
  PageController pgController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    // To update the mainScreenSize by the correct main screen size;
    mainScreenProvider.mainScreenSize = MediaQuery.of(context).size;
    mainScreenProvider.localeProvider = LocaleProvider.get(context);
    return Consumer<MainScreenProvider>(
      builder: (context, provider, child) {
        return SafeArea(
            child: BgContainer(
                child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              Locals.getTranslations(context).islami,
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: CustomBottomBar(
            onClick: (value) {
              provider.changeBarIndex(value);
              pgController.animateToPage(provider.bottomBarCurrentIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            },
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
