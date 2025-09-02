import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart';
import 'package:islamy_app/main.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/widgets/toast_widget.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/cairo_quran_radio.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/radio_audio_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

@singleton
class RadioViewModel extends ChangeNotifier {
  final audioPlayer = AudioPlayer();
  final QuranRadioChannelsRepository quranRadioChannelsRepo;
  @factoryMethod
  RadioViewModel(this.quranRadioChannelsRepo) {
    _initPlayerStateStream();
    _initIndexStream();
  }
  BaseViewState<List<RadioChannel>> quranRadioChannelsState = LoadingState();
  int _currentRadioChannelIndex = 0;
  List<RadioChannel> _radioChannels = [];
  List<MediaItem> mediaItems = [];
  RadioChannel? currentRadioChannel;
  bool allowChangeOfCurrentRadioChannel = true,
      audioPlayerWasPlaying = false,
      wasPlayerBufferingBeforeStop = false;
  RadioAudioState radioAudioState = NotPlayingAudioState();
  StreamSubscription<InternetStatus>? listenOnInternetChangeStream;
  Future<void> getQuranRadioChannels(String languageCode) async {
    quranRadioChannelsState = LoadingState();
    notifyListeners();
    var quranRadioApiResult =
        await quranRadioChannelsRepo.getQuranRadioChannels(languageCode);
    switch (quranRadioApiResult) {
      case Success<List<RadioChannel>>():
        quranRadioApiResult.data.insert(
            0,
            RadioChannel(
                id: CairoQuranRadio.id,
                name: CairoQuranRadio.title(languageCode),
                url: CairoQuranRadio.urlStr));
        quranRadioChannelsState = SuccessState(data: quranRadioApiResult.data);
        _radioChannels = quranRadioApiResult.data;
        if (_radioChannels.isNotEmpty) {
          await initAllAudioSources();
        }
        break;
      case ServerError<List<RadioChannel>>():
        quranRadioChannelsState = ErrorState(serverError: quranRadioApiResult);
        break;
      case CodeError<List<RadioChannel>>():
        quranRadioChannelsState = ErrorState(codeError: quranRadioApiResult);
        break;
    }
    notifyListeners();
  }

  List<AudioSource> audioSources = [];
  Future<void> initAllAudioSources() async {
    try {
      audioSources = await _concatenateAudioSources();
      await audioPlayer.setShuffleModeEnabled(false);
      currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
    } catch (e) {
      showErrorToast(
          getIt.get<AppLocalizations>().errorInitializingAudioSources +
              e.toString());
    }
  }

  Future<List<AudioSource>> _concatenateAudioSources() async {
    List<AudioSource> audioSources = [];
    mediaItems.clear();
    for (int i = 0; i < _radioChannels.length; i++) {
      Uri url = Uri.parse(_radioChannels[i].url ?? "");
      mediaItems.add(MediaItem(
          id: _radioChannels[i].url.toString(),
          title: _radioChannels[i].name ?? "",
          artist: "",
          duration: const Duration(seconds: 0),
          artUri: Uri.parse(
              "https://mok369.github.io/islamy-app-version-checker/app_icon.png")));
      audioSources.add(AudioSource.uri(url, tag: mediaItems[i]));
    }
    return audioSources;
  }

  void _initPlayerStateStream() {
    audioPlayer.playerStateStream.listen(
      (event) async {
        if (event.playing && event.processingState == ProcessingState.ready) {
          debugPrint("Audio playing");
          radioAudioState = PlayingAudioState();
        } else if (event.processingState == ProcessingState.ready &&
            !event.playing) {
          debugPrint("Audio paused");
          await listenOnInternetChangeStream?.cancel();
          radioAudioState = NotPlayingAudioState();
        } else if (event.processingState == ProcessingState.idle) {
          debugPrint("Audio Not Played yet");
          radioAudioState = NotPlayingAudioState();
        } else if (event.processingState == ProcessingState.completed) {
          debugPrint("Audio completed");
          radioAudioState = NotPlayingAudioState();
        } else if (event.processingState == ProcessingState.buffering) {
          debugPrint("Audio Loading");
          startMonitoringConnectivity();
          radioAudioState = LoadingAudioState();
        }
        notifyListeners();
      },
    );
  }

  void _initIndexStream() {
    audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        if (_currentRadioChannelIndex != index) {
          _currentRadioChannelIndex = index;
          if (allowChangeOfCurrentRadioChannel) {
            currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
          }
          notifyListeners();
        }
      }
    });
  }

  void startMonitoringConnectivity() async {
    if (listenOnInternetChangeStream != null) {
      await listenOnInternetChangeStream!.cancel();
    }
    listenOnInternetChangeStream =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          debugPrint("The internet is now connected ****");
          retryCurrentStream();
          break;
        case InternetStatus.disconnected:
          debugPrint("The internet is now disconnected ****");
          break;
      }
    });
  }

  void retryCurrentStream() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play();
    } catch (e) {
      showErrorToast(
          getIt.get<AppLocalizations>().errorReplayingAudio + e.toString());
    }
  }

  Future<void> play() async {
    try {
      if (!(await InternetConnection().hasInternetAccess)) {
        showErrorToast(getIt.get<AppLocalizations>().noInternetConnection);
      } else if (await audioSession.setActive(true)) {
        if (audioPlayer.audioSources.isEmpty) {
          allowChangeOfCurrentRadioChannel = false;
          await audioPlayer.setAudioSources(
            audioSources,
            preload: false,
            initialIndex: _currentRadioChannelIndex,
            initialPosition: Duration.zero,
          );
          allowChangeOfCurrentRadioChannel = true;
        }
        await audioPlayer.play();
        audioPlayerWasPlaying = true;
      } else {
        showErrorToast(getIt.get<AppLocalizations>().audioSessionNotActive);
      }
    } on Exception catch (e) {
      allowChangeOfCurrentRadioChannel = true;
      quranRadioChannelsState = ErrorState(codeError: CodeError(exception: e));
      showErrorToast(e.toString());
    } catch (e) {
      showErrorToast(e.toString());
    }
    notifyListeners();
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> stop() async {
    await listenOnInternetChangeStream?.cancel();
    await audioPlayer.stop();
  }

  Future<void> skipToNext() async {
    try {
      if (isLastAudioChannel) return;
      if (_currentRadioChannelIndex != audioSources.length - 1) {
        _currentRadioChannelIndex++;
      }
      if (!audioPlayer.playing &&
          audioPlayer.processingState == ProcessingState.ready) {
        await audioPlayer.stop();
      }
      await audioPlayer.seekToNext();
      currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
      notifyListeners();
    } catch (e) {
      showErrorToast(getIt.get<AppLocalizations>().errorMovingToNextChannel +
          e.toString());
    }
  }

  Future<void> skipToPrevious() async {
    try {
      if (isFirstAudioChannel) return;
      if (_currentRadioChannelIndex != 0) {
        _currentRadioChannelIndex--;
      }
      if (!audioPlayer.playing &&
          audioPlayer.processingState == ProcessingState.ready) {
        await audioPlayer.stop();
      }
      await audioPlayer.seekToPrevious();
      currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
      notifyListeners();
    } catch (e) {
      showErrorToast(
          getIt.get<AppLocalizations>().errorMovingToPreviousChannel +
              e.toString());
    }
  }

  bool get isLastAudioChannel =>
      _currentRadioChannelIndex == _radioChannels.length - 1;
  bool get isFirstAudioChannel => _currentRadioChannelIndex == 0;

  void showErrorToast(String message) {
    getIt.get<FToast>().showToast(
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
        child: ToastWidget(
          text: message,
          color: Colors.red,
          icon: Icons.error_outline,
        ));
  }
}
