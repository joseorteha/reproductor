import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/music_player/music_player_bloc.dart';
import 'core/constants/app_colors.dart';
import 'data/datasources/local_audio_datasource.dart';
import 'data/repositories/audio_repository_impl.dart';
import 'domain/usecases/get_local_songs.dart';
import 'core/services/audio_player_service.dart';
import 'presentation/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final musicPlayerBloc = MusicPlayerBloc(
      getLocalSongs: GetLocalSongs(
        AudioRepositoryImpl(
          LocalAudioDataSourceImpl(),
        ),
      ),
      audioPlayerService: AudioPlayerService(),
    );

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
      ),
      home: MainScreen(musicPlayerBloc: musicPlayerBloc),
    );
  }
}