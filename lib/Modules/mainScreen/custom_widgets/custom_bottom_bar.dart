import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/main_screen.dart';

class CustomBottomBar extends StatelessWidget {
  void Function(int) onClick;

  CustomBottomBar({super.key, required this.onClick});

  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    return CurvedNavigationBar(
        onTap: onClick,
        index: MainScreenState.currentIndex,
        height: MainScreenState.screenSize.height * 0.14,
        animationDuration: const Duration(milliseconds: 300),
        color: theme.bottomNavigationBarTheme.backgroundColor!,
        backgroundColor: theme.shadowColor,
        items: [
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/sebha_icon.png'),
                  size: 45,
                  color: MainScreenState.currentIndex == 0
                      ? theme.bottomNavigationBarTheme.selectedItemColor
                      : theme.bottomNavigationBarTheme.unselectedItemColor),
              label: "السبحة",
              labelStyle: MainScreenState.currentIndex == 0
                  ? theme.bottomNavigationBarTheme.selectedLabelStyle
                  : theme.bottomNavigationBarTheme.unselectedLabelStyle),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/radio_icon.png'),
                  size: 45,
                  color: MainScreenState.currentIndex == 1
                      ? theme.bottomNavigationBarTheme.selectedItemColor
                      : theme.bottomNavigationBarTheme.unselectedItemColor),
              label: "الراديو",
              labelStyle: MainScreenState.currentIndex == 1
                  ? theme.bottomNavigationBarTheme.selectedLabelStyle
                  : theme.bottomNavigationBarTheme.unselectedLabelStyle),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/quran_icon.png'),
                  size: 45,
                  color: MainScreenState.currentIndex == 2
                      ? theme.bottomNavigationBarTheme.selectedItemColor
                      : theme.bottomNavigationBarTheme.unselectedItemColor),
              label: "القران",
              labelStyle: MainScreenState.currentIndex == 2
                  ? theme.bottomNavigationBarTheme.selectedLabelStyle
                  : theme.bottomNavigationBarTheme.unselectedLabelStyle),
          CurvedNavigationBarItem(
              child: ImageIcon(
                  const AssetImage('assets/icons/hadeeth_icon.png'),
                  size: 45,
                  color: MainScreenState.currentIndex == 3
                      ? theme.bottomNavigationBarTheme.selectedItemColor
                      : theme.bottomNavigationBarTheme.unselectedItemColor),
              label: "الحديث",
              labelStyle: MainScreenState.currentIndex == 3
                  ? theme.bottomNavigationBarTheme.selectedLabelStyle
                  : theme.bottomNavigationBarTheme.unselectedLabelStyle),
          CurvedNavigationBarItem(
              child: Icon(Icons.settings,
                  size: 45,
                  color: MainScreenState.currentIndex == 4
                      ? theme.bottomNavigationBarTheme.selectedItemColor
                      : theme.bottomNavigationBarTheme.unselectedItemColor),
              label: "الإعدادات",
              labelStyle: MainScreenState.currentIndex == 4
                  ? theme.bottomNavigationBarTheme.selectedLabelStyle
                  : theme.bottomNavigationBarTheme.unselectedLabelStyle)
        ]);
  }
}
