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
                  size: 45, color: colorOfItem(0)),
              label: "السبحة",
              labelStyle: styleOfLabel(0)),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/radio_icon.png'),
                  size: 45, color: colorOfItem(1)),
              label: "الراديو",
              labelStyle: styleOfLabel(1)),
          CurvedNavigationBarItem(
              child: ImageIcon(const AssetImage('assets/icons/quran_icon.png'),
                  size: 45, color: colorOfItem(2)),
              label: "القران",
              labelStyle: styleOfLabel(2)),
          CurvedNavigationBarItem(
              child: ImageIcon(
                  const AssetImage('assets/icons/hadeeth_icon.png'),
                  size: 45,
                  color: colorOfItem(3)),
              label: "الحديث",
              labelStyle: styleOfLabel(3)),
          CurvedNavigationBarItem(
              child: Icon(Icons.settings,
                  size: 45, color: colorOfItem(4)),
              label: "الإعدادات",
              labelStyle: styleOfLabel(4))
        ]);
  }

  Color? colorOfItem(int index) {
    if (MainScreenState.currentIndex == index) {
      return theme.bottomNavigationBarTheme.selectedItemColor;
    } else {
      return theme.bottomNavigationBarTheme.unselectedItemColor;
    }
  }

  TextStyle? styleOfLabel(int index) {
    if (MainScreenState.currentIndex == index) {
      return theme.bottomNavigationBarTheme.selectedLabelStyle;
    } else {
      return theme.bottomNavigationBarTheme.unselectedLabelStyle;
    }
  }
}
