import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamic_app/core/app_locals/locals.dart';
import 'package:islamic_app/core/providers/theme_provider.dart';

class CustomBottomBar extends StatelessWidget {
  void Function(int) onClick;

  CustomBottomBar({super.key, required this.onClick});

  //late ThemeData theme;
  late MainScreenProvider mainScreenProvider;

  late ThemeProvider themeProvider;

  Color? settingIconColor;

  @override
  Widget build(BuildContext context) {
    themeProvider = ThemeProvider.get(context);
    mainScreenProvider = MainScreenProvider.get(context);
    var theme = Theme.of(context);
    return CurvedNavigationBar(
        onTap: onClick,
        index: mainScreenProvider.bottomBarCurrentIndex,
        height: mainScreenProvider.mainScreenSize.height * 0.14,
        animationDuration: const Duration(milliseconds: 300),
        color: theme.bottomNavigationBarTheme.backgroundColor!,
        backgroundColor: const Color(0xFFd4d2d2),
        items: [
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/sebha_icon.png'),
                  size: 45, color: colorOfItem(theme, 0)),
              label: Locals.getTranslations(context).settingsLayout,
              labelStyle: styleOfLabel(theme, 0)),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/radio_icon.png'),
                  size: 45, color: colorOfItem(theme, 1)),
              label: Locals.getTranslations(context).radioLayout,
              labelStyle: styleOfLabel(theme, 1)),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/quran_icon.png'),
                  size: 45, color: colorOfItem(theme, 2)),
              label: Locals.getTranslations(context).quranLayout,
              labelStyle: styleOfLabel(theme, 2)),
          CurvedNavigationBarItem(
              child: ImageIcon(
                  const AssetImage('assets/icons/hadeeth_icon.png'),
                  size: 45,
                  color: colorOfItem(theme, 3)),
              label: Locals.getTranslations(context).hadeethLayout,
              labelStyle: styleOfLabel(theme, 3)),
          CurvedNavigationBarItem(
              child: Icon(
                Icons.settings,
                color: colorOfItem(theme, 4),
                size: 45,
              ),
              label: Locals.getTranslations(context).settingsLayout,
              labelStyle: styleOfLabel(theme, 4))
        ]);
  }

  Color colorOfItem(ThemeData theme, int index) {
    Color returnedColor;
    if (mainScreenProvider.bottomBarCurrentIndex == index) {
      returnedColor = theme.bottomNavigationBarTheme.selectedItemColor!;
    } else {
      returnedColor = theme.bottomNavigationBarTheme.unselectedItemColor!;
    }
    return returnedColor;
  }

  TextStyle styleOfLabel(ThemeData theme, int index) {
    if (mainScreenProvider.bottomBarCurrentIndex == index) {
      return theme.bottomNavigationBarTheme.selectedLabelStyle!;
    } else {
      return theme.bottomNavigationBarTheme.unselectedLabelStyle!;
    }
  }
}
