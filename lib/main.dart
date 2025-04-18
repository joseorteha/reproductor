import 'package:flutter/material.dart';
import 'blocs/music_player/music_player_bloc.dart';
import 'core/constants/app_colors.dart';
import 'core/services/audio_player_service.dart';
import 'data/datasources/local_audio_datasource.dart';
import 'data/repositories/audio_repository_impl.dart';
import 'domain/usecases/get_local_songs.dart';
import 'presentation/screens/main_screen.dart';

// Punto de entrada de la aplicación
void main() {
  // Inicializar dependencias manualmente
  final localAudioDataSource = LocalAudioDataSourceImpl();
  final audioRepository = AudioRepositoryImpl(localAudioDataSource);
  final getLocalSongs = GetLocalSongs(audioRepository);
  final audioPlayerService = AudioPlayerService();
  final musicPlayerBloc = MusicPlayerBloc(
    getLocalSongs: getLocalSongs,
    audioPlayerService: audioPlayerService,
  );

  runApp(MyApp(musicPlayerBloc: musicPlayerBloc));
}

class MyApp extends StatelessWidget {
  final MusicPlayerBloc musicPlayerBloc;

  const MyApp({super.key, required this.musicPlayerBloc});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reproductor de Música',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto', // Cambiar a fuente personalizada en el futuro
        useMaterial3: true,
      ),
      home: MainScreen(musicPlayerBloc: musicPlayerBloc),
      debugShowCheckedModeBanner: false,
    );
  }
}