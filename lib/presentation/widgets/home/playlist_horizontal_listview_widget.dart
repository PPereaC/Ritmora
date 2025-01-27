import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/playlist.dart';

class PlaylistHorizontalListview extends StatefulWidget {
  final List<Playlist> playlists;
  final Function(Playlist) onTap;

  const PlaylistHorizontalListview({
    super.key, 
    required this.playlists,
    required this.onTap,
  });

  @override
  State<PlaylistHorizontalListview> createState() => _PlaylistHorizontalListviewState();
}

class _PlaylistHorizontalListviewState extends State<PlaylistHorizontalListview> {
  final scrollController = ScrollController();
  // Definir tamaños constantes
  static const double containerHeight = 165.0;
  static const double imageSize = 120.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: containerHeight,
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
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10 : 8,
                    right: index == widget.playlists.length - 1 ? 10 : 0,
                  ),
                  child: InkWell(
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => widget.onTap(playlist),
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInRight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _Slide(
                          playlist: playlist,
                          width: imageSize,
                        ),
                      )
                    ),
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
  final double width;
  
  const _Slide({
    required this.playlist,
    required this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                playlist.thumbnailUrl,
                width: width,
                height: width,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return Container(
                      width: width,
                      height: width,
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
                    width: width,
                    height: width,
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
                  AutoSizeText(
                    playlist.title,
                    maxLines: 1,
                    style: textStyles.titleSmall?.copyWith(
                      fontSize: 14,
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
    );
  }
}