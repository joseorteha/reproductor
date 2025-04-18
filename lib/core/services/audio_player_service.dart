import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Future<void> setAudioSource(String path) async {
    await _audioPlayer.setFilePath(path);
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<Duration?> getDuration() async {
    return _audioPlayer.duration;
  }
}