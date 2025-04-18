abstract class MusicPlayerEvent {}

class LoadLocalSongs extends MusicPlayerEvent {
  final List<Song> songs;
  LoadLocalSongs(this.songs);
}

class PlaySong extends MusicPlayerEvent {
  final int? songIndex;
  PlaySong({this.songIndex});
}

class PauseSong extends MusicPlayerEvent {}

class SkipNext extends MusicPlayerEvent {}

class SkipPrevious extends MusicPlayerEvent {}

class SeekSong extends MusicPlayerEvent {
  final double position;
  SeekSong(this.position);
}

class UpdatePosition extends MusicPlayerEvent {
  final double position;
  UpdatePosition(this.position);
}