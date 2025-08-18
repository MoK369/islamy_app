import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/ads/ads_provider.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/widgets/background_container.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/pages/pdf_page.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/pages/text_page.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:provider/provider.dart';

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
  SurahScreenProvider surahScreenProvider = getIt.get<SurahScreenProvider>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Navigator.pop(context);
    showBanner();

    return true;
  }

  void showBanner() {
    Provider.of<AdsProvider>(context, listen: false).showBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as SendSurahInfo;
    theme = Theme.of(context);
    surahScreenProvider.getLocaleProvider(LocaleProvider.get(context));
    return ChangeNotifierProvider(
      create: (context) => surahScreenProvider,
      child: SafeArea(
        child: BgContainer(
          child: DefaultTabController(
            length: 2,
            child: Consumer<SurahScreenProvider>(
              builder: (context, surahScreenProvider, child) {
                return Scaffold(
                  appBar: surahScreenProvider
                          .isSurahOrHadeethScreenAppBarVisible
                      ? AppBar(
                          leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                                showBanner();
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
                );
              },
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
    BackButtonInterceptor.remove(myInterceptor);
  }
}
