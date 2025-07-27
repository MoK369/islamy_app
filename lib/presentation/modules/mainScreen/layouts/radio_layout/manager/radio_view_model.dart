import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/data/services/apis/api_manager.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
import 'package:islamy_app/presentation/modules/mainScreen/layouts/radio_layout/manager/cairo_quran_radio.dart';
import 'package:islamy_app/presentation/modules/mainScreen/provider/radio_audio_state.dart';
import 'package:just_audio/just_audio.dart';

@injectable
class RadioViewModel extends BaseAudioHandler
    with ChangeNotifier, QueueHandler, SeekHandler {
  final audioPlayer = AudioPlayer();
  final QuranRadioChannelsRepository quranRadioChannelsRepo;

  @factoryMethod
  RadioViewModel(this.quranRadioChannelsRepo) {
    initPlayerStateStream();
    //initCurrentIndexStream();
  }

  BaseViewState<List<RadioChannel>> quranRadioChannelsState = LoadingState();
  int _currentRadioChannelIndex = 0;
  List<RadioChannel> _radioChannels = [];
  List<MediaItem> mediaItems = [];
  late ConcatenatingAudioSource playlist;
  late RadioChannel currentRadioChannel;
  bool isRadioChannelsEmpty = true,
      didAudioPlayerStarted = false,
      isRadioGoingToPlayAgain = false;
  String languageCodeOfCallingTheApi = '';
  RadioAudioState radioAudioState = NotPlayingAudioState();

  final Connectivity _connectivity = Connectivity();
  Timer? _timer;

  Future<void> getQuranRadioChannels(String languageCode) async {
    quranRadioChannelsState = LoadingState();
    languageCodeOfCallingTheApi = languageCode;
    notifyListeners();
    var quranRadioApiResult =
        await quranRadioChannelsRepo.getQuranRadioChannels(languageCode);
    switch (quranRadioApiResult) {
      case Success<List<RadioChannel>>():
        quranRadioApiResult.data.insert(
            0,
            RadioChannel(
                id: CairoQuranRadio.id,
                name: CairoQuranRadio.title('en'),
                url: CairoQuranRadio.urlStr));
        quranRadioChannelsState = SuccessState(data: quranRadioApiResult.data);
        _radioChannels = quranRadioApiResult.data;
        if (_radioChannels.isNotEmpty) {
          await initAllAudioSources();
        }
        isRadioChannelsEmpty = _radioChannels.isEmpty;
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
      debugPrint("Error initializing audio sources: $e");
    }
  }

  Future<List<AudioSource>> _concatenateAudioSources() async {
    List<AudioSource> audioSources = [];
    mediaItems.clear();
    for (int i = 0; i < _radioChannels.length; i++) {
      Uri url = Uri.parse(_radioChannels[i].url ?? "");
      mediaItems.add(MediaItem(
          id: _radioChannels[i].id.toString(),
          title: _radioChannels[i].name ?? "",
          artist: "",
          duration: const Duration(seconds: 0),
          artUri: Uri.parse(_radioChannels[i].url ?? "")));
      audioSources.add(AudioSource.uri(url, tag: mediaItems[i]));
    }
    await addQueueItems(mediaItems);
    return audioSources;
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    queue.add(mediaItems);
  }

  void initPlayerStateStream() {
    audioPlayer.playerStateStream.listen(
      (event) {
        if (event.playing && event.processingState == ProcessingState.ready) {
          debugPrint("Audio playing");
          _timer?.cancel();
          radioAudioState = PlayingAudioState();
        } else if (event.processingState == ProcessingState.ready &&
            !event.playing) {
          debugPrint("Audio paused");
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

  // void initCurrentIndexStream() {
  //   audioPlayer.currentIndexStream.listen(
  //     (index) {
  //       if (index != null) {
  //         _currentRadioChannelIndex = index;
  //         currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
  //         if (didAudioPlayerStarted) {
  //           mediaItem.add(queue.value[index]);
  //         }
  //       }
  //       notifyListeners();
  //     },
  //   );
  // }

  Future<bool> hasInternetAccess() async {
    try {
      final response = await ApiManager.dio
          .getUri(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void startMonitoringConnectivity() {
    _connectivity.onConnectivityChanged.listen((result) async {
      print("inside monitoring connectivity $result");
      if (result[0] != ConnectivityResult.none) {
        final internetAvailable = await hasInternetAccess();
        if (internetAvailable) {
          retryCurrentStream();
        } else {
          debugPrint("Connected to network, but no internet access.");
          if (_timer?.isActive == true) return;
          _timer = Timer.periodic(
            const Duration(seconds: 15),
            (timer) async {
              final internetAvailable = await hasInternetAccess();
              if (internetAvailable) {
                retryCurrentStream();
              }
            },
          );
        }
      }
    });
  }

  void retryCurrentStream() async {
    try {
      print("inside retryCurrentStream");
      // await audioPlayer.setAudioSource(
      //   audioSources[_currentRadioChannelIndex],
      //   preload: true,
      //   initialPosition: Duration.zero,
      // );
      await audioPlayer.load();
      await audioPlayer.play();
    } catch (e) {
      // Optionally log or retry again later
    }
  }

  @override
  Future<void> play() async {
    try {
      broadCastPlaybackState(playing: false);
      didAudioPlayerStarted = true;
      //initCurrentIndexStream();
      print("before play $_currentRadioChannelIndex ------------");
      print("before play ${currentRadioChannel.name} ------------");
      print(
          "before play ${audioSources[_currentRadioChannelIndex].toString()} ------------");
      await audioPlayer.setAudioSource(
        audioSources[_currentRadioChannelIndex],
        preload: false,
        initialIndex: _currentRadioChannelIndex,
        initialPosition: Duration.zero,
      );
      mediaItem.add(queue.value[_currentRadioChannelIndex]);
      await audioPlayer.play();
      broadCastPlaybackState(playing: true);
    } on Exception catch (e) {
      quranRadioChannelsState = ErrorState(codeError: CodeError(exception: e));
    }
    notifyListeners();
  }

  void broadCastPlaybackState(
      {bool playing = true,
      List<MediaControl> controls = const [
        MediaControl.skipToPrevious,
        MediaControl.pause,
        MediaControl.stop,
        MediaControl.skipToNext,
      ]}) {
    playbackState.add(PlaybackState(
      controls: controls,
      playing: playing,
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: audioPlayer.currentIndex,
    ));
  }

  @override
  Future<void> pause() async {
    broadCastPlaybackState(playing: false, controls: [
      MediaControl.skipToPrevious,
      MediaControl.play,
      MediaControl.stop,
      MediaControl.skipToNext,
    ]);
    await audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    broadCastPlaybackState(
      controls: [],
      playing: false,
    );
    await audioPlayer.stop();
    playbackState.add(PlaybackState(
      controls: [],
      systemActions: const {},
      androidCompactActionIndices: const [],
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
    didAudioPlayerStarted = false;
    //initCurrentIndexStream();
  }

  @override
  Future<void> skipToNext() async {
    if (_currentRadioChannelIndex != audioSources.length - 1) {
      _currentRadioChannelIndex++;
    }
    print("$_currentRadioChannelIndex ------");
    currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
    var wasPlaying = audioPlayer.playing;
    print("$wasPlaying --------");
    if (wasPlaying) {
      await audioPlayer.stop();
      await audioPlayer.setAudioSource(
        audioSources[_currentRadioChannelIndex],
        preload: false,
        initialPosition: Duration.zero,
      );
      mediaItem.add(queue.value[_currentRadioChannelIndex]);
      await audioPlayer.play();
    }
    notifyListeners();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentRadioChannelIndex != 0) {
      _currentRadioChannelIndex--;
    }
    print("$_currentRadioChannelIndex ------");
    currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
    var wasPlaying = audioPlayer.playing;
    print("$wasPlaying --------");
    if (wasPlaying) {
      await audioPlayer.stop();
      await audioPlayer.setAudioSource(
        audioSources[_currentRadioChannelIndex],
        preload: false,
        initialPosition: Duration.zero,
      );
      print("${queue.value[_currentRadioChannelIndex].title} --------");
      mediaItem.add(queue.value[_currentRadioChannelIndex]);
      await audioPlayer.play();
    }
    notifyListeners();
  }
}
