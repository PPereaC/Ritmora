import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/song.dart';
import '../../providers/providers.dart';
import '../widgets.dart';

class SongGridHorizontalListview extends StatefulWidget {
  final List<Song> songs;

  const SongGridHorizontalListview({
    super.key,
    required this.songs,
  });

  @override
  State<SongGridHorizontalListview> createState() =>
      _SongGridHorizontalListviewState();
}

class _SongGridHorizontalListviewState
    extends State<SongGridHorizontalListview> {
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
    const double containerHeight = 70.0;
    const double spacing = 8.0;
    const totalHeight = (containerHeight * 3) + (spacing * 2);
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.85;

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
              left: columnIndex == 0 ? 0 : 8,
              right: columnIndex == groupedSongs.length - 1 ? 16 : 0,
            ),
            child: FadeInRight(
              child: SizedBox(
                width: containerWidth,
                child: Column(
                  children: [
                    for (var i = 0;
                        i < groupedSongs[columnIndex].length;
                        i++) ...[
                      if (i > 0) const SizedBox(height: spacing),
                      SizedBox(
                        height: containerHeight,
                        child: _Slide(
                          song: groupedSongs[columnIndex][i],
                          isLastItem: i == groupedSongs[columnIndex].length - 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Slide extends ConsumerWidget {
  final Song song;
  final bool isLastItem;

  const _Slide({required this.song, this.isLastItem = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
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
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.thumbnailUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),

            // Información
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyles.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyles.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
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
