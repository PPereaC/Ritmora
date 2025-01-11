import 'package:finmusic/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';

class QueueScreen extends ConsumerStatefulWidget {
  const QueueScreen({super.key});

  @override
  QueueScreenState createState() => QueueScreenState();
}

class QueueScreenState extends ConsumerState<QueueScreen> {
  final Set<int> _selectedSongs = {};

  @override
  Widget build(BuildContext context) {
    final songPlayer = ref.read(songPlayerProvider);
    final isPlaying = ref.watch(songPlayerProvider.select((player) => player.isPlaying));
    List<Song> queue = ref.watch(songPlayerProvider).queue;
    final currentSong = ref.watch(songPlayerProvider).currentSong;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_selectedSongs.isNotEmpty)
            IconButton(
              icon: const Icon(Iconsax.trash_outline, color: Colors.white),
              onPressed: () {
                final sortedIndices = _selectedSongs.toList()..sort((a, b) => b.compareTo(a));
                for (var index in sortedIndices) {
                  songPlayer.removeFromQueue(index);
                }
                setState(() => _selectedSongs.clear());
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Canción actual
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Título de la sección
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(
                  'Sonando',
                  style: textStyle.titleLarge
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black,
                  child: Row(
                    children: [              
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                            const BoxShadow(
                              color: Colors.white12,
                              blurRadius: 3,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white12,
                                width: 0.5,
                              ),
                            ),
                            child: Image.network(
                              currentSong!.thumbnailUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[900],
                                child: Image.asset(
                                  defaultPoster,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                )
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentSong.author,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Título de la sección
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'A continuación en la cola',
                style: textStyle.titleLarge
              ),
            ),
          ),

          // Lista de canciones en cola
          Expanded(
            child: ReorderableListView.builder(
              padding: EdgeInsets.zero,
              itemCount: queue.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  songPlayer.reorderQueue(oldIndex, newIndex);
                });
              },
              itemBuilder: (context, index) {
                final song = queue[index];
                final isSelected = _selectedSongs.contains(index);
          
                return ListTile(
                  key: ValueKey(song.songId),
                  contentPadding: const EdgeInsets.only(right: 8.0),
                  tileColor: Colors.black,
                  leading: IconButton(
                    icon: Icon(
                      isSelected ? Iconsax.tick_circle_outline : Icons.circle_outlined,
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSongs.remove(index);
                        } else {
                          _selectedSongs.add(index);
                        }
                      });
                    },
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    song.author,
                    style: TextStyle(color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.drag_handle, color: Colors.grey[600]),
                );
              },
            ),
          ),

          // Controles de reproducción
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  Icons.skip_previous,
                  () => songPlayer.playPrevious(),
                ),
                const SizedBox(width: 20),
                _buildControlButton(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  () => songPlayer.togglePlay(),
                  size: 50,
                ),
                const SizedBox(width: 20),
                _buildControlButton(
                  Icons.skip_next,
                  () => songPlayer.playNext(),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed, {double size = 30}) {
    return IconButton(
      iconSize: size,
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }

}