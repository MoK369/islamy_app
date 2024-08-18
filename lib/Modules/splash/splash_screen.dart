import 'dart:async';

import 'package:flutter/material.dart';
import 'package:islamic_app/Modules/mainScreen/main_screen.dart';
import 'package:islamic_app/core/providers/theme_provider.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "SplashScreen";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Size size;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.routeName, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    final ThemeProvider themeProvider = ThemeProvider.get(context);
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(themeProvider.currentTheme == ThemeMode.light
                  ? 'assets/images/bg_splash.png'
                  : 'assets/images/bg_splash_dark.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              ImageIcon(
                const AssetImage('assets/images/logo.png'),
                size: size.width * 0.8,
              ),
              const Spacer(),
              ImageIcon(
                const AssetImage('assets/images/branding.png'),
                size: size.height * 0.2,
              ),
              Text(
                "Supervised by Mohamed Nabil",
                style: theme.textTheme.labelSmall,
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
