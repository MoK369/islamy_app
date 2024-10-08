import 'package:flutter/material.dart';
import 'package:islamy_app/Modules/mainScreen/custom_widgets/custom_bottom_sheet.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/quran_layout.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/quran_layout/surah_screen/widgets/verses_list.dart';
import 'package:islamy_app/Modules/mainScreen/provider/main_screen_provider.dart';

class TextPage extends StatelessWidget {
  const TextPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SendSurahInfo args =
        ModalRoute.of(context)!.settings.arguments as SendSurahInfo;
    ThemeData theme = Theme.of(context);
    final MainScreenProvider mainScreenProvider =
        MainScreenProvider.get(context);
    return Center(
      child: GestureDetector(
        onTap: () {
          mainScreenProvider.changeSurahScreenAppBarStatus(
              !mainScreenProvider.isSurahScreenAppBarVisible);
        },
        child: Card(
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
                          : 'سورة ${args.surahName}',
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: mainScreenProvider.fontSizeOfSurahVerses),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        CustBottomSheet.bottomSheetOfSurahAndHadeethFontSize(
                            context, mainScreenProvider);
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
      ),
    );
  }
}
