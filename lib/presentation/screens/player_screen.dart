import 'package:flutter/material.dart';
import '../../blocs/music_player/music_player_bloc.dart';
import '../../blocs/music_player/music_player_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/album_art.dart';
import '../../core/widgets/progress_bar.dart';
import '../widgets/player_controls.dart';

// Pantalla para mostrar detalles de la canción y controles
class PlayerScreen extends StatelessWidget {
  final MusicPlayerBloc musicPlayerBloc;

  const PlayerScreen({super.key, required this.musicPlayerBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Ahora Reproduciendo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ValueListenableBuilder<MusicPlayerState>(
                valueListenable: musicPlayerBloc.state,
                builder: (context, state, _) {
                  if (state is MusicPlayerLoaded && state.currentSong != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AlbumArt(
                          imagePath: state.currentSong!.albumArt,
                          size: constraints.maxWidth * 0.6,
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          state.currentSong!.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          state.currentSong!.artist,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        ProgressBar(
                          position: const Duration(seconds: 0), // TODO: Actualizar con posición real
                          duration: state.currentSong!.duration,
                        ),
                        const SizedBox(height: 16.0),
                        PlayerControls(musicPlayerBloc: musicPlayerBloc),
                      ],
                    );
                  }
                  return const Center(child: Text('No hay canción seleccionada'));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}