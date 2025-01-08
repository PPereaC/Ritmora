import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';

class PlayerControlWidget extends ConsumerWidget {
  final Song currentSong;
  final playerService;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const PlayerControlWidget({
    super.key,
    required this.currentSong,
    required this.playerService,
    required this.isPlaying,
    required this.onPlayPause,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    var isFullPlayerOpened = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: colors.secondary,
            child: InkWell(
              onTap: () {
                if (!isFullPlayerOpened) {
                  context.push('/full-player');
                  isFullPlayerOpened = true;
                } else {
                  context.pushNamed('/full-player');
                }
              },
              onLongPress: () => context.push('/full-player'),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                child: Row(
                  children: [

                    // Thumbnail
                    SizedBox(
                      width: size.width * 0.12,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            currentSong.thumbnailUrl,
                            fit: BoxFit.cover,
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
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              );
                            },
                          )
                          
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 10),
                    
                    // Título y autor
                    SizedBox(
                      width: size.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentSong.title,
                            style: textStyles.titleMedium!.copyWith(
                              color: Colors.white
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentSong.author,
                            style: textStyles.bodyLarge!.copyWith(
                              color: Colors.white60
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Botón de opciones
                    IconButton(
                      onPressed: onPlayPause,
                      icon: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 30,
                      ),
                      color: Colors.white,
                      constraints: const BoxConstraints(),
                    ),

                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}