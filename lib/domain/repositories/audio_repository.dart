import '../entities/song_entity.dart';

// Contrato para el repositorio de audio
abstract class AudioRepository {
  Future<List<SongEntity>> getLocalSongs();
}