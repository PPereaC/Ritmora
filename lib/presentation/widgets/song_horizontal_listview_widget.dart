import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/song.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class SongHorizontalListview extends StatefulWidget {
  final List<Song> songs;

  const SongHorizontalListview({
    super.key, 
    required this.songs,
  });

  @override
  State<SongHorizontalListview> createState() => _SongHorizontalListviewState();
}

class _SongHorizontalListviewState extends State<SongHorizontalListview> {
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
              itemCount: widget.songs.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final song = widget.songs[index];
                // Padding específico según la posición
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 10 : 8,
                    right: index == widget.songs.length - 1 ? 10 : 0,
                  ),
                  child: FadeInRight(
                    child: _Slide(song: song)
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
  final Song song;
  const _Slide({required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    const double containerWidth = 120.0;
    final songPlayer = ref.watch(songPlayerProvider);

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: containerWidth,
        child: InkWell(
          onTap: () {
            songPlayer.playSong(song);
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomSheetBarWidget(
                  song: song,
                );
              },
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 40,
                        color: Colors.grey[700],
                      ),
                    );
                  },
                ),
              ),
                
              // Información
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      style: textStyles.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.author,
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