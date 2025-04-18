import '../entities/song_entity.dart';
import '../repositories/audio_repository.dart';

// Caso de uso para obtener canciones locales
class GetLocalSongs {
  final AudioRepository repository;

  GetLocalSongs(this.repository);

  Future<List<SongEntity>> call() async {
    return await repository.getLocalSongs();
  }
}