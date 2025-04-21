// ignore_for_file: deprecated_member_use

import 'dart:ui';

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

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface.withOpacity(0.8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de progreso como divisor superior
              StreamBuilder<Duration>(
                stream: playerService.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration?>(
                    stream: playerService.durationStream,
                    builder: (context, snapshot) {
                      final duration = snapshot.data ?? Duration.zero;
                      return SizedBox(
                        height: 2,
                        child: MusicProgressBar(
                          currentPosition: position,
                          duration: duration,
                          onChangeEnd: playerService.seek,
                        ),
                      );
                    },
                  );
                },
              ),
              
              // Contenido principal con padding vertical
              SizedBox(
                height: 65,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Sección izquierda - Info canción
                    Positioned(
                      left: 15,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.primary.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  currentSong.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[900],
                                      child: Image.asset(
                                        defaultPoster,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentSong.title,
                                    style: textStyles.titleSmall!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currentSong.author,
                                    style: textStyles.bodyMedium!.copyWith(
                                      color: Colors.white.withOpacity(0.7),
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
                
                    // Sección central - Controles
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tiempo actual
                        StreamBuilder<Duration>(
                          stream: playerService.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            return Text(
                              _formatDuration(position),
                              style: textStyles.bodySmall!.copyWith(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () => playerService.playPrevious(),
                          icon: Icon(
                            Iconsax.previous_outline,
                            color: Colors.white.withOpacity(0.7),
                            size: 24,
                          ),
                          splashRadius: 24,
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 42,
                          width: 42,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(21),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(21),
                              onTap: onPlayPause,
                              child: Icon(
                                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () => playerService.playNext(),
                          icon: Icon(
                            Iconsax.next_outline,
                            color: Colors.white.withOpacity(0.7),
                            size: 24,
                          ),
                          splashRadius: 24,
                        ),
                        const SizedBox(width: 16),
                        // Duración total
                        StreamBuilder<Duration?>(
                          stream: playerService.durationStream,
                          builder: (context, snapshot) {
                            final duration = snapshot.data ?? Duration.zero;
                            return Text(
                              _formatDuration(duration),
                              style: textStyles.bodySmall!.copyWith(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                
                    // Sección derecha - Control de cola
                    Positioned(
                      right: 24,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: onQueueButtonPressed,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Iconsax.music_square_outline,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
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
      
      final mostUsedColor = paletteGenerator.colors.reduce((value, element) {
        final valuePopulation = paletteGenerator.colors.where((color) => 
          color.value == value.value).length;
        final elementPopulation = paletteGenerator.colors.where((color) => 
          color.value == element.value).length;
        return valuePopulation > elementPopulation ? value : element;
      });
      
      final HSLColor hslColor = HSLColor.fromColor(mostUsedColor);
      final adjustedColor = hslColor
          .withSaturation(0.8)
          .withLightness(0.35)
          .toColor();
      
      ref.read(songColorProvider.notifier).updateColor(adjustedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateColorIfNeeded();
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Barra de progreso minimalista
                StreamBuilder<Duration>(
                  stream: playerService.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: playerService.durationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return Container(
                          height: 2,
                          child: Stack(
                            children: [
                              // Fondo de la barra
                              Container(
                                color: Colors.white.withOpacity(0.1),
                              ),
                              // Progreso
                              FractionallySizedBox(
                                widthFactor: duration.inSeconds > 0
                                    ? position.inSeconds / duration.inSeconds
                                    : 0,
                                child: Container(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                // Contenido principal
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                  child: Row(
                    children: [
                      // Thumbnail
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
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.currentSong.author,
                              style: widget.textStyles.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 12,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}