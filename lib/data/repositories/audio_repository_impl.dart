import '../../core/errors/failures.dart';
import '../../domain/entities/song_entity.dart';
import '../../domain/repositories/audio_repository.dart';
import '../datasources/local_audio_datasource.dart';

// Implementación del repositorio de audio
class AudioRepositoryImpl implements AudioRepository {
  final LocalAudioDataSource localDataSource;

  AudioRepositoryImpl(this.localDataSource);

  @override
  Future<List<SongEntity>> getLocalSongs() async {
    try {
      final songModels = await localDataSource.getLocalSongs();
      return songModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw StorageFailure('Error al obtener canciones: $e');
    }
  }
}