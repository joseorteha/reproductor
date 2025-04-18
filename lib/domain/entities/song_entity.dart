// Entidad pura que representa una canción
class SongEntity {
  final String id;
  final String title;
  final String artist;
  final String path;
  final String? albumArt;
  final Duration duration;

  SongEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.path,
    this.albumArt,
    required this.duration,
  });
}