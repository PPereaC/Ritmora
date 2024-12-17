// ignore_for_file: use_build_context_synchronously

import 'package:apolo/presentation/providers/providers.dart';
import 'package:apolo/presentation/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/background_tasks.dart';
import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';

class SongListTile extends ConsumerWidget {

  final Song song;
  final Function onSongOptions;
  final bool isPlaylist;
  final bool isVideo;

  const SongListTile({
    super.key,
    required this.song,
    required this.onSongOptions,
    required this.isPlaylist,
    required this.isVideo
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isDarkMode = ref.watch(isDarkmodeProvider);
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () async {
        bool isPlayable = true;
        FocusScope.of(context).unfocus();
        
        await getStreamUrlInBackground(song.songId).then((url) {
          if (url == null) {
            CustomSnackbar.show(
              context,
              'No es posible reproducir esta canción',
              Colors.red,
              Iconsax.warning_2_outline,
              duration: 3,
            );
            isPlayable = false;
            return;
          }
          song.streamUrl = url;
        });
        
        if(isPlayable) {
          ref.read(songPlayerProvider).playSong(song);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
        child: Row(
          children: [
            // Thumbnail
            SizedBox(
              width: size.width * 0.13,
              child: AspectRatio(
                aspectRatio: isVideo ? 16/12 : 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: isPlaylist // Cachear las carátulas de las canciones solo si es una playlist
                  ? CachedNetworkImage(
                    key: ValueKey(song.thumbnailUrl),
                    imageUrl: song.thumbnailUrl,
                    fit: isVideo ? BoxFit.contain : BoxFit.cover,
                    memCacheWidth: 300,
                    maxWidthDiskCache: 300,
                    useOldImageOnUrlChange: true,
                    placeholderFadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 300),
                    placeholder: (context, url) => Center(
                      child: Image.asset(
                        defaultLoader,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                      child: Image.asset(
                        defaultPoster,
                        fit: isVideo ? BoxFit.contain : BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    ),
                    maxHeightDiskCache: 300,
                    // Timeout después de 10 segundos
                    httpHeaders: const {'Cache-Control': 'max-age=7200'},
                  )
                  : Image.network(
                    song.thumbnailUrl,
                    fit: isVideo ? BoxFit.contain : BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: Image.asset(
                            defaultLoader,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                        child: Image.asset(
                          defaultPoster,
                          fit: isVideo ? BoxFit.contain : BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      );
                    },
                  )
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Título y autor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    song.title,
                    style: textStyles.titleMedium!.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    song.author,
                    style: textStyles.bodyLarge!.copyWith(
                      color: Colors.grey
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Botón de opciones
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => onSongOptions(),
                icon: const Icon(
                  Iconsax.more_square_outline,
                  size: 23,
                ),
                color: isDarkMode ? Colors.white : Colors.black,
                padding: const EdgeInsets.only(left: 25),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}