import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:jpsong_learn/core/services/audio_service.dart';
import 'package:jpsong_learn/shared/models/song.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  return AudioService();
});

final currentSongProvider = StateNotifierProvider<CurrentSongNotifier, Song?>(
  (ref) => CurrentSongNotifier(),
);

final playbackStateProvider = StreamProvider<PlayerState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.playerStateStream;
});

final positionProvider = StreamProvider<Duration>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.positionStream;
});

class CurrentSongNotifier extends StateNotifier<Song?> {
  CurrentSongNotifier() : super(null);

  void setSong(Song song) {
    state = song;
  }

  void clearSong() {
    state = null;
  }
}