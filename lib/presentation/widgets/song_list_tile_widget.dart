// ignore_for_file: use_build_context_synchronously

import 'package:finmusic/presentation/providers/providers.dart';
import 'package:finmusic/presentation/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    final textStyles = Theme.of(context).textTheme;

    return Dismissible(
      key: Key(song.songId),
      direction: DismissDirection.startToEnd,
      dismissThresholds: const { DismissDirection.startToEnd: 0.05 },
      background: Container(
        width: 50,
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Icon(Icons.playlist_add, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        ref.read(songPlayerProvider).addToQueue(song);
        return false;
      },
      child: InkWell(
        onTap: () async {
          FocusScope.of(context).unfocus();
          
          // Detener reproducción actual
          ref.read(songPlayerProvider).pause();

          // Poner como loading
          ref.read(loadingProvider.notifier).state = true;
          
          // Actualizar la canción actual antes de obtener la URL
          ref.read(songPlayerProvider).updateCurrentSong(song);
          
          // Navegar al full player
          context.push('/full-player');
          
          // Obtener URL y reproducir en segundo plano
          try {
            final url = await getStreamUrlInBackground(song.songId);
            if (url == null) {
              CustomSnackbar.show(
                context,
                'No es posible reproducir esta canción',
                Colors.red,
                Iconsax.warning_2_outline,
                duration: 3,
              );
              ref.read(loadingProvider.notifier).state = false;
              return;
            }
            
            song.streamUrl = url;
            ref.read(loadingProvider.notifier).state = false;
            await ref.read(songPlayerProvider).playSong(song);
          } catch (e) {
            ref.read(loadingProvider.notifier).state = false;
            rethrow;
          }
        },
        onLongPress: () => onSongOptions(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 50,
                  maxHeight: isVideo ? 45 : 60,
                ),
                child: AspectRatio(
                  aspectRatio: isVideo ? 16/12 : 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: isPlaylist
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
                        color: Colors.grey[900],
                        child: Image.asset(
                          defaultPoster,
                          fit: isVideo ? BoxFit.contain : BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      ),
                      maxHeightDiskCache: 300,
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
                          color: Colors.grey[900],
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

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      song.title,
                      style: textStyles.titleMedium!.copyWith(
                        color: Colors.white
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

              InkWell(
                onTap: () => onSongOptions(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Iconsax.more_circle_outline,
                      size: 23,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}