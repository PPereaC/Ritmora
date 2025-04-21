// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';
import '../providers/providers.dart';

class QueueSlidePanel extends ConsumerWidget {
  final VoidCallback onClose;

  const QueueSlidePanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final songPlayer = ref.watch(songPlayerProvider);

    return Stack(
      children: [
        // Overlay oscuro que cubre toda la pantalla
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
        // Panel de cola deslizable
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 350,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tween: Tween(begin: 1.0, end: 0.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(350 * value, 0),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.surface.withOpacity(0.95),
                    border: Border(
                      left: BorderSide(
                        color: colors.primary.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Separador vertical
                      Container(
                        width: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      // Contenido principal
                      Expanded(
                        child: Column(
                          children: [
                            // Header con título y botón de cierre
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: colors.surface.withOpacity(0.5),
                                border: Border(
                                  bottom: BorderSide(
                                    color: colors.primary.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Cola de reproducción',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Iconsax.close_circle_outline),
                                    color: Colors.white70,
                                    onPressed: onClose,
                                    tooltip: 'Cerrar cola',
                                    splashRadius: 24,
                                  ),
                                ],
                              ),
                            ),
                            
                            // Separador visual
                            Divider(
                              height: 1,
                              thickness: 3,
                              color: colors.primary,
                            ),

                            // Lista de canciones en cola
                            Expanded(
                              child: StreamBuilder<List<Song>>(
                                stream: songPlayer.queueStream,
                                initialData: songPlayer.queue,
                                builder: (context, snapshot) {
                                  final queue = snapshot.data ?? [];

                                  if (queue.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Iconsax.music_square_outline,
                                            size: 48,
                                            color: colors.primary,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No hay canciones en cola',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return ReorderableListView.builder(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    itemCount: queue.length,
                                    onReorder: (oldIndex, newIndex) {
                                      songPlayer.reorderQueue(oldIndex, newIndex);
                                    },
                                    itemBuilder: (context, index) {
                                      final song = queue[index];
                                      return Material(
                                        key: ValueKey(song.songId),
                                        color: Colors.transparent,
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 4,
                                          ),
                                          leading: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              song.thumbnailUrl,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[900],
                                                  child: Image.asset(
                                                    defaultPoster,
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          title: Text(
                                            song.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            song.author,
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: const Icon(
                                            Icons.drag_handle,
                                            color: Colors.white54,
                                            size: 20,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}