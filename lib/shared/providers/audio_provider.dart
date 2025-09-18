import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioState {
  final bool isPlaying;
  final String? currentSongId;

  const AudioState({this.isPlaying = false, this.currentSongId});
}

class AudioNotifier extends StateNotifier<AudioState> {
  AudioNotifier() : super(const AudioState());

  void play(String songId) {
    state = AudioState(isPlaying: true, currentSongId: songId);
  }

  void pause() {
    state = AudioState(isPlaying: false, currentSongId: state.currentSongId);
  }

  void stop() {
    state = const AudioState();
  }
}

final audioProvider =
    StateNotifierProvider<AudioNotifier, AudioState>((ref) => AudioNotifier());
