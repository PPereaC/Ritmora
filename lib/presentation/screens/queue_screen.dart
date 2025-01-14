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
                  style: textStyle.titleLarge!.copyWith(color: Colors.white)
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
                style: textStyle.titleLarge!.copyWith(color: Colors.white)
              ),
            ),
          ),

          // Lista de canciones en cola
          Expanded(
            child: StreamBuilder<List<Song>>(
              stream: songPlayer.queueStream.distinct(),
              initialData: songPlayer.queue,
              builder: (context, snapshot) {
                final queue = List<Song>.from(snapshot.data ?? []);
                
                if (queue.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay canciones en la cola',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ReorderableListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: queue.length,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < queue.length && newIndex <= queue.length) {
                      songPlayer.reorderQueue(oldIndex, newIndex);
                      setState(() {
                        // Actualizar selecciones
                        final selectedIndices = _selectedSongs.toList();
                        _selectedSongs.clear();
                        for (var index in selectedIndices) {
                          if (index == oldIndex) {
                            _selectedSongs.add(newIndex > oldIndex ? newIndex - 1 : newIndex);
                          } else if (index > oldIndex && index <= newIndex) {
                            _selectedSongs.add(index - 1);
                          } else if (index < oldIndex && index >= newIndex) {
                            _selectedSongs.add(index + 1);
                          } else {
                            _selectedSongs.add(index);
                          }
                        }
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    final song = queue[index];
                    final isSelected = _selectedSongs.contains(index);
        
                    return ListTile(
                      key: ValueKey('${song.songId}_$index'),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}