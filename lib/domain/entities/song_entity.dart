class Song {
  final String title;
  final String artist;
  final String albumArtPath;
  final String duration;
  final String path; // Ruta del archivo local

  Song({
    required this.title,
    required this.artist,
    required this.albumArtPath,
    required this.duration,
    required this.path,
  });
}