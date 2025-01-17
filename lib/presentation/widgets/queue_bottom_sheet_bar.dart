import 'package:finmusic/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/constants.dart';
import '../../config/utils/pretty_print.dart';
import '../../domain/entities/song.dart';

class QueueBottomSheetBar extends ConsumerStatefulWidget {
  const QueueBottomSheetBar({super.key});

  @override
  QueueBottomSheetBarState createState() => QueueBottomSheetBarState();
}

class QueueBottomSheetBarState extends ConsumerState<QueueBottomSheetBar> {

  final Set<int> _selectedSongs = {};
  bool _isReordering = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final songPlayer = ref.watch(songPlayerProvider);
    final width = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.54, // Tamaño inicial (54% de la pantalla)
      minChildSize: 0.50, // Tamaño mínimo
      maxChildSize: 0.90, // Tamaño máximo (90% de la pantalla)
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              left: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              right: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [

              // Indicador de arrastre
              Container(
                margin: EdgeInsets.only(left: width * 0.44, right: width * 0.44, top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Título
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 12),
                child: Text(
                  'Cola de reproducción',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Canción actual sonando
              StreamBuilder(
                stream: songPlayer.currentSongStream,
                initialData: songPlayer.currentSong,
                builder: (context, snapshot) {
                  final currentSong = snapshot.data;
                  if (currentSong == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Container(
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
                            child: Stack(
                              alignment: Alignment.center,
                              children: [

                                // Carátula de la canción
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white12,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Opacity(
                                      opacity: 0.8,
                                      child: Image.network(
                                        currentSong.thumbnailUrl,
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
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Wave en el centro de la carátula
                                const Align(
                                  alignment: Alignment.center,
                                  child: SpinKitWave(
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Información de la canción
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currentSong.author,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Botón de play/pause
                          StreamBuilder<bool>(
                            stream: songPlayer.playingStream,
                            builder: (context, snapshot) {
                              final isPlaying = snapshot.data ?? false;
                              return SizedBox(
                                width: 40,
                                height: 40,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                  child: Container(
                                    color: Colors.white,
                                    child: IconButton(
                                      iconSize: 23,
                                      icon: Icon(
                                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                        color: Colors.black,
                                      ),
                                      onPressed: () => songPlayer.togglePlay(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Lista de canciones en cola
              StreamBuilder<List<Song>>(
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

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        ReorderableListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: queue.length,
                          onReorder: (oldIndex, newIndex) async {
                            printINFO('Reordering queue: $oldIndex -> $newIndex');
                            songPlayer.reorderQueue(oldIndex, newIndex);
                          },
                          itemBuilder: (context, index) {
                            final song = queue[index];
                                  
                            return ListTile(
                              key: ValueKey('${song.songId}_$index'),
                              contentPadding: const EdgeInsets.only(right: 8.0),
                              tileColor: Colors.black,
                              leading: Container(
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
                                      song.thumbnailUrl,
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
                              title: Text(
                                song.title,
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.author,
                                style: const TextStyle(color: Colors.grey, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(
                                Iconsax.menu_1_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            );
                          }
                        )
                      ]
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}