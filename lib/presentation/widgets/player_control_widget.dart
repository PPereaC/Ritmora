// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:palette_generator/palette_generator.dart';

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
    final playerService = ref.watch(songPlayerProvider);

    return StreamBuilder<bool>(
      stream: playerService.playingStream,
      builder: (context, snapshot) {
        final isCurrentlyPlaying = snapshot.data ?? false;

        if (Responsive.isMobile(context)) {
          return _MobilePlayerControl(
            colors: colors,
            size: size,
            currentSong: currentSong,
            textStyles: textStyles,
            onPlayPause: () => playerService.togglePlay(),
            isPlaying: isCurrentlyPlaying,
            onQueueButtonPressed: onQueueButtonPressed,
            onNextSong: onNextSong
          );
        } else if (Responsive.isTabletOrDesktop(context)) {
          return _DesktopPlayerControl(
            colors: colors,
            size: size,
            currentSong: currentSong,
            textStyles: textStyles,
            onPlayPause: () => playerService.togglePlay(),
            isPlaying: isCurrentlyPlaying,
            playerService: playerService,
            onQueueButtonPressed: onQueueButtonPressed,
          );
        } else {
          return const SizedBox.shrink();
        }
      }
    );
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

class _MobilePlayerControl extends ConsumerStatefulWidget {
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
    required this.onNextSong,
  });

  @override
  ConsumerState<_MobilePlayerControl> createState() => _MobilePlayerControlState();
}

class _MobilePlayerControlState extends ConsumerState<_MobilePlayerControl> {

  String? _lastSongId;

  Future<void> _updateColorIfNeeded() async {
    if (_lastSongId != widget.currentSong.songId) {
      _lastSongId = widget.currentSong.songId;
      
      final paletteGenerator = await PaletteGenerator.fromImageProvider(
        NetworkImage(widget.currentSong.thumbnailUrl),
        maximumColorCount: 20,
      );
      
      // Obtener el color dominante y ajustarlo
      final dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
      final HSLColor hslColor = HSLColor.fromColor(dominantColor);
      
      // Ajustar la saturación y el brillo para hacer el color más intenso
      final adjustedColor = hslColor
          .withSaturation(0.8)
          .withLightness(0.4)
          .toColor();
      
      ref.read(songColorProvider.notifier).updateColor(adjustedColor);
    }
  }

  @override
  Widget build(BuildContext context) {

    // Actualizar color si es necesario
    _updateColorIfNeeded();

    // Obtener el color actual del provider
    final backgroundColor = ref.watch(songColorProvider);
    final playerService = ref.watch(songPlayerProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => context.push('/full-player'),
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: widget.colors,
                  ),
                  child: const QueueBottomSheetBar(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 16),
              child: Row(
                children: [
                  // Thumbnail con sombra y bordes redondeados
                  Hero(
                    tag: 'current-song-thumbnail',
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          widget.currentSong.thumbnailUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[900],
                              child: const Icon(
                                Icons.music_note,
                                color: Colors.white30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      
                  const SizedBox(width: 12),
      
                  // Información de la canción
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.currentSong.title,
                          style: widget.textStyles.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.currentSong.author,
                          style: widget.textStyles.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
      
                  // Botón Play/Pause
                  StreamBuilder<bool>(
                    stream: playerService.playingStream,
                    builder: (context, snapshot) {
                      final isCurrentlyPlaying = snapshot.data ?? false;
                      
                      return IconButton(
                        onPressed: () => playerService.togglePlay(),
                        icon: Icon(
                          isCurrentlyPlaying 
                              ? Icons.pause_rounded 
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        padding: EdgeInsets.zero,
                        splashRadius: 24,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}