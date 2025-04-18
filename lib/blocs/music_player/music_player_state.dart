import '../../domain/entities/song_entity.dart';

// Estados posibles del reproductor de música
abstract class MusicPlayerState {
  const MusicPlayerState();
}

// Estado inicial antes de cualquier acción
class MusicPlayerInitial extends MusicPlayerState {
  const MusicPlayerInitial();
}

// Estado de carga mientras se obtienen las canciones
class MusicPlayerLoading extends MusicPlayerState {
  const MusicPlayerLoading();
}

// Estado cuando las canciones están cargadas
class MusicPlayerLoaded extends MusicPlayerState {
  final List<SongEntity> songs;
  final SongEntity? currentSong;
  final bool isPlaying;

  const MusicPlayerLoaded({
    required this.songs,
    this.currentSong,
    this.isPlaying = false,
  });
}

// Estado de error con un mensaje
class MusicPlayerError extends MusicPlayerState {
  final String message;
  const MusicPlayerError({required this.message});
}