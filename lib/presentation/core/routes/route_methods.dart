import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/core/routes/defined_routes.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/view_models/hadeeth_layout_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/surah_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/main_screen.dart';

abstract class RouteMethods {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;
    try {
      switch (name) {
        case DefinedRoutes.mainScreen:
          return MaterialPageRoute(
            builder: (context) => const MainScreen(),
          );
        case DefinedRoutes.surahScreen:
          return MaterialPageRoute(
            builder: (context) => SurahScreen(
              surahInfo: args as SendSurahInfo,
            ),
          );
        case DefinedRoutes.hadeethScreen:
          return MaterialPageRoute(
            builder: (context) => HadeethScreen(
              hadethData: args as HadethData,
            ),
          );
        default:
          return _errorRoute();
      }
    } catch (e) {
      return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Material(
          child: Container(
            color: Colors.red,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Error! You Have Navigated To A Wrong Route. Or Navigated With Wrong Arguments",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
