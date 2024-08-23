import 'package:flutter/material.dart';
import 'package:islamy_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:provider/provider.dart';

class CustBottomSheet {
  static void bottomSheetOfSurahAndHadeethFontSize(
      BuildContext context, MainScreenProvider mainScreenProvider) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      constraints: BoxConstraints(minWidth: size.width),
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Consumer<MainScreenProvider>(
          builder: (context, mainScreenProvider, child) {
            return SizedBox(
                height: (size.height * 0.2) < 180
                    ? size.height * 0.4
                    : size.height * 0.2,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.font_download_outlined,
                              size: 30,
                            ),
                            Icon(Icons.font_download_outlined),
                          ],
                        ),
                      ),
                      Slider(
                        min: 20,
                        max: 40,
                        divisions: 8,
                        value: mainScreenProvider.fontSizeOfSurahVerses,
                        onChanged: (fontSize) {
                          mainScreenProvider
                              .changeFontSizeOfSurahVerses(fontSize);
                        },
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}
