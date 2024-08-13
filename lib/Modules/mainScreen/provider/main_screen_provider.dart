import 'package:flutter/material.dart';
import 'package:islamic_app/core/providers/locale_provider.dart';
import 'package:provider/provider.dart';

import '../layouts/quran_layout/quran_suras.dart';

class MainScreenProvider extends ChangeNotifier {
  Size mainScreenSize = const Size(0, 0);
  LocaleProvider? localeProvider;

  int bottomBarCurrentIndex = 2;

  static MainScreenProvider get(BuildContext context) {
    return Provider.of<MainScreenProvider>(context);
  }

  void changeBarIndex(int newIndex) {
    bottomBarCurrentIndex = newIndex;
    notifyListeners();
  }

  List<String> getSurasListEnglishOrArabic() {
    if (localeProvider!.isArabicChosen()) {
      return Suras.arabicAuranSuras;
    } else {
      return Suras.englishQuranSurahs;
    }
  }
}
