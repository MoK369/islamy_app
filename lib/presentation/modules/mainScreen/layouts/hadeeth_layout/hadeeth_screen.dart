import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/widgets/background_container.dart';
import 'package:islamy_app/presentation/modules/mainScreen/custom_widgets/custom_bottom_sheet.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';

import 'hadeeth_layout.dart';

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

  @override
  Widget build(BuildContext context) {
    final MainScreenProvider mainScreenProvider =
        MainScreenProvider.get(context);
    HadethData args = ModalRoute.of(context)!.settings.arguments as HadethData;
    ThemeData theme = Theme.of(context);
    return SafeArea(
        child: BgContainer(
            child: Scaffold(
      appBar: mainScreenProvider.isHadeethScreenAppBarVisible
          ? AppBar(
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
            mainScreenProvider.changeHadeethScreenAppBarStatus(
                !mainScreenProvider.isHadeethScreenAppBarVisible);
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
                      flex: 5,
                      child: Text(
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1.0),
                        args.hadeethTitle,
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
                      style: theme.textTheme.displayLarge!.copyWith(
                          height: 1.5,
                          fontSize: mainScreenProvider.fontSizeOfSurahVerses),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )));
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
