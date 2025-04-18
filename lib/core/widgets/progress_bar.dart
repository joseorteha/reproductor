import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/format_duration.dart';

// Widget para mostrar la barra de progreso de una canción
class ProgressBar extends StatelessWidget {
  final Duration position;
  final Duration duration;

  const ProgressBar({
    super.key,
    required this.position,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: duration.inSeconds > 0 ? position.inSeconds / duration.inSeconds : 0.0,
          backgroundColor: AppColors.textSecondary,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
        const SizedBox(height: 4.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatDuration(position), style: const TextStyle(color: AppColors.textSecondary)),
            Text(formatDuration(duration), style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}