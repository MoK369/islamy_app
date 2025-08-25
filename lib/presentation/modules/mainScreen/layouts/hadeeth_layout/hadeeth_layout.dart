import 'package:flutter/material.dart';
import 'package:humanizer/humanizer.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/core/utils/text_file_caching/text_file_caching.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/utils/gzip_decompressor/gzip_decompressor.dart';

class HadeethLayout extends StatefulWidget {
  const HadeethLayout({super.key});

  @override
  State<HadeethLayout> createState() => _HadeethLayoutState();
}

class _HadeethLayoutState extends State<HadeethLayout> {
  late ThemeData theme;
  List<HadethData> ahadeeth = [];
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    Size size = MediaQuery.of(context).size;
    if (ahadeeth.isEmpty) {
      readHadeeth();
    }
    theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: size.width * 0.18,
            ),
            Image.asset(
              AssetsPaths.hadithHeaderImage,
              height: size.height * 0.2,
            ),
            const Spacer(),
            if (mainScreenProvider.markedHadeethIndex.isNotEmpty)
              IconButton(
                  onPressed: () async {
                    await itemScrollController.scrollTo(
                        index: int.parse(mainScreenProvider.markedHadeethIndex),
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut);
                  },
                  icon: const Icon(Icons.flag))
          ],
        ),
        const Divider(),
        Text(
          Locales.getTranslations(context).ahadeeth,
          style: theme.textTheme.titleMedium,
        ),
        const Divider(),
        Expanded(
            child: ahadeeth.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                    color: theme.indicatorColor,
                  ))
                : ScrollablePositionedList.builder(
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
                    itemCount: ahadeeth.length + 1,
                    itemBuilder: (context, currentHadeethIndex) {
                      return currentHadeethIndex == ahadeeth.length
                          ? const SizedBox(
                              height: 40,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible:
                                      mainScreenProvider.markedHadeethIndex ==
                                          '$currentHadeethIndex',
                                  child: const Icon(
                                    Icons.bookmark,
                                    size: 30,
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                      onLongPress: () {
                                        if (mainScreenProvider
                                                .markedHadeethIndex ==
                                            '') {
                                          mainScreenProvider
                                              .changeMarkedHadeeth(
                                                  "$currentHadeethIndex");
                                        } else if (mainScreenProvider
                                                .markedHadeethIndex ==
                                            '$currentHadeethIndex') {
                                          mainScreenProvider
                                              .changeMarkedHadeeth('');
                                        } else {
                                          mainScreenProvider
                                              .showAlertAboutHadeethMarking(
                                                  context,
                                                  theme,
                                                  "$currentHadeethIndex");
                                        }
                                      },
                                      onPressed: () async {
                                        Navigator.pushNamed(
                                            context, HadeethScreen.routeName,
                                            arguments:
                                                ahadeeth[currentHadeethIndex]);
                                      },
                                      child: FittedBox(
                                        child: Text(
                                          localeProvider.isArabicChosen()
                                              ? ahadeeth[currentHadeethIndex]
                                                  .hadeethTitle
                                              : ("${(currentHadeethIndex + 1).toOrdinalWords()} hadith")
                                                  .toTitleCase(),
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      )),
                                ),
                              ],
                            );
                    },
                  ))
      ],
    );
  }

  void readHadeeth() async {
    String ahadeethKey = AssetsPaths.ahadeethTextFile
        .split('/')
        .last
        .replaceAll(RegExp(r'.gz'), '');
    String? cachedAhadeeth = await TextFileCaching.getCachedText(ahadeethKey);
    List<String> eachHadeethList = [];
    if (cachedAhadeeth != null) {
      eachHadeethList = cachedAhadeeth.split('#');
    } else {
      String hadeeths = await GzipDecompressor.loadCompressedInBackground(
          AssetsPaths.ahadeethTextFile);
      await TextFileCaching.cacheText(ahadeethKey, hadeeths.trim());
      eachHadeethList = hadeeths.trim().split('#');
    }
    setState(() {
      for (int i = 0; i < eachHadeethList.length; i++) {
        List<String> singleHadeeth = eachHadeethList[i].trim().split('\n');
        String hadethTitle = singleHadeeth[0];
        singleHadeeth.removeAt(0);
        String hadeethBody = singleHadeeth.join(' ');
        HadethData h =
            HadethData(hadeethTitle: hadethTitle, hadeethBody: hadeethBody);
        ahadeeth.add(h);
      }
    });
  }
}

class HadethData {
  String hadeethTitle;
  String hadeethBody;

  HadethData({required this.hadeethTitle, required this.hadeethBody});
}
