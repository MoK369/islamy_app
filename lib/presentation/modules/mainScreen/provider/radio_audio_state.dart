sealed class RadioAudioState {}

class NotPlayingAudioState extends RadioAudioState {}

class PlayingAudioState extends RadioAudioState {}

class LoadingAudioState extends RadioAudioState {}
