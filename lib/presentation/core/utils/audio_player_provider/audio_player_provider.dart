import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

@module
abstract class AudioPlayerProvider {
  @injectable
  AudioPlayer provider() {
    return AudioPlayer(
        maxSkipsOnError: 0,
        useLazyPreparation: true,
        androidAudioOffloadPreferences: const AndroidAudioOffloadPreferences(
            audioOffloadMode: AndroidAudioOffloadMode.enabled,
            isGaplessSupportRequired: true),
        handleInterruptions: true,
        handleAudioSessionActivation: true);
  }
}
