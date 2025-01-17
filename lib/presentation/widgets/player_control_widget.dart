import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/constants.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/song.dart';
import '../../infrastructure/services/base_player_service.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class PlayerControlWidget extends ConsumerWidget {
  final Song currentSong;
  // ignore: prefer_typing_uninitialized_variables
  final playerService;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onQueueButtonPressed;
  final VoidCallback onNextSong;
  final VoidCallback onPreviousSong;

  const PlayerControlWidget({
    super.key,
    required this.currentSong,
    required this.playerService,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onQueueButtonPressed,
    required this.onNextSong,
    required this.onPreviousSong
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final playerService = ref.read(songPlayerProvider);

    if (Responsive.isMobile(context)) {
      return _MobilePlayerControl(
        colors: colors,
        size: size,
        currentSong: currentSong,
        textStyles: textStyles,
        onPlayPause: onPlayPause,
        isPlaying: isPlaying,
        onQueueButtonPressed: onQueueButtonPressed,
        onNextSong: onNextSong
      );
    } else if (Responsive.isTabletOrDesktop(context)) {
      return _DesktopPlayerControl(
        colors: colors,
        size: size,
        currentSong: currentSong,
        textStyles: textStyles,
        onPlayPause: onPlayPause,
        isPlaying: isPlaying,
        playerService: playerService,
        onQueueButtonPressed: onQueueButtonPressed,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _DesktopPlayerControl extends ConsumerWidget {

  final ColorScheme colors;
  final Size size;
  final Song currentSong;
  final TextTheme textStyles;
  final VoidCallback onPlayPause;
  final bool isPlaying;
  final BasePlayerService playerService;
  final VoidCallback onQueueButtonPressed;

  const _DesktopPlayerControl({
    required this.colors,
    required this.size,
    required this.currentSong,
    required this.textStyles,
    required this.onPlayPause,
    required this.isPlaying,
    required this.playerService,
    required this.onQueueButtonPressed,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final playerService = ref.watch(songPlayerProvider);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Sección izquierda - Info canción
          SizedBox(
            width: size.width * 0.25,
            child: Row(
              children: [

                const SizedBox(width: 12),

                SizedBox(
                  width: 55,
                  height: 55,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      currentSong.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[900],
                          child: Image.asset(
                            defaultPoster,
                            fit: BoxFit.cover,
                          )
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentSong.title,
                        style: textStyles.titleSmall!.copyWith(
                          color: Colors.white
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentSong.author,
                        style: textStyles.bodyMedium!.copyWith(
                          color: Colors.white60
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
  
          // Sección central - Controles y barra
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Controles
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    IconButton(
                      onPressed: () => playerService.playPrevious(),
                      icon: const Icon(Iconsax.previous_bold),
                      color: Colors.white,
                      iconSize: 25,
                    ),

                    const SizedBox(width: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: onPlayPause,
                          icon: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 30,
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    IconButton(
                      onPressed: () => playerService.playNext(),
                      icon: const Icon(Iconsax.next_bold),
                      color: Colors.white,
                      iconSize: 25,
                    ),

                  ],
                ),

                const SizedBox(height: 8),
                
                // Barra de progreso
                SizedBox(
                  width: size.width * 0.3,
                  child: StreamBuilder<Duration>(
                    stream: playerService.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return StreamBuilder<Duration?>(
                        stream: playerService.durationStream,
                        builder: (context, snapshot) {
                          final duration = snapshot.data ?? Duration.zero;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatDuration(position),
                                style: textStyles.bodySmall!.copyWith(
                                  color: Colors.white70,
                                  fontSize: 11
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 3,
                                  child: MusicProgressBar(
                                    currentPosition: position,
                                    duration: duration,
                                    onChangeEnd: (position) {
                                      playerService.seek(position);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDuration(duration),
                                style: textStyles.bodySmall!.copyWith(
                                  color: Colors.white70,
                                  fontSize: 11
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
  
          // Sección derecha - Boton de cola
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: SizedBox(
              width: size.width * 0.25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onQueueButtonPressed,
                    icon: const Icon(Iconsax.music_square_outline),
                    color: Colors.white,
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobilePlayerControl extends StatelessWidget {
  
  final ColorScheme colors;
  final Size size;
  final Song currentSong;
  final TextTheme textStyles;
  final VoidCallback onPlayPause;
  final bool isPlaying;
  final VoidCallback onQueueButtonPressed;
  final VoidCallback onNextSong;
  
  const _MobilePlayerControl({
    required this.colors,
    required this.size,
    required this.currentSong,
    required this.textStyles,
    required this.onPlayPause,
    required this.isPlaying,
    required this.onQueueButtonPressed,
    required this.onNextSong
  });

  @override
  Widget build(BuildContext context) {

    var isFullPlayerOpened = false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            onNextSong();
          }
        },
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
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: colors,
                      ),
                      child: const QueueBottomSheetBar()
                    ),
                  );
                },
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
                )
              )
            ),
          ),
        ),
      ),
    );
  }
}