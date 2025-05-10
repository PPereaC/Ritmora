// ignore_for_file: use_build_context_synchronously

import 'package:finmusic/presentation/providers/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/background_tasks.dart';
import '../../config/utils/constants.dart';
import '../../config/utils/pretty_print.dart';
import '../../domain/entities/song.dart';
import '../providers/playlist/playlist_provider.dart';
import 'widgets.dart';

class SongListTile extends ConsumerStatefulWidget {
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
  ConsumerState<SongListTile> createState() => _SongListTileState();
}

class _SongListTileState extends ConsumerState<SongListTile> {

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Dismissible(
      key: Key(widget.song.songId),
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
        ref.read(songPlayerProvider).addToQueue(widget.song);
        return false;
      },
      child: InkWell(
        onTap: () async {
          if (_isProcessing) return;
          _isProcessing = true;

          try {
            FocusScope.of(context).unfocus();
            ref.read(songPlayerProvider).pause();
            ref.read(loadingProvider.notifier).state = true;
            
            // Obtener la canción de la base de datos
            final result = await ref.read(playlistProvider.notifier).getSongFromDB(widget.song.songId);

            Song songToPlay = Song(
              title: 'NOSONG',
              author: 'NOAUTHOR',
              thumbnailUrl: 'NOURL',
              streamUrl: 'NOURL',
              endUrl: 'NOURL',
              songId: widget.song.songId,
              duration: 'NODURATION'
            );

            // Verificar si la canción existe en la base de datos
            if (result.title == 'NOBD' || await isStreamUrlExpired(result.streamUrl)) {
              
              // Si no está en la base de datos, intentar obtener URL de stream
              final streamUrl = await getStreamUrlInBackground(widget.song.songId);
              
              if (streamUrl == null) {
                if (!mounted) return;
                CustomSnackbar.show(
                  context,
                  'No se puede reproducir la canción',
                  Colors.red,
                  Iconsax.warning_2_outline
                );
                
                if (!mounted) return;
                ref.read(loadingProvider.notifier).state = false;
                _isProcessing = false;
                return;
              }

              // Crear nueva instancia de canción con URL de stream
              songToPlay = Song(
                title: widget.song.title,
                author: widget.song.author,
                thumbnailUrl: widget.song.thumbnailUrl,
                streamUrl: streamUrl,
                endUrl: widget.song.endUrl,
                songId: widget.song.songId,
                isLiked: widget.song.isLiked,
                duration: widget.song.duration,
                videoId: widget.song.videoId,
                isVideo: widget.song.isVideo,
              );
            } else {
              // Usar canción de la base de datos
              songToPlay = result;
            }

            if (!mounted) return;

            // Actualizar y reproducir
            ref.read(songPlayerProvider).updateCurrentSong(songToPlay);
            await Future.delayed(const Duration(milliseconds: 500));
            
            if (!mounted) return;
            await ref.read(songPlayerProvider).playSong(songToPlay);
            
            if (!mounted) return;
            ref.read(loadingProvider.notifier).state = false;
            _isProcessing = false;
          } catch (e) {
            if (!mounted) return;
            
            printERROR('Error al reproducir canción: $e');
            
            if (!mounted) return;
            ref.read(loadingProvider.notifier).state = false;
            _isProcessing = false;
            
            if (!mounted) return;
            CustomSnackbar.show(
              context,
              'Error al reproducir la canción',
              Colors.red,
              Iconsax.warning_2_outline
            );
          }
        },
        onLongPress: () => widget.onSongOptions(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 50,
                  maxHeight: widget.isVideo ? 45 : 60,
                ),
                child: AspectRatio(
                  aspectRatio: widget.isVideo ? 16/12 : 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.isPlaylist
                    ? CachedNetworkImage(
                      key: ValueKey(widget.song.thumbnailUrl),
                      imageUrl: widget.song.thumbnailUrl,
                      fit: widget.isVideo ? BoxFit.contain : BoxFit.cover,
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
                          fit: widget.isVideo ? BoxFit.contain : BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      ),
                      maxHeightDiskCache: 300,
                      httpHeaders: const {'Cache-Control': 'max-age=7200'},
                    )
                    : Image.network(
                      widget.song.thumbnailUrl,
                      fit: widget.isVideo ? BoxFit.contain : BoxFit.cover,
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
                            fit: widget.isVideo ? BoxFit.contain : BoxFit.cover,
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
                      widget.song.title,
                      style: textStyles.titleMedium!.copyWith(
                        color: Colors.white
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.song.author,
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
                onTap: () => widget.onSongOptions(),
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