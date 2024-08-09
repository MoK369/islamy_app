import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/custom_widgets/custom_bottom_bar.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/hadeeth_layout/hadeeth_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/radio_layout/radio_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/sebha_layout/sebha_layout.dart';
import 'package:islamic_app/Modules/mainScreen/layouts/settings_layout/settings_layout.dart';
import 'package:islamic_app/core/app_locals/locals.dart';
import 'package:islamic_app/core/widgets/background_container.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "MainScreen";

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  static late Size screenSize;
  static late ThemeData theme;
  static int currentIndex = 2;
  List<Widget> layouts = [
    SebhaLayout(),
    RadioLayout(),
    QuranLayout(),
    HadeethLayout(),
    SettingsLayout(),
  ];
  late PageController pgController = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    screenSize = MediaQuery.of(context).size;

    return SafeArea(
        child: BgContainer(
            child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          Locals.getLocals(context).islami,
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: CustomBottomBar(
        onClick: (value) {
          setState(() {
            MainScreenState.currentIndex = value;
            pgController.animateToPage(currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          });
        },
      ),
      body: PageView(
        controller: pgController,
        onPageChanged: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        children: layouts,
      ),
    )));
  }
}
