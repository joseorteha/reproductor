import 'package:flutter/material.dart';
import '../../blocs/music_player/music_player_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/album_art.dart';
import '../../domain/entities/song_entity.dart';

// Widget para mostrar una canción en la lista
class SongTile extends StatelessWidget {
  final SongEntity song;
  final MusicPlayerBloc musicPlayerBloc;
  final VoidCallback? onTap;

  const SongTile({
    super.key,
    required this.song,
    required this.musicPlayerBloc,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      leading: AlbumArt(imagePath: song.albumArt),
      title: Text(
        song.title,
        style: const TextStyle(color: AppColors.textPrimary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.artist,
        style: const TextStyle(color: AppColors.textSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
    );
  }
}