import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/widgets/background_container.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/view_models/hadeeth_layout_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/widgets/change_verses_size_widget.dart';
import 'package:provider/provider.dart';

class HadeethScreen extends StatefulWidget {
  static const String routeName = 'HadeethScreen';

  const HadeethScreen({super.key});

  @override
  State<HadeethScreen> createState() => _HadeethScreenState();
}

class _HadeethScreenState extends State<HadeethScreen> {
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


  SurahScreenProvider surahScreenProvider = getIt.get<SurahScreenProvider>();
  ValueNotifier<bool> showBottomWidgetNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    HadethData args = ModalRoute.of(context)!.settings.arguments as HadethData;
    ThemeData theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => surahScreenProvider,
      child: SafeArea(
        child: BgContainer(
          child: Consumer<SurahScreenProvider>(
            builder: (context, surahScreenProvider, child) {
              return Scaffold(
                appBar: surahScreenProvider.isSurahOrHadeethScreenAppBarVisible
                    ? AppBar(
                        forceMaterialTransparency: true,
                        title: Text(
                          Locales.getTranslations(context).islami,
                        ),
                        centerTitle: true,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 40,
                          ),
                        ),
                      )
                    : null,
                body: Center(
                  child: GestureDetector(
                    onTap: () {
                      surahScreenProvider
                          .changeSurahOrHadeethScreenAppBarStatus(
                              !surahScreenProvider
                                  .isSurahOrHadeethScreenAppBarVisible);
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Card(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      textScaler: const TextScaler.linear(1.0),
                                      args.hadeethTitle,
                                      style: theme.textTheme.titleMedium!
                                          .copyWith(
                                              fontSize: surahScreenProvider
                                                  .fontSizeOfSurahVerses),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showBottomWidgetNotifier.value =
                                            !showBottomWidgetNotifier.value;
                                      },
                                      icon: const Icon(
                                        Icons.format_size,
                                        size: 50,
                                      ))
                                ],
                              ),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: SelectableText(
                                    args.hadeethBody,
                                    textDirection: TextDirection.rtl,
                                    style: theme.textTheme.displayLarge!
                                        .copyWith(
                                            height: 1.5,
                                            fontSize: surahScreenProvider
                                                .fontSizeOfSurahVerses),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: showBottomWidgetNotifier,
                          builder: (context, value, child) {
                            if (value) {
                              return ChangeVersesSizeWidget(
                                onCloseButtonClick: () {
                                  showBottomWidgetNotifier.value = false;
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
