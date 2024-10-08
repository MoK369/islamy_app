import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:islamy_app/Modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:islamy_app/Modules/mainScreen/provider/main_screen_provider.dart';
import 'package:islamy_app/core/api_error_message/api_error_message.dart';
import 'package:islamy_app/core/bases/base_view_state.dart';
import 'package:islamy_app/core/models/quran_radio_model.dart';
import 'package:provider/provider.dart';

class RadioLayout extends StatefulWidget {
  const RadioLayout({super.key});

  @override
  State<RadioLayout> createState() => _RadioLayoutState();
}

class _RadioLayoutState extends State<RadioLayout> {
  late MainScreenProvider mainScreenProvider;

  //late LocaleProvider localeProvider;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        mainScreenProvider = Provider.of(context, listen: false);
        // mainScreenProvider.radioViewModel.initPlayerStateStream();
        // mainScreenProvider.radioViewModel.initCurrentIndexStream();
      },
    );
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   //localeProvider = Provider.of<LocaleProvider>(context);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/radio_image.png',
                  fit: BoxFit.contain,
                ),
              ],
            )),
        Consumer<RadioViewModel>(
          builder: (context, radioViewModel, child) {
            var viewModelResult = radioViewModel.quranRadioState;
            switch (viewModelResult) {
              case LoadingState<List<RadioChannel>>():
                return const Expanded(
                    flex: 2, child: Center(child: CircularProgressIndicator()));
              case ErrorState<List<RadioChannel>>():
                return Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                          ApiErrorMessage.getErrorMessage(
                              serverError: viewModelResult.serverError,
                              codeError: viewModelResult.codeError),
                          style: theme.textTheme.titleMedium),
                    ));
              case SuccessState<List<RadioChannel>>():
                return Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          radioViewModel.currentRadioChannel.name ?? "No Name",
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await radioViewModel.skipToPrevious();
                                },
                                child: ImageIcon(
                                  const AssetImage(
                                      'assets/icons/icon_previous.png'),
                                  size: size.width * 0.1,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  radioViewModel.isRadioAudioPlaying
                                      ? await radioViewModel.pause()
                                      : await radioViewModel.play();
                                },
                                child: Icon(
                                  radioViewModel.isRadioAudioPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: size.width * 0.1,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await radioViewModel.stop();
                                },
                                child: Icon(
                                  Icons.stop,
                                  size: size.width * 0.1,
                                ),
                              ),
                              InkWell(
                                  onTap: () async {
                                    await radioViewModel.skipToNext();
                                  },
                                  child: ImageIcon(
                                    const AssetImage(
                                        'assets/icons/icon_next.png'),
                                    size: size.width * 0.1,
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
            }
          },
        )
      ],
    );
  }
}
