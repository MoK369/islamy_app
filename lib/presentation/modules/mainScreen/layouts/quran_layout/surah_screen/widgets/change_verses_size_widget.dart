import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:provider/provider.dart';

class ChangeVersesSizeWidget extends StatelessWidget {
  final VoidCallback onCloseButtonClick;

  const ChangeVersesSizeWidget({super.key, required this.onCloseButtonClick});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
      child: Consumer<SurahScreenProvider>(
        builder: (context, surahScreenProvider, child) {
          return SizedBox(
              height: (size.height * 0.2) < 180
                  ? size.height * 0.35
                  : size.height * 0.2,
              child: Card(
                elevation: 10,
                shape: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: theme.indicatorColor, width: 2),
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: onCloseButtonClick,
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              value: surahScreenProvider.fontSizeOfSurahVerses,
                              onChanged: (fontSize) {
                                surahScreenProvider
                                    .changeFontSizeOfSurahVerses(fontSize);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
