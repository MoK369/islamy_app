import 'package:flutter/material.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/presentation/core/api_error_message/api_error_message.dart';
import 'package:islamy_app/presentation/core/app_locals/locales.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/providers/locale_provider.dart';
import 'package:islamy_app/presentation/core/widgets/playing_loading_icon.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/radio_view_model.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/radio_audio_state.dart';
import 'package:provider/provider.dart';

class RadioLayout extends StatefulWidget {
  const RadioLayout({super.key});

  @override
  State<RadioLayout> createState() => _RadioLayoutState();
}

class _RadioLayoutState extends State<RadioLayout> {
  late LocaleProvider localeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localeProvider = LocaleProvider.get(context);
  }

  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
            var viewModelResult = radioViewModel.quranRadioChannelsState;
            switch (viewModelResult) {
              case LoadingState<List<RadioChannel>>():
                return const Expanded(
                    flex: 2, child: Center(child: CircularProgressIndicator()));
              case ErrorState<List<RadioChannel>>():
                return Expanded(
                    flex: 2,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                ApiErrorMessage.getErrorMessage(
                                    serverError: viewModelResult.serverError,
                                    codeError: viewModelResult.codeError),
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 4,),
                            ElevatedButton(
                                onPressed: () {
                                  radioViewModel.getQuranRadioChannels(
                                      localeProvider.isArabicChosen()
                                          ? "ar"
                                          : "eng");
                                },
                                child: Text(Locales.getTranslations(context).tryAgain))
                          ],
                        ),
                      ),
                    ));
              case SuccessState<List<RadioChannel>>():
                return Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            radioViewModel.currentRadioChannel.name ??
                                "No Name",
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
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
                                    await onPlayPauseButtonPress(
                                        radioViewModel);
                                  },
                                  child:
                                      getPlayPauseButtonIcon(radioViewModel)),
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

  Future<void> onPlayPauseButtonPress(RadioViewModel radioViewModel) async {
    switch (radioViewModel.radioAudioState) {
      case NotPlayingAudioState():
        await radioViewModel.play();
      case PlayingAudioState():
        await radioViewModel.pause();
      case LoadingAudioState():
        await radioViewModel.stop();
    }
  }

  Widget getPlayPauseButtonIcon(RadioViewModel radioViewModel) {
    switch (radioViewModel.radioAudioState) {
      case NotPlayingAudioState():
        return Icon(
          Icons.play_arrow,
          size: size.width * 0.1,
        );
      case PlayingAudioState():
        return Icon(
          Icons.pause,
          size: size.width * 0.1,
        );
      case LoadingAudioState():
        return PlayingLoadingIcon(
          iconSize: size.width * 0.07,
        );
    }
  }
}
