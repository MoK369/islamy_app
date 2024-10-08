import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:islamy_app/core/bases/base_view_state.dart';
import 'package:islamy_app/core/models/quran_radio_model.dart';
import 'package:islamy_app/core/services/apis/api_manager.dart';
import 'package:islamy_app/core/services/apis/api_result.dart';
import 'package:just_audio/just_audio.dart';

class RadioViewModel extends BaseAudioHandler
    with ChangeNotifier, QueueHandler, SeekHandler {
  final audioPlayer = AudioPlayer();

  RadioViewModel();

  BaseViewState<List<RadioChannel>> quranRadioState = LoadingState();
  int _currentRadioChannelIndex = 0;
  List<RadioChannel> _radioChannels = [];
  List<MediaItem> mediaItems = [];
  late ConcatenatingAudioSource playlist;
  late RadioChannel currentRadioChannel;
  bool isRadioAudioPlaying = false,
      isRadioChannelsEmpty = true,
      didAudioSourceGetSet = false,
      didAudioPlayerStarted = false;

  Future<void> getQuranRadioChannels(String languageCode) async {
    quranRadioState = LoadingState();
    notifyListeners();
    var quranRadioApiResult =
        await ApiManager.getQuranRadioChannels(languageCode);
    switch (quranRadioApiResult) {
      case Success<List<RadioChannel>>():
        quranRadioState = SuccessState(data: quranRadioApiResult.data);
        _radioChannels = quranRadioApiResult.data;
        if (_radioChannels.isNotEmpty) {
          await initAllAudioSources();
        }
        isRadioChannelsEmpty = _radioChannels.isEmpty;
        break;
      case ServerError<List<RadioChannel>>():
        quranRadioState = ErrorState(serverError: quranRadioApiResult);
        break;
      case CodeError<List<RadioChannel>>():
        quranRadioState = ErrorState(codeError: quranRadioApiResult);
        break;
    }
    notifyListeners();
  }

  Future<void> initAllAudioSources() async {
    await audioPlayer.setAudioSource(
      initialIndex: _currentRadioChannelIndex,
      initialPosition: Duration.zero,
      await _concatenateAudioSources(),
    );
    await audioPlayer.setShuffleModeEnabled(false);
    didAudioSourceGetSet = true;
    currentRadioChannel = _radioChannels[_currentRadioChannelIndex];
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
    playlist = ConcatenatingAudioSource(children: audioSources);
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
        if (audioPlayer.playing) {
          isRadioAudioPlaying = true;
        } else if (event.processingState == ProcessingState.ready &&
            !audioPlayer.playing) {
          isRadioAudioPlaying = false;
        } else if (event.processingState == ProcessingState.idle ||
            event.processingState != ProcessingState.ready) {
          isRadioAudioPlaying = false;
          didAudioSourceGetSet = false;
        } else if (event.processingState == ProcessingState.completed) {
          isRadioAudioPlaying = false;
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
      quranRadioState = ErrorState(codeError: CodeError(exception: e));
      notifyListeners();
    }
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
