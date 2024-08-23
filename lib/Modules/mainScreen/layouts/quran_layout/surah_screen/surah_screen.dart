import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/surah_screen/pages/pdf_page.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/surah_screen/pages/text_page.dart';
import 'package:islamy_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamy_app/core/app_locals/locales.dart';
import 'package:islamy_app/core/widgets/background_container.dart';

class SurahScreen extends StatefulWidget {
  static const String routeName = "SurahScreen";

  const SurahScreen({super.key});

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  List<String> surahVerses = [];
  late SendSurahInfo args;
  late ThemeData theme;
  List<TextSpan> spans = [];
  late MainScreenProvider mainScreenProvider;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as SendSurahInfo;
    mainScreenProvider = MainScreenProvider.get(context);
    theme = Theme.of(context);
    return SafeArea(
      child: BgContainer(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: mainScreenProvider.isSurahScreenAppBarVisible
                ? AppBar(
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          size: 40,
                          Icons.arrow_back,
                        )),
                    title: Text(Locales.getTranslations(context).islami),
                    bottom: TabBar(
                        indicatorColor: theme.indicatorColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(
                            icon: Icon(
                              Icons.text_format,
                              size: 40,
                              color: theme.indicatorColor,
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.picture_as_pdf,
                              size: 40,
                              color: theme.indicatorColor,
                            ),
                          ),
                        ]),
                  )
                : null,
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const TextPage(),
                PDFPage(
                  args: args,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}
