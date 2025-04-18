import '../../domain/entities/song_entity.dart';

// Modelo de datos que mapea la entidad SongEntity
class SongModel extends SongEntity {
  SongModel({
    required super.id,
    required super.title,
    required super.artist,
    required super.path,
    super.albumArt,
    required super.duration,
  });

  // Convierte desde un mapa (futuro para metadatos)
  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      title: map['title'] ?? 'Unknown',
      artist: map['artist'] ?? 'Unknown',
      path: map['path'] ?? '',
      albumArt: map['albumArt'],
      duration: Duration(seconds: map['duration'] ?? 0),
    );
  }

  // Convierte a entidad SongEntity
  SongEntity toEntity() => SongEntity(
        id: id,
        title: title,
        artist: artist,
        path: path,
        albumArt: albumArt,
        duration: duration,
      );
}