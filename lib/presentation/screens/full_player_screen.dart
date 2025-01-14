import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class FullPlayerScreen extends ConsumerStatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  FullPlayerScreenState createState() => FullPlayerScreenState();
}

class FullPlayerScreenState extends ConsumerState<FullPlayerScreen> {
  double _dragDistance = 0;
  Duration? _currentDraggingPosition;

  @override
  Widget build(BuildContext context) {
    final playerService = ref.watch(songPlayerProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [

          const GradientWidget(),

          StreamBuilder<Song?>(
            stream: playerService.currentSongStream,
            builder: (context, snapshot) {
              final currentSong = snapshot.data ?? playerService.currentSong;
              if (currentSong == null) return const SizedBox.shrink();
              // final nextSongs = playerService.getNextSongs(3);
          
              return GestureDetector(
                onVerticalDragStart: (_) {
                  setState(() => _dragDistance = 0);
                },
                onVerticalDragUpdate: (details) {
                  setState(() {
                    _dragDistance += details.delta.dy;
                    if (_dragDistance < 0) _dragDistance = 0;
                  });
                },
                onVerticalDragEnd: (details) {
                  if (_dragDistance > screenHeight / 3) {
                    context.pop();
                  } else {
                    setState(() => _dragDistance = 0);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.translationValues(0, _dragDistance, 0),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Header con botones
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Iconsax.arrow_down_1_outline, 
                                  color: Colors.white, 
                                  size: 28
                                ),
                                onPressed: () => context.pop(),
                              ),
                              IconButton(
                                icon: const Icon(Iconsax.more_outline, 
                                  color: Colors.white, 
                                  size: 28
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        
                        // Carátula de la canción
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.09,
                              vertical: screenHeight * 0.04
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Hero(
                              tag: currentSong.songId,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  currentSong.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return FadeIn(child: child);
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, _) => Container(
                                    color: Colors.grey[900],
                                    child: Image.asset(
                                      defaultPoster,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Información de la canción
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      currentSong.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.2,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      currentSong.author,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 18,
                                        letterSpacing: 0.1,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.02),
                  
                              // Barra de progreso
                              StreamBuilder<Duration>(
                                stream: playerService.positionStream,
                                builder: (context, positionSnapshot) {
                                  return StreamBuilder<Duration?>(
                                    stream: playerService.durationStream,
                                    builder: (context, durationSnapshot) {
                                      final position = positionSnapshot.data ?? Duration.zero;
                                      final duration = durationSnapshot.data ?? Duration.zero;
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 23),
                                            child: MusicProgressBar(
                                              currentPosition: position,
                                              duration: duration,
                                              onChanged: (newPosition) {
                                                setState(() {
                                                  _currentDraggingPosition = newPosition;
                                                });
                                              },
                                              onChangeEnd: (position) {
                                                playerService.seek(position);
                                                setState(() {
                                                  _currentDraggingPosition = null;
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  _formatDuration(_currentDraggingPosition ?? position),
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                Text(
                                                  _formatDuration(duration),
                                                  style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),

                              SizedBox(height: screenHeight * 0.02),
                  
                              // Controles de reproducción
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Iconsax.radio_outline),
                                    iconSize: 30,
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    iconSize: 35,
                                    icon: const Icon(Iconsax.previous_bold, color: Colors.white),
                                    onPressed: () => playerService.playPrevious(),
                                  ),
                                  StreamBuilder<bool>(
                                    stream: playerService.playingStream,
                                    builder: (context, snapshot) {
                                      final isPlaying = snapshot.data ?? false;
                                      return ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        child: Container(
                                          color: colors.secondary,
                                          child: IconButton(
                                            iconSize: 50,
                                            icon: Icon(
                                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => playerService.togglePlay(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 35,
                                    icon: const Icon(Iconsax.next_bold, color: Colors.white),
                                    onPressed: () => playerService.playNext(),
                                  ),
                                  IconButton(
                                    icon: const Icon(Iconsax.heart_outline),
                                    iconSize: 30,
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ],
                              ),

                              const Spacer(),
          
                              // Barra de opciones
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onVerticalDragEnd: (details) {
                                        // Si el usuario desliza hacia arriba
                                        if (details.primaryVelocity! < 0) { 
                                          context.push('/queue');
                                        }
                                      },
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                        child: Container(
                                          color: colors.secondary,
                                          height: 60,
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(top: 8),
                                                width: 40,
                                                height: 4,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              const Center(
                                                child: Text(
                                                  'Desliza hacia arriba para abrir la cola',
                                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}