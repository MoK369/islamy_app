import 'package:flutter/material.dart';
import 'package:humanizer/humanizer.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/utils/constants/assets_paths.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/hadeeth_screen.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/hadeeth_layout/view_models/hadeeth_layout_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/main_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class HadeethLayout extends StatefulWidget {
  const HadeethLayout({super.key});

  @override
  State<HadeethLayout> createState() => _HadeethLayoutState();
}

class _HadeethLayoutState extends State<HadeethLayout> {
  late ThemeData theme;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final HadeethLayoutViewModel hadeethLayoutViewModel =
      getIt.get<HadeethLayoutViewModel>();

  @override
  void initState() {
    super.initState();
    hadeethLayoutViewModel.readAhadeeth();
  }

  @override
  Widget build(BuildContext context) {
    MainScreenProvider mainScreenProvider = MainScreenProvider.get(context);
    LocaleProvider localeProvider = LocaleProvider.get(context);
    Size size = MediaQuery.of(context).size;
    theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (context) => hadeethLayoutViewModel,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                AssetsPaths.hadithHeaderImage,
                height: size.height * 0.2,
              ),
              if (mainScreenProvider.markedHadeethIndex.isNotEmpty)
                Positioned(
                  left: localeProvider.isArabicChosen() ? null : 0,
                  right: localeProvider.isArabicChosen() ? 0 : null,
                  child: Transform.flip(
                    flipX: localeProvider.isArabicChosen(),
                    child: IconButton(
                        onPressed: () async {
                          await itemScrollController.scrollTo(
                              index: int.parse(
                                  mainScreenProvider.markedHadeethIndex),
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut);
                        },
                        icon: const Icon(Icons.flag)),
                  ),
                )
            ],
          ),
          const Divider(),
          Center(
            child: Text(
              Locales.getTranslations(context).ahadeeth,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const Divider(),
          Expanded(
            child: Consumer<HadeethLayoutViewModel>(
              builder: (context, viewModel, child) {
                var result = viewModel.readAhadeethState;
                switch (result) {
                  case LoadingState<List<HadethData>>():
                    return Center(child: CircularProgressIndicator());
                  case SuccessState<List<HadethData>>():
                    var ahadeeth = result.data;
                    return ScrollablePositionedList.builder(
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
                                              arguments: ahadeeth[
                                                  currentHadeethIndex]);
                                        },
                                        child: FittedBox(
                                          child: Text(
                                            localeProvider.isArabicChosen()
                                                ? ahadeeth[currentHadeethIndex]
                                                    .hadeethTitle
                                                : ("${(currentHadeethIndex + 1).toOrdinalWords()} hadith")
                                                    .toTitleCase(),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    fontSize:
                                                        size.width * 0.045),
                                          ),
                                        )),
                                  ),
                                ],
                              );
                      },
                    );
                  case ErrorState<List<HadethData>>():
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
