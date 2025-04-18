import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:file_picker/file_picker.dart';
import '../../blocs/music_player/music_player_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/song.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double volume = 0.7;
  bool isFavorite = false;
  LinearGradient backgroundGradient = const LinearGradient(
    colors: [Colors.black, Color(0xFF0D47A1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  void initState() {
    super.initState();
    _pickSongs(); // Seleccionar canciones al abrir la pantalla
  }

  Future<void> _pickSongs() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final songs = result.files.map((file) {
        final fileName = file.name;
        return Song(
          title: fileName,
          artist: 'Unknown Artist',
          albumArtPath: 'assets/images/track_placeholder.jpg',
          duration: '3:00', // Duración simulada, se actualizará con just_audio
          path: file.path!,
        );
      }).toList();

      context.read<MusicPlayerBloc>().add(LoadLocalSongs(songs));
    }
  }

  Future<void> _updateBackgroundGradient(String imagePath) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      FileImage(File(imagePath)),
      fallbackImageProvider: const AssetImage('assets/images/track_placeholder.jpg'),
    );

    setState(() {
      backgroundGradient = LinearGradient(
        colors: [
          paletteGenerator.dominantColor?.color ?? Colors.black,
          paletteGenerator.mutedColor?.color ?? const Color(0xFF0D47A1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    });
  }

  void _showMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: const [
        PopupMenuItem(value: 'share', child: Text('Share')),
        PopupMenuItem(value: 'add_to_playlist', child: Text('Add to Playlist')),
        PopupMenuItem(value: 'song_details', child: Text('Song Details')),
        PopupMenuItem(value: 'lyrics', child: Text('Lyrics')),
        PopupMenuItem(value: 'download', child: Text('Download')),
        PopupMenuItem(value: 'set_as_ringtone', child: Text('Set as Ringtone')),
      ],
    ).then((value) {
      if (value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: $value')),
        );
      }
    });
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).floor();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MusicPlayerBloc, MusicPlayerState>(
      listener: (context, state) {
        if (state is MusicPlayerLoaded) {
          _updateBackgroundGradient(state.songs[state.currentSongIndex].albumArtPath);
        }
        if (state is MusicPlayerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is MusicPlayerLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is MusicPlayerLoaded && state.songs.isNotEmpty) {
          final currentSong = state.songs[state.currentSongIndex];
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: backgroundGradient,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // AppBar personalizado
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                currentSong.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: _showMenu,
                          ),
                        ],
                      ),
                    ),
                    // Arte del álbum con fondo desenfocado
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Image.asset(
                                currentSong.albumArtPath,
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.5),
                                colorBlendMode: BlendMode.dstATop,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white24, width: 2),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  currentSong.albumArtPath,
                                  height: 280,
                                  width: 280,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 280,
                                    width: 280,
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.music_note,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Información de la canción
                    Text(
                      currentSong.artist,
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentSong.duration,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    // Barra de progreso
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: Column(
                        children: [
                          Slider(
                            value: state.currentPosition,
                            min: 0,
                            max: state.totalDuration,
                            activeColor: AppColors.primary,
                            inactiveColor: Colors.white30,
                            onChanged: (value) {
                              context.read<MusicPlayerBloc>().add(SeekSong(value));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(state.currentPosition),
                                style: const TextStyle(color: Colors.white70),
                              ),
                              Text(
                                _formatDuration(state.totalDuration),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Controles de reproducción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shuffle, color: Colors.white, size: 24),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Shuffle')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                          onPressed: () {
                            context.read<MusicPlayerBloc>().add(SkipPrevious());
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            state.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                          onPressed: () {
                            if (state.isPlaying) {
                              context.read<MusicPlayerBloc>().add(PauseSong());
                            } else {
                              context.read<MusicPlayerBloc>().add(PlaySong());
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                          onPressed: () {
                            context.read<MusicPlayerBloc>().add(SkipNext());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.repeat, color: Colors.white, size: 24),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Repeat')),
                            );
                          },
                        ),
                      ],
                    ),
                    // Controles adicionales (Favoritos y Volumen)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 24,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
                                  ),
                                ),
                              );
                            },
                          ),
                          Row(
                            children: [
                              const Icon(Icons.volume_down, color: Colors.white, size: 24),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 150,
                                child: Slider(
                                  value: volume,
                                  min: 0,
                                  max: 1,
                                  activeColor: AppColors.primary,
                                  inactiveColor: Colors.white30,
                                  onChanged: (value) {
                                    setState(() {
                                      volume = value;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Volume: ${(volume * 100).toInt()}%')),
                                    );
                                  },
                                ),
                              ),
                              const Icon(Icons.volume_up, color: Colors.white, size: 24),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: Text('No songs loaded', style: TextStyle(color: Colors.white)));
      },
    );
  }
}