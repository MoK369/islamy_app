import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanizer/humanizer.dart';
import 'package:islamy_app/presentation/core/ads/ads_provider.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:provider/provider.dart';

class HadeethLayout extends StatefulWidget {
  const HadeethLayout({super.key});

  @override
  State<HadeethLayout> createState() => _HadeethLayoutState();
}

class _HadeethLayoutState extends State<HadeethLayout> {
  late ThemeData theme;
  List<HadethData> ahadeeth = [];

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
        Image.asset(
          'assets/images/hadith_header.png',
          height: size.height * 0.2,
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
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: ahadeeth.length,
                    itemBuilder: (context, currentHadeethIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: mainScreenProvider.markedHadeethIndex ==
                                '$currentHadeethIndex',
                            child: const Icon(
                              Icons.bookmark,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                                onLongPress: () {
                                  if (mainScreenProvider.markedHadeethIndex ==
                                      '') {
                                    mainScreenProvider.changeMarkedHadeeth(
                                        "$currentHadeethIndex");
                                  } else if (mainScreenProvider
                                          .markedHadeethIndex ==
                                      '$currentHadeethIndex') {
                                    mainScreenProvider.changeMarkedHadeeth('');
                                  } else {
                                    mainScreenProvider
                                        .showAlertAboutHadeethMarking(context,
                                            theme, "$currentHadeethIndex");
                                  }
                                },
                                onPressed: () async {
                                  await Provider.of<AdsProvider>(context,
                                          listen: false)
                                      .hideBannerAd();
                                  if (!context.mounted) return;
                                  Navigator.pushNamed(
                                      context, HadeethScreen.routeName,
                                      arguments: ahadeeth[currentHadeethIndex]);
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
    String hadeeths =
        await rootBundle.loadString('assets/hadeeths/ahadeth.txt');
    List<String> eachHadeethList = hadeeths.trim().split('#');
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
