import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/di.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/use_cases/get_radio_channels_use_case.dart';
import 'package:islamy_app/main.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/core/l10n/app_localizations.dart';
import 'package:islamy_app/presentation/core/utils/handlers/execute_handler.dart';
import 'package:islamy_app/presentation/core/utils/toasts/toasts.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/radio_audio_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

@singleton
class RadioViewModel extends ChangeNotifier {
  final AudioPlayer audioPlayer;
  final GetRadioChannelsUseCase _getRadioChannelsUseCase;

  final InternetConnection _internetConnection;

  final CustomToasts _customToasts;

  RadioViewModel(this._getRadioChannelsUseCase, this.audioPlayer,
      this._internetConnection, this._customToasts) {
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
    var quranRadioApiResult = await _getRadioChannelsUseCase.call(languageCode);
    switch (quranRadioApiResult) {
      case Success<List<RadioChannel>>():
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
    await executeHandler(() async {
      audioSources = await _concatenateAudioSources();
      await audioPlayer.setShuffleModeEnabled(false);
      currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
    },
        errorMessage:
            getIt.get<AppLocalizations>().errorInitializingAudioSources);
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
        _internetConnection.onStatusChange.listen((InternetStatus status) {
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
    await executeHandler(() async {
      await audioPlayer.stop();
      await audioPlayer.play();
    }, errorMessage: getIt.get<AppLocalizations>().errorReplayingAudio);
  }

  Future<void> play() async {
    await executeHandler(
      () async {
        if (!(await _internetConnection.hasInternetAccess)) {
          _customToasts.showErrorToast(
              getIt.get<AppLocalizations>().noInternetConnection);
        } else if (await audioSession?.setActive(true) ?? false) {
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
          _customToasts.showErrorToast(
              getIt.get<AppLocalizations>().audioSessionNotActive);
        }
      },
      errorMessage: getIt.get<AppLocalizations>().errorPlayingAudio,
      onErrorExecute: (error) {
        if (error is Exception) {
          allowChangeOfCurrentRadioChannel = true;
        }
      },
    );
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
    await executeHandler<void>(() async {
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
    }, errorMessage: getIt.get<AppLocalizations>().errorMovingToNextChannel);
  }

  Future<void> skipToPrevious() async {
    await executeHandler(() async {
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
    },
        errorMessage:
            getIt.get<AppLocalizations>().errorMovingToPreviousChannel);
  }

  bool get isLastAudioChannel =>
      _currentRadioChannelIndex == _radioChannels.length - 1;
  bool get isFirstAudioChannel => _currentRadioChannelIndex == 0;

  int get currentRadioChannelIndex => _currentRadioChannelIndex;
}
