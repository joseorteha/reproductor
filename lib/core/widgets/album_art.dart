import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

// Widget reutilizable para mostrar carátulas de álbumes (simuladas)
class AlbumArt extends StatelessWidget {
  final String? imagePath;
  final double size;

  const AlbumArt({super.key, this.imagePath, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.card,
      ),
      child: imagePath != null
          ? Placeholder() // TODO: Reemplazar con Image.file cuando se use flutter_media_metadata
          : const Icon(Icons.music_note, color: AppColors.textSecondary),
    );
  }
}