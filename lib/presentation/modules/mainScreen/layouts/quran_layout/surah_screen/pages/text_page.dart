import 'package:flutter/material.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/provider/surah_screen_provider.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/quran_layout/surah_screen/widgets/verses_list.dart';
import 'package:provider/provider.dart';

import '../widgets/change_verses_size_widget.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  ValueNotifier<bool> showBottomWidgetNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final SendSurahInfo args =
        ModalRoute.of(context)!.settings.arguments as SendSurahInfo;
    ThemeData theme = Theme.of(context);
    final SurahScreenProvider surahScreenProvider = Provider.of(context);
    return GestureDetector(
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
                      const SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: Text(
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1.0),
                          args.surahIndex == 114
                              ? args.surahName // in this case it's the doa
                              : '«سورة ${args.surahName}»',
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
                            size: 50,
                          ))
                    ],
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  VersesList(args: args),
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
    );
  }
}
