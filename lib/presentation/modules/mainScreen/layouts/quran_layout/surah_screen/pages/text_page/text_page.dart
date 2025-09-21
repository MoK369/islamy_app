import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/widgets/custom_error_widget.dart';
import 'package:islamy_app/presentation/core/widgets/custom_loading_widget.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/pages/text_page/verses_list.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/pages/text_page/view_model/surah_text_page_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../widgets/change_verses_size_widget.dart';

class TextPage extends StatefulWidget {
  final SendSurahInfo surahInfo;

  const TextPage({super.key, required this.surahInfo});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  ValueNotifier<bool> showBottomWidgetNotifier = ValueNotifier(false);
  late SurahScreenProvider surahScreenProvider;
  late int surahIndexHasMark;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final SurahTextPageViewModel surahTextPageViewModel =
      getIt.get<SurahTextPageViewModel>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        widget.surahInfo.surahIndex == 114
            ? surahTextPageViewModel.readDoa(
                loadEnDoaToo: !LocaleProvider.get(context, listen: false)
                    .isArabicChosen())
            : surahTextPageViewModel.readSurah(
                surahIndex: widget.surahInfo.surahIndex,
                loadEnSurahToo: !LocaleProvider.get(context, listen: false)
                    .isArabicChosen());
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    surahScreenProvider = Provider.of<SurahScreenProvider>(context);
    surahIndexHasMark =
        int.tryParse(surahScreenProvider.markedVerseIndex.split(' ').first) ??
            -1;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final SurahScreenProvider surahScreenProvider = Provider.of(context);
    return ChangeNotifierProvider(
      create: (context) => surahTextPageViewModel,
      child: GestureDetector(
        onTap: () {
          surahScreenProvider.changeSurahOrHadeethScreenAppBarStatus(
              !surahScreenProvider.isSurahOrHadeethScreenAppBarVisible);
          if (showBottomWidgetNotifier.value) {
            showBottomWidgetNotifier.value = false;
          }
        },
        child: Center(
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
                        surahIndexHasMark == widget.surahInfo.surahIndex
                            ? IconButton(
                                onPressed: () async {
                                  final int markedVerseNum = int.parse(
                                      surahScreenProvider.markedVerseIndex
                                          .split(' ')
                                          .last);
                                  await itemScrollController.scrollTo(
                                    index: markedVerseNum - 1,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: const Icon(
                                  Icons.flag,
                                  size: 45,
                                ),
                              )
                            : const SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(1.0),
                            widget.surahInfo.surahIndex == 114
                                ? widget.surahInfo
                                    .surahName // in this case it's the doa
                                : '«سورة ${widget.surahInfo.surahName}»',
                            textDirection: TextDirection.rtl,
                            style: theme.textTheme.titleMedium!.copyWith(
                                fontSize:
                                    surahScreenProvider.fontSizeOfSurahVerses),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showBottomWidgetNotifier.value =
                                !showBottomWidgetNotifier.value;
                          },
                          icon: const Icon(
                            Icons.format_size,
                            size: 45,
                          ),
                        )
                      ],
                    ),
                    const Divider(
                      indent: 15,
                      endIndent: 15,
                    ),
                    Expanded(
                      child: Consumer<SurahTextPageViewModel>(
                        builder: (context, value, child) {
                          final result = widget.surahInfo.surahIndex == 114
                              ? value.doaState
                              : value.surahVersesState;
                          switch (result) {
                            case IdleState<List<List<String>>>():
                            case LoadingState<List<List<String>>>():
                              return const CustomLoadingWidget();
                            case SuccessState<List<List<String>>>():
                              return VersesList(
                                arList: result.data.first,
                                enList: result.data.last,
                                surahIndex: widget.surahInfo.surahIndex,
                                itemScrollController: itemScrollController,
                                itemPositionsListener: itemPositionsListener,
                              );
                            case ErrorState<List<List<String>>>():
                              return CustomErrorWidget(
                                codeError: result.codeError,
                                serverError: result.serverError,
                              );
                          }
                        },
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
  }

  @override
  void dispose() {
    super.dispose();
    rootBundle.clear();
  }
}
