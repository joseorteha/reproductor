import '../../core/errors/failures.dart';
import '../models/song_model.dart';

// Fuente de datos para canciones locales
abstract class LocalAudioDataSource {
  Future<List<SongModel>> getLocalSongs();
}

class LocalAudioDataSourceImpl implements LocalAudioDataSource {
  @override
  Future<List<SongModel>> getLocalSongs() async {
    try {
      // TODO: Implementar escaneo de archivos con permission_handler y flutter_media_metadata
      // Simulación de canciones locales
      await Future.delayed(const Duration(seconds: 1)); // Simular delay
      return [
        SongModel(
          id: '1',
          title: 'Canción 1',
          artist: 'Artista 1',
          path: '/path/to/song1.mp3',
          albumArt: null, // Simulado, integrar con flutter_media_metadata
          duration: const Duration(seconds: 180),
        ),
        SongModel(
          id: '2',
          title: 'Canción 2',
          artist: 'Artista 2',
          path: '/path/to/song2.mp3',
          albumArt: null,
          duration: const Duration(seconds: 240),
        ),
      ];
    } catch (e) {
      throw StorageFailure('Error al cargar canciones: $e');
    }
  }
}