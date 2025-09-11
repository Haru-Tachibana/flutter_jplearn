import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late AudioPlayer _player;
  late AudioSession _session;

  Future<void> initialize() async {
    _player = AudioPlayer();
    _session = await AudioSession.instance;
    
    await _session.configure(const AudioSessionConfiguration.music());
    
    // Handle audio interruptions
    _session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(0.5);
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            _player.pause();
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            _player.setVolume(1.0);
            break;
          case AudioInterruptionType.pause:
            _player.play();
            break;
          case AudioInterruptionType.unknown:
            break;
        }
      }
    });
  }

  Future<void> playFromUrl(String url, {MediaItem? mediaItem}) async {
    final audioSource = AudioSource.uri(
      Uri.parse(url),
      tag: mediaItem,
    );
    
    await _player.setAudioSource(audioSource);
    await _player.play();
  }

  Future<void> seekToLine(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> play() async => await _player.play();
  Future<void> pause() async => await _player.pause();
  Future<void> stop() async => await _player.stop();

  void dispose() {
    _player.dispose();
  }
}