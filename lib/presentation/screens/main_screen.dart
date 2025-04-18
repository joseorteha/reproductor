import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/presentation/screens/player_screen.dart';
import '../../blocs/music_player/music_player_bloc.dart';
import '../../core/constants/app_colors.dart';

class MainScreen extends StatefulWidget {
  final MusicPlayerBloc musicPlayerBloc;

  const MainScreen({super.key, required this.musicPlayerBloc});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0; // Para manejar la pestaña seleccionada

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for songs, artists...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implementar búsqueda real más adelante
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        const PopupMenuItem(
          value: 'settings',
          child: Text('Settings'),
        ),
        const PopupMenuItem(
          value: 'about',
          child: Text('About'),
        ),
        const PopupMenuItem(
          value: 'refresh',
          child: Text('Refresh'),
        ),
      ],
    ).then((value) {
      // TODO: Implementar acciones del menú más adelante
      if (value != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected: $value')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Music Player',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: _showMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de pestañas
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TabItem(
                  title: 'Playlists',
                  isSelected: _selectedTabIndex == 0,
                  onTap: () => _onTabSelected(0),
                ),
                TabItem(
                  title: 'Tracks',
                  isSelected: _selectedTabIndex == 1,
                  onTap: () => _onTabSelected(1),
                ),
                TabItem(
                  title: 'Artists',
                  isSelected: _selectedTabIndex == 2,
                  onTap: () => _onTabSelected(2),
                ),
              ],
            ),
          ),
          // Contenido desplazable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildTabContent(),
            ),
          ),
          // Mini Reproductor
          const MiniPlayer(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de tarjetas (Recently Played, Most Played)
            Row(
              children: [
                Expanded(
                  child: PlaylistCard(
                    title: 'Recently Played',
                    tracks: '50 tracks',
                    imagePath: 'assets/images/recently_played.jpg',
                    onTap: () {
                      // TODO: Navegar a lista de canciones recientes
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PlaylistCard(
                    title: 'Most Played',
                    tracks: '20 tracks',
                    imagePath: 'assets/images/most_played.jpg',
                    onTap: () {
                      // TODO: Navegar a lista de más reproducidas
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32), // Más espaciado
            // Lista de playlists
            const Text(
              'Your Playlists',
              style: TextStyle(
                fontSize: 20, // Texto más grande
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24), // Más espaciado
            PlaylistItem(
              title: 'Playlist 01',
              tracks: '24 tracks',
              imagePath: 'assets/images/playlist_01.jpg',
              onTap: () {
                // TODO: Navegar a playlist específica
              },
            ),
            PlaylistItem(
              title: 'Playlist 02',
              tracks: '3 tracks',
              imagePath: 'assets/images/playlist_02.jpg',
              onTap: () {},
            ),
            PlaylistItem(
              title: 'Playlist 03',
              tracks: '100 tracks',
              imagePath: 'assets/images/playlist_03.jpg',
              onTap: () {},
            ),
          ],
        );
      case 1:
        return const Center(
          child: Text(
            'Tracks Section',
            style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
          ),
        );
      case 2:
        return const Center(
          child: Text(
            'Artists Section',
            style: TextStyle(fontSize: 20, color: AppColors.textPrimary),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}

// Widget para las pestañas
class TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const TabItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 20,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// Widget para las tarjetas (Recently Played, Most Played)
class PlaylistCard extends StatelessWidget {
  final String title;
  final String tracks;
  final String imagePath;
  final VoidCallback onTap;

  const PlaylistCard({
    super.key,
    required this.title,
    required this.tracks,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 140, // Aumentamos el tamaño de la imagen
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              tracks,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para los elementos de la lista de playlists
class PlaylistItem extends StatelessWidget {
  final String title;
  final String tracks;
  final String imagePath;
  final VoidCallback onTap;

  const PlaylistItem({
    super.key,
    required this.title,
    required this.tracks,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12), // Más espaciado vertical
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                imagePath,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tracks,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Widget para el mini reproductor
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
      builder: (context, state) {
        if (state is MusicPlayerLoaded && state.songs.isNotEmpty) {
          final currentSong = state.songs[state.currentSongIndex];
          return Container(
            decoration: const BoxDecoration(
              gradient: AppColors.miniPlayerGradient,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    currentSong.albumArtPath,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentSong.artist,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white, size: 28),
                  onPressed: () {
                    context.read<MusicPlayerBloc>().add(SkipPrevious());
                  },
                ),
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
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
                  icon: const Icon(Icons.skip_next, color: Colors.white, size: 28),
                  onPressed: () {
                    context.read<MusicPlayerBloc>().add(SkipNext());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.expand_less, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PlayerScreen()),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}