// Eventos que el MusicPlayerBloc puede manejar
abstract class MusicPlayerEvent {
  const MusicPlayerEvent();
}

// Evento para cargar canciones locales
class LoadSongsEvent extends MusicPlayerEvent {
  const LoadSongsEvent();
}

// Evento para reproducir una canción específica
class PlaySongEvent extends MusicPlayerEvent {
  final SongEntity song;
  const PlaySongEvent(this.song);
}

// Evento para pausar la reproducción
class PauseSongEvent extends MusicPlayerEvent {
  const PauseSongEvent();
}