import 'package:flutter/material.dart';
import '../../blocs/music_player/music_player_bloc.dart';
import '../../blocs/music_player/music_player_event.dart';
import '../../blocs/music_player/music_player_state.dart';
import '../../core/constants/app_colors.dart';

// Widget para los controles de reproducción (play/pausa)
class PlayerControls extends StatelessWidget {
  final MusicPlayerBloc musicPlayerBloc;

  const PlayerControls({super.key, required this.musicPlayerBloc});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MusicPlayerState>(
      valueListenable: musicPlayerBloc.state,
      builder: (context, state, _) {
        final isPlaying = state is MusicPlayerLoaded && state.isPlaying;
        final currentSong = state is MusicPlayerLoaded ? state.currentSong : null;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.textPrimary,
                size: 48.0,
              ),
              onPressed: currentSong != null
                  ? () {
                      if (isPlaying) {
                        musicPlayerBloc.add(const PauseSongEvent());
                      } else {
                        musicPlayerBloc.add(PlaySongEvent(currentSong));
                      }
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}