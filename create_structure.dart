import 'dart:io';

void main() {
  final directories = [
    'lib/blocs/music_player',
    'lib/core/constants',
    'lib/core/errors',
    'lib/core/services',
    'lib/core/utils',
    'lib/core/widgets',
    'lib/data/datasources',
    'lib/data/models',
    'lib/data/repositories',
    'lib/domain/entities',
    'lib/domain/repositories',
    'lib/domain/usecases',
    'lib/presentation/screens',
    'lib/presentation/widgets',
  ];

  final files = {
    'lib/blocs/music_player/music_player_bloc.dart': '',
    'lib/blocs/music_player/music_player_event.dart': '',
    'lib/blocs/music_player/music_player_state.dart': '',
    'lib/core/constants/app_colors.dart': '',
    'lib/core/errors/failures.dart': '',
    'lib/core/services/audio_player_service.dart': '',
    'lib/core/utils/format_duration.dart': '',
    'lib/core/widgets/album_art.dart': '',
    'lib/core/widgets/progress_bar.dart': '',
    'lib/data/datasources/local_audio_datasource.dart': '',
    'lib/data/models/song_model.dart': '',
    'lib/data/repositories/audio_repository_impl.dart': '',
    'lib/data/data.dart': '',
    'lib/domain/entities/song_entity.dart': '',
    'lib/domain/repositories/audio_repository.dart': '',
    'lib/domain/usecases/get_local_songs.dart': '',
    'lib/domain/domain.dart': '',
    'lib/presentation/screens/main_screen.dart': '',
    'lib/presentation/screens/player_screen.dart': '',
    'lib/presentation/widgets/song_tile.dart': '',
    'lib/presentation/widgets/player_controls.dart': '',
    'lib/presentation/presentation.dart': '',
    'lib/main.dart': '',
  };

  for (var dir in directories) {
    Directory(dir).createSync(recursive: true);
  }

  for (var filePath in files.keys) {
    File(filePath).createSync(recursive: true);
  }

  print('✅ Estructura de carpetas y archivos creada correctamente.');
}
