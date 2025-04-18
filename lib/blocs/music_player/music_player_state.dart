abstract class MusicPlayerState {
  const MusicPlayerState();
}

class MusicPlayerInitial extends MusicPlayerState {}

class MusicPlayerLoading extends MusicPlayerState {}

class MusicPlayerLoaded extends MusicPlayerState {
  final List<Song> songs;
  final int currentSongIndex;
  final bool isPlaying;
  final double currentPosition;
  final double totalDuration;

  MusicPlayerLoaded({
    required this.songs,
    required this.currentSongIndex,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
  });
}

class MusicPlayerError extends MusicPlayerState {
  final String message;
  MusicPlayerError(this.message);
}