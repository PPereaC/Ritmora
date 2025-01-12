import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../config/utils/constants.dart';
import '../providers/providers.dart';

class QueueSlidePanel extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const QueueSlidePanel({super.key, required this.onClose});

  @override
  QueueSlidePanelState createState() => QueueSlidePanelState();
}

class QueueSlidePanelState extends ConsumerState<QueueSlidePanel> {
  double _panelWidth = 300; // Ancho inicial del panel
  final double _minWidth = 300; // Ancho mínimo del panel
  final double _maxWidth = 400; // Ancho máximo del panel

  @override
  Widget build(BuildContext context) {
    final songPlayer = ref.read(songPlayerProvider);
    final queue = ref.watch(songPlayerProvider).queue;
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _panelWidth -= details.delta.dx;
          if (_panelWidth < _minWidth) _panelWidth = _minWidth;
          if (_panelWidth > _maxWidth) _panelWidth = _maxWidth;
        });
      },
      child: Container(
        width: _panelWidth,
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.8),
          border: Border(
            left: BorderSide(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
        ),
        child: Column(
          children: [
            // Header con título y botones
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cola de reproducción',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.grid_4_outline, color: Colors.white),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            // Lista reordenable
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

                  return ListTile(
                    key: ValueKey(song.songId),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        song.thumbnailUrl,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[900],
                            child: Image.asset(
                              defaultPoster,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      song.author,
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.drag_handle, color: Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}