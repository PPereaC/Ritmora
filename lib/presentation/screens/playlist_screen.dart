import 'package:apolo/presentation/providers/playlist/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../domain/entities/playlist.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  final String playlistID;

  const PlaylistScreen({super.key, required this.playlistID});

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  Future<Playlist> getPlaylistByID(String playlistID) async {
    final pID = int.parse(playlistID);
    final playlist = await ref.read(playlistProvider.notifier).getPlaylistByID(pID);
    return playlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.search_normal_1_outline, color: Colors.white),
                  onPressed: () {
                    // Acción de búsqueda
                  },
                ),
                IconButton(
                  icon: const Icon(Iconsax.setting_2_outline, color: Colors.white),
                  onPressed: () {
                    // Acción de más opciones
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<Playlist>(
        future: getPlaylistByID(widget.playlistID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró la playlist'));
          }

          final playlist = snapshot.data!;

          return Stack(
            children: [
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: PlaylistHeader(
                          title: playlist.title,
                          thumbnail: playlist.thumbnailUrl,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: playlist.songs.length,
                      itemBuilder: (context, index) {
                        final song = playlist.songs[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              song.thumbnailUrl,
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                            ),
                          ),
                          title: Text(
                            song.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            song.author,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[400],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              // Acción para mostrar opciones de la canción
                            },
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                          ),
                          onTap: () {
                            // Acción al tocar la canción
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Controlador de música fijo en la parte inferior
              // MusicController(musicPlayerProvider: musicPlayerProvider),
            ],
          );
        },
      ),
    );
  }
}

class PlaylistHeader extends StatelessWidget {
  final String title;
  final String thumbnail;

  const PlaylistHeader({
    super.key,
    required this.title, 
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                thumbnail,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.error, size: 200),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}