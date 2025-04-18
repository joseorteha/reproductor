import 'package:flutter/material.dart';
import '../../blocs/music_player/music_player_bloc.dart';
import '../../blocs/music_player/music_player_event.dart';
import '../../blocs/music_player/music_player_state.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/song_tile.dart';
import 'player_screen.dart';

// Pantalla principal que muestra la lista de canciones
class MainScreen extends StatefulWidget {
  final MusicPlayerBloc musicPlayerBloc;

  const MainScreen({super.key, required this.musicPlayerBloc});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    widget.musicPlayerBloc.add(const LoadSongsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproductor de Música'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder<MusicPlayerState>(
                    valueListenable: widget.musicPlayerBloc.state,
                    builder: (context, state, _) {
                      if (state is MusicPlayerLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is MusicPlayerLoaded) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: state.songs.length,
                          itemBuilder: (context, index) {
                            return SongTile(
                              song: state.songs[index],
                              musicPlayerBloc: widget.musicPlayerBloc,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlayerScreen(
                                      musicPlayerBloc: widget.musicPlayerBloc,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is MusicPlayerError) {
                        return Center(child: Text(state.message));
                      }
                      return const Center(child: Text('No hay canciones'));
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}