import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';

class CustomBottomBar extends StatelessWidget {
  final void Function(int) onClick;

  const CustomBottomBar({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return CurvedNavigationBar(
        onTap: onClick,
        index: mainScreenProvider.bottomBarCurrentIndex,
        height: size.height * 0.13,
        animationDuration: const Duration(milliseconds: 300),
        color: theme.bottomNavigationBarTheme.backgroundColor!,
        backgroundColor: const Color(0xFFd4d2d2),
        items: [
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/sebha_icon.png'),
                  size: 40, color: colorOfItem(theme, mainScreenProvider, 0)),
              label: Locales.getTranslations(context).sebhaLayout,
              labelStyle: styleOfLabel(theme, mainScreenProvider, 0)),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/radio_icon.png'),
                  size: 40, color: colorOfItem(theme, mainScreenProvider, 1)),
              label: Locales.getTranslations(context).radioLayout,
              labelStyle: styleOfLabel(theme, mainScreenProvider, 1)),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/quran_icon.png'),
                  size: 40, color: colorOfItem(theme, mainScreenProvider, 2)),
              label: Locales.getTranslations(context).quranLayout,
              labelStyle: styleOfLabel(theme, mainScreenProvider, 2)),
          CurvedNavigationBarItem(
              child: ImageIcon(
                  const AssetImage('assets/icons/hadeeth_icon.png'),
                  size: 40,
                  color: colorOfItem(theme, mainScreenProvider, 3)),
              label: Locales.getTranslations(context).hadeethLayout,
              labelStyle: styleOfLabel(theme, mainScreenProvider, 3)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.settings,
                color: colorOfItem(theme, mainScreenProvider, 4),
                size: 40,
              ),
              label: Locales.getTranslations(context).settingsLayout,
              labelStyle: styleOfLabel(theme, mainScreenProvider, 4))
        ]);
  }

  Color colorOfItem(
      ThemeData theme, MainScreenProvider mainScreenProvider, int index) {
    Color returnedColor;
    if (mainScreenProvider.bottomBarCurrentIndex == index) {
      returnedColor = theme.bottomNavigationBarTheme.selectedLabelStyle!.color!;
    } else {
      returnedColor = Colors.white;
    }
    return returnedColor;
  }

  TextStyle styleOfLabel(
      ThemeData theme, MainScreenProvider mainScreenProvider, int index) {
    if (mainScreenProvider.bottomBarCurrentIndex == index) {
      return theme.bottomNavigationBarTheme.selectedLabelStyle!;
    } else {
      return theme.bottomNavigationBarTheme.unselectedLabelStyle!;
    }
  }
}
