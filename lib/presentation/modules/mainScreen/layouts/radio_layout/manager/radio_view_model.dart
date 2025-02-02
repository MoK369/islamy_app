import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:islamy_app/data/models/quran_radio_model.dart';
import 'package:islamy_app/domain/api_result/api_result.dart';
import 'package:islamy_app/domain/repositories/quran_radio_channels/quran_radio_channels_repository.dart';
import 'package:islamy_app/presentation/core/bases/base_view_state.dart';
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
    initCurrentIndexStream();
  }

  BaseViewState<List<RadioChannel>> quranRadioChannelsState = LoadingState();
  int _currentRadioChannelIndex = 0;
  List<RadioChannel> _radioChannels = [];
  List<MediaItem> mediaItems = [];
  late ConcatenatingAudioSource playlist;
  late RadioChannel currentRadioChannel;
  bool isRadioChannelsEmpty = true, didAudioPlayerStarted = false;
  RadioAudioState radioAudioState = NotPlayingAudioState();

  Future<void> getQuranRadioChannels(String languageCode) async {
    quranRadioChannelsState = LoadingState();
    notifyListeners();
    var quranRadioApiResult =
        await quranRadioChannelsRepo.getQuranRadioChannels(languageCode);
    // await ApiManager.getQuranRadioChannels(languageCode);
    switch (quranRadioApiResult) {
      case Success<List<RadioChannel>>():
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

  Future<void> initAllAudioSources() async {
    try {
      await audioPlayer.setAudioSource(
        await _concatenateAudioSources(),
        preload: false,
        initialIndex: _currentRadioChannelIndex,
        initialPosition: Duration.zero,
      );
      await audioPlayer.setShuffleModeEnabled(false);
      currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
    } catch (e) {
      debugPrint("Error initializing audio sources: $e");
    }
  }

  Future<ConcatenatingAudioSource> _concatenateAudioSources() async {
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
    playlist = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children: audioSources);
    await addQueueItems(mediaItems);
    return playlist;
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
          radioAudioState = LoadingAudioState();
        }
        notifyListeners();
      },
    );
  }

  void initCurrentIndexStream() {
    audioPlayer.currentIndexStream.listen(
      (index) {
        if (index != null) {
          _currentRadioChannelIndex = index;
          currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
          if (didAudioPlayerStarted) {
            mediaItem.add(queue.value[index]);
          }
        }
        notifyListeners();
      },
    );
  }

  @override
  Future<void> play() async {
    try {
      broadCastPlaybackState(playing: false);
      didAudioPlayerStarted = true;
      initCurrentIndexStream();
      audioPlayer.play();

      //mediaItem.add(queue.value[audioPlayer.currentIndex??0]);
      broadCastPlaybackState(playing: true);
    } on Exception catch (e) {
      quranRadioChannelsState = ErrorState(codeError: CodeError(exception: e));
      notifyListeners();
    }
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
    broadCastPlaybackState(controls: [
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
    initCurrentIndexStream();
  }

  @override
  Future<void> skipToNext() async {
    await audioPlayer.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await audioPlayer.seekToPrevious();
  }

// Future<void> next() async {
//   // if (_currentRadioChannelIndex == _radioChannels.length) {
//   //   return;
//   // }
//   // _currentRadioChannelIndex++;
//   // currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
//
//   // print("currentRadioChannel index $_currentRadioChannelIndex");
//   //await audioPlayer.stop();
//   await audioPlayer.seekToNext();
//   print("Audio Player index ${audioPlayer.currentIndex}");
// }
//
// Future<void> previous() async {
//   // if (_currentRadioChannelIndex == 0) {
//   //   return;
//   // }
//   // _currentRadioChannelIndex--;
//   // currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
//   // print("currentRadioChannel index $_currentRadioChannelIndex");
//   //await audioPlayer.stop();
//   await audioPlayer.seekToPrevious();
//   print("Audio Player index ${audioPlayer.currentIndex}");
// }
}
