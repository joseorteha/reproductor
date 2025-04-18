import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/services/audio_player_service.dart';
import '../../domain/entities/song.dart';
import '../../domain/usecases/get_local_songs.dart';
import 'music_player_event.dart';
import 'music_player_state.dart';

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final GetLocalSongs getLocalSongs;
  final AudioPlayerService audioPlayerService;
  List<Song> _songs = [];
  int _currentSongIndex = 0;
  double _currentPosition = 0.0;

  MusicPlayerBloc({
    required this.getLocalSongs,
    required this.audioPlayerService,
  }) : super(MusicPlayerInitial()) {
    on<LoadLocalSongs>(_onLoadLocalSongs);
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<SkipNext>(_onSkipNext);
    on<SkipPrevious>(_onSkipPrevious);
    on<SeekSong>(_onSeekSong);
    on<UpdatePosition>(_onUpdatePosition);

    // Escuchar cambios en la posición del audio
    audioPlayerService.positionStream.listen((position) {
      add(UpdatePosition(position.inSeconds.toDouble()));
    });

    // Escuchar cambios en el estado de reproducción
    audioPlayerService.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        add(SkipNext());
      }
    });
  }

  Future<void> _onLoadLocalSongs(
      LoadLocalSongs event, Emitter<MusicPlayerState> emit) async {
    emit(MusicPlayerLoading());
    try {
      _songs = event.songs;
      _currentSongIndex = 0;
      emit(MusicPlayerLoaded(
        songs: _songs,
        currentSongIndex: _currentSongIndex,
        isPlaying: false,
        currentPosition: 0.0,
        totalDuration: 0.0,
      ));
    } catch (e) {
      emit(MusicPlayerError('Failed to load songs: $e'));
    }
  }

  Future<void> _onPlaySong(PlaySong event, Emitter<MusicPlayerState> emit) async {
    try {
      if (event.songIndex != null) {
        _currentSongIndex = event.songIndex!;
      }
      final song = _songs[_currentSongIndex];
      await audioPlayerService.setAudioSource(song.path);
      await audioPlayerService.play();
      final duration = await audioPlayerService.getDuration();
      emit(MusicPlayerLoaded(
        songs: _songs,
        currentSongIndex: _currentSongIndex,
        isPlaying: true,
        currentPosition: _currentPosition,
        totalDuration: duration?.inSeconds.toDouble() ?? 0.0,
      ));
    } catch (e) {
      emit(MusicPlayerError('Failed to play song: $e'));
    }
  }

  Future<void> _onPauseSong(PauseSong event, Emitter<MusicPlayerState> emit) async {
    await audioPlayerService.pause();
    emit(MusicPlayerLoaded(
      songs: _songs,
      currentSongIndex: _currentSongIndex,
      isPlaying: false,
      currentPosition: _currentPosition,
      totalDuration: state.totalDuration,
    ));
  }

  Future<void> _onSkipNext(SkipNext event, Emitter<MusicPlayerState> emit) async {
    if (_currentSongIndex < _songs.length - 1) {
      _currentSongIndex++;
      _currentPosition = 0.0;
      add(PlaySong(songIndex: _currentSongIndex));
    }
  }

  Future<void> _onSkipPrevious(SkipPrevious event, Emitter<MusicPlayerState> emit) async {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
      _currentPosition = 0.0;
      add(PlaySong(songIndex: _currentSongIndex));
    }
  }

  Future<void> _onSeekSong(SeekSong event, Emitter<MusicPlayerState> emit) async {
    _currentPosition = event.position;
    await audioPlayerService.seek(Duration(seconds: event.position.toInt()));
    emit(MusicPlayerLoaded(
      songs: _songs,
      currentSongIndex: _currentSongIndex,
      isPlaying: state.isPlaying,
      currentPosition: _currentPosition,
      totalDuration: state.totalDuration,
    ));
  }

  void _onUpdatePosition(UpdatePosition event, Emitter<MusicPlayerState> emit) {
    _currentPosition = event.position;
    emit(MusicPlayerLoaded(
      songs: _songs,
      currentSongIndex: _currentSongIndex,
      isPlaying: state.isPlaying,
      currentPosition: _currentPosition,
      totalDuration: state.totalDuration,
    ));
  }
}