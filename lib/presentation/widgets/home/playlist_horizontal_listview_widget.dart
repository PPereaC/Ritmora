import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/playlist.dart';

class PlaylistHorizontalListview extends StatefulWidget {
  final List<Playlist> playlists;

  const PlaylistHorizontalListview({
    super.key, 
    required this.playlists,
  });

  @override
  State<PlaylistHorizontalListview> createState() => _PlaylistHorizontalListviewState();
}

class _PlaylistHorizontalListviewState extends State<PlaylistHorizontalListview> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.playlists.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final playlist = widget.playlists[index];
                // Padding específico según la posición
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10 : 8,
                    right: index == widget.playlists.length - 1 ? 10 : 0,
                  ),
                  child: FadeInRight(
                    child: _Slide(playlist: playlist)
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends ConsumerWidget {
  final Playlist playlist;
  const _Slide({required this.playlist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    double containerWidth = 120;
    // final songPlayer = ref.watch(songPlayerProvider);
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: containerWidth,
        child: InkWell(
          onTap: () => {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  playlist.thumbnailUrl,
                  width: containerWidth,
                  height: containerWidth,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress != null) {
                      return Container(
                        width: containerWidth,
                        height: containerWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    return FadeIn(child: child);
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: containerWidth,
                      height: containerWidth,
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.nearby_error_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      playlist.title,
                      maxLines: 1,
                      style: textStyles.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      playlist.author,
                      style: textStyles.bodySmall?.copyWith(
                        color: Colors.grey[400],
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
    );
  }
}