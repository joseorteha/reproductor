// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart' as di;
import 'presentation/blocs/player/player_bloc.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<PlayerBloc>()),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// File: lib/core/di/injection.dart
import 'package:get_it/get_it.dart';
import '../usecases/get_local_songs.dart';
import '../../data/datasources/local_audio_datasource.dart';
import '../../data/repositories/audio_repository_impl.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../presentation/blocs/player/player_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => PlayerBloc(getLocalSongs: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetLocalSongs(sl()));

  // Repositories
  sl.registerLazySingleton<AudioRepository>(
    () => AudioRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalAudioDataSource>(
    () => LocalAudioDataSourceImpl(),
  );
}

// File: lib/core/usecases/usecase.dart
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// File: lib/core/usecases/get_local_songs.dart
import 'package:dartz/dartz.dart';
import '../entities/song.dart';
import '../failures/failure.dart';
import '../repositories/audio_repository.dart';
import 'usecase.dart';

class GetLocalSongs implements UseCase<List<Song>, NoParams> {
  final AudioRepository repository;

  GetLocalSongs(this.repository);

  @override
  Future<Either<Failure, List<Song>>> call(NoParams params) async {
    return await repository.getLocalSongs();
  }
}

class NoParams {}

// File: lib/core/entities/song.dart
class Song {
  final String id;
  final String title;
  final String artist;
  final String path;
  final String? albumArt;
  final Duration duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.path,
    this.albumArt,
    required this.duration,
  });
}

// File: lib/core/failures/failure.dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class StorageFailure extends Failure {
  StorageFailure(String message) : super(message);
}

// File: lib/data/datasources/local_audio_datasource.dart
import 'package:dartz/dartz.dart';
import '../../core/entities/song.dart';
import '../../core/failures/failure.dart';

abstract class LocalAudioDataSource {
  Future<Either<Failure, List<Song>>> getLocalSongs();
}

class LocalAudioDataSourceImpl implements LocalAudioDataSource {
  @override
  Future<Either<Failure, List<Song>>> getLocalSongs() async {
    try {
      // TODO: Implement actual local storage access using a package like flutter_audio_query or on_audio_query
      // This is a placeholder implementation
      return Right([
        Song(
          id: '1',
          title: 'Sample Song',
          artist: 'Sample Artist',
          path: '',
          duration: const Duration(seconds: 180),
        ),
      ]);
    } catch (e) {
      return Left(StorageFailure('Failed to load local songs: $e'));
    }
  }
}

// File: lib/data/repositories/audio_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/entities/song.dart';
import '../../core/failures/failure.dart';
import '../../core/repositories/audio_repository.dart';
import '../datasources/local_audio_datasource.dart';

class AudioRepositoryImpl implements AudioRepository {
  final LocalAudioDataSource localDataSource;

  AudioRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Song>>> getLocalSongs() async {
    return await localDataSource.getLocalSongs();
  }
}

// File: lib/domain/repositories/audio_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/entities/song.dart';
import '../../core/failures/failure.dart';

abstract class AudioRepository {
  Future<Either<Failure, List<Song>>> getLocalSongs();
}

// File: lib/presentation/blocs/player/player_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/entities/song.dart';
import '../../../core/usecases/get_local_songs.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetLocalSongs getLocalSongs;

  PlayerBloc({required this.getLocalSongs}) : super(PlayerInitial()) {
    on<LoadSongs>(_onLoadSongs);
    on<PlaySong>(_onPlaySong);
    on<PauseSong>(_onPauseSong);
    on<SeekSong>(_onSeekSong);
  }

  Future<void> _onLoadSongs(LoadSongs event, Emitter<PlayerState> emit) async {
    emit(PlayerLoading());
    final result = await getLocalSongs(NoParams());
    result.fold(
      (failure) => emit(PlayerError(failure.message)),
      (songs) => emit(PlayerLoaded(songs: songs, currentSong: null)),
    );
  }

  Future<void> _onPlaySong(PlaySong event, Emitter<PlayerState> emit) async {
    if (state is PlayerLoaded) {
      final currentState = state as PlayerLoaded;
      emit(PlayerLoaded(
        songs: currentState.songs,
        currentSong: event.song,
        isPlaying: true,
      ));
      // TODO: Implement actual audio playback using a package like just_audio
    }
  }

  Future<void> _onPauseSong(PauseSong event, Emitter<PlayerState> emit) async {
    if (state is PlayerLoaded) {
      final currentState = state as PlayerLoaded;
      emit(PlayerLoaded(
        songs: currentState.songs,
        currentSong: currentState.currentSong,
        isPlaying: false,
      ));
    }
  }

  Future<void> _onSeekSong(SeekSong event, Emitter<PlayerState> emit) async {
    // TODO: Implement seeking functionality
  }
}

// File: lib/presentation/blocs/player/player_event.dart
part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();
  @override
  List<Object?> get props => [];
}

class LoadSongs extends PlayerEvent {}

class PlaySong extends PlayerEvent {
  final Song song;
  const PlaySong(this.song);
  @override
  List<Object?> get props => [song];
}

class PauseSong extends PlayerEvent {}

class SeekSong extends PlayerEvent {
  final Duration position;
  const SeekSong(this.position);
  @override
  List<Object?> get props => [position];
}

// File: lib/presentation/blocs/player/player_state.dart
part of 'player_bloc.dart';

abstract class PlayerState extends Equatable {
  const PlayerState();
  @override
  List<Object?> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerLoading extends PlayerState {}

class PlayerLoaded extends PlayerState {
  final List<Song> songs;
  final Song? currentSong;
  final bool isPlaying;

  const PlayerLoaded({
    required this.songs,
    this.currentSong,
    this.isPlaying = false,
  });

  @override
  List<Object?> get props => [songs, currentSong, isPlaying];
}

class PlayerError extends PlayerState {
  final String message;
  const PlayerError(this.message);
  @override
  List<Object?> get props => [message];
}

// File: lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player/player_bloc.dart';
import '../widgets/song_list.dart';
import '../widgets/player_controls.dart';
import '../widgets/mini_player.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Song List
                Expanded(
                  child: SongList(),
                ),
                // Mini Player (can be expanded to full player)
                MiniPlayer(),
              ],
            );
          },
        ),
      ),
    );
  }
}

// File: lib/presentation/widgets/song_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player/player_bloc.dart';
import '../../core/entities/song.dart';

class SongList extends StatelessWidget {
  const SongList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PlayerLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: state.songs.length,
            itemBuilder: (context, index) {
              final song = state.songs[index];
              return _buildSongTile(context, song);
            },
          );
        } else if (state is PlayerError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSongTile(BuildContext context, Song song) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: _buildAlbumArt(song),
      title: Text(
        song.title,
        style: Theme.of(context).textTheme.bodyLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        context.read<PlayerBloc>().add(PlaySong(song));
      },
    );
  }

  Widget _buildAlbumArt(Song song) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: song.albumArt != null
            ? DecorationImage(
                image: FileImage(File(song.albumArt!)),
                fit: BoxFit.cover,
              )
            : null,
        color: Colors.grey[300],
      ),
      child: song.albumArt == null
          ? const Icon(Icons.music_note, size: 30, color: Colors.grey)
          : null,
    );
  }
}

// File: lib/presentation/widgets/player_controls.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player/player_bloc.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerLoaded && state.currentSong != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    // TODO: Implement previous song
                  },
                ),
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 36,
                  ),
                  onPressed: () {
                    if (state.isPlaying) {
                      context.read<PlayerBloc>().add(PauseSong());
                    } else {
                      context.read<PlayerBloc>().add(PlaySong(state.currentSong!));
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    // TODO: Implement next song
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

// File: lib/presentation/widgets/mini_player.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player/player_bloc.dart';
import 'player_controls.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerLoaded && state.currentSong != null) {
          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Progress Bar
                LinearProgressIndicator(
                  value: 0.0, // TODO: Implement actual progress
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Song Info and Controls
                Row(
                  children: [
                    // Album Art
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.grey[300],
                      ),
                      child: const Icon(Icons.music_note, size: 24),
                    ),
                    const SizedBox(width: 12.0),
                    // Song Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.currentSong!.title,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            state.currentSong!.artist,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Controls
                    IconButton(
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () {
                        if (state.isPlaying) {
                          context.read<PlayerBloc>().add(PauseSong());
                        } else {
                          context
                              .read<PlayerBloc>()
                              .add(PlaySong(state.currentSong!));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}