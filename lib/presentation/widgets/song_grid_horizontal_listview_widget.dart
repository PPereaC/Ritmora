import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/song.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class SongGridHorizontalListview extends StatefulWidget {
  final List<Song> songs;

  const SongGridHorizontalListview({
    super.key, 
    required this.songs,
  });

  @override
  State<SongGridHorizontalListview> createState() => _SongGridHorizontalListviewState();
}

class _SongGridHorizontalListviewState extends State<SongGridHorizontalListview> {
  final scrollController = ScrollController();

  List<List<Song>> _getGroupedSongs() {
    final List<List<Song>> groupedSongs = [];
    for (var i = 0; i < widget.songs.length; i += 3) {
      final end = (i + 3 <= widget.songs.length) ? i + 3 : widget.songs.length;
      groupedSongs.add(widget.songs.sublist(i, end));
    }
    return groupedSongs;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedSongs = _getGroupedSongs();
    const double containerHeight = 80.0; // Altura por canción
    const totalHeight = containerHeight * 3; // 3 canciones por columna

    return SizedBox(
      height: totalHeight,
      child: ListView.builder(
        controller: scrollController,
        itemCount: groupedSongs.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, columnIndex) {
          return Padding(
            padding: EdgeInsets.only(
              left: columnIndex == 0 ? 10 : 8,
              right: columnIndex == groupedSongs.length - 1 ? 10 : 0,
            ),
            child: FadeInRight(
              child: _SongColumn(songs: groupedSongs[columnIndex])
            ),
          );
        },
      ),
    );
  }
}

class _SongColumn extends ConsumerWidget {
  final List<Song> songs;
  const _SongColumn({required this.songs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidht = MediaQuery.of(context).size.width;
    double containerWidth = screenWidht * 0.85;

    return SizedBox(
      width: containerWidth,
      child: Column(
        children: songs.map((song) => 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _Slide(song: song),
          )
        ).toList(),
      ),
    );
  }
}

class _Slide extends ConsumerWidget {
  final Song song;
  const _Slide({required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    const double containerWidth = 60.0;
    final songPlayer = ref.watch(songPlayerProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => songPlayer.playSong(song),
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => BottomSheetBarWidget(song: song),
          );
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song.thumbnailUrl,
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
                          borderRadius: BorderRadius.circular(8),
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
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 30,
                        color: Colors.grey[700],
                      ),
                    );
                  },
                ),
              ),
              
              // Información
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      style: textStyles.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.author,
                      style: textStyles.bodySmall?.copyWith(
                        color: Colors.grey[400],
                        fontSize: 12,
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