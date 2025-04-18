import 'package:flutter/foundation.dart';
import '../../core/services/audio_player_service.dart';
import '../../domain/usecases/get_local_songs.dart';
import 'music_player_event.dart';
import 'music_player_state.dart';

// BLoC que maneja el estado del reproductor de música
class MusicPlayerBloc {
  final GetLocalSongs getLocalSongs;
  final AudioPlayerService audioPlayerService;
  MusicPlayerState _state = const MusicPlayerInitial();
  final ValueNotifier<MusicPlayerState> state = ValueNotifier(const MusicPlayerInitial());
  final List<MusicPlayerEvent> _events = [];

  MusicPlayerBloc({
    required this.getLocalSongs,
    required this.audioPlayerService,
  }) {
    state.addListener(() => _state = state.value);
    _processEvents();
  }

  // Añade un evento al BLoC
  void add(MusicPlayerEvent event) {
    _events.add(event);
    _processEvents();
  }

  // Procesa los eventos en cola
  void _processEvents() async {
    while (_events.isNotEmpty) {
      final event = _events.removeAt(0);
      if (event is LoadSongsEvent) {
        await _onLoadSongs(event);
      } else if (event is PlaySongEvent) {
        await _onPlaySong(event);
      } else if (event is PauseSongEvent) {
        await _onPauseSong(event);
      }
    }
  }

  // Maneja el evento de cargar canciones
  Future<void> _onLoadSongs(LoadSongsEvent event) async {
    state.value = const MusicPlayerLoading();
    try {
      final songs = await getLocalSongs();
      state.value = MusicPlayerLoaded(songs: songs, currentSong: null);
    } catch (e) {
      state.value = MusicPlayerError(message: e.toString());
    }
  }

  // Maneja el evento de reproducir una canción
  Future<void> _onPlaySong(PlaySongEvent event) async {
    if (_state is MusicPlayerLoaded) {
      final currentState = _state as MusicPlayerLoaded;
      try {
        await audioPlayerService.play(event.song.path);
        state.value = MusicPlayerLoaded(
          songs: currentState.songs,
          currentSong: event.song,
          isPlaying: true,
        );
      } catch (e) {
        state.value = MusicPlayerError(message: 'Error al reproducir: $e');
      }
    }
  }

  // Maneja el evento de pausar una canción
  Future<void> _onPauseSong(PauseSongEvent event) async {
    if (_state is MusicPlayerLoaded) {
      final currentState = _state as MusicPlayerLoaded;
      try {
        await audioPlayerService.pause();
        state.value = MusicPlayerLoaded(
          songs: currentState.songs,
          currentSong: currentState.currentSong,
          isPlaying: false,
        );
      } catch (e) {
        state.value = MusicPlayerError(message: 'Error al pausar: $e');
      }
    }
  }
}