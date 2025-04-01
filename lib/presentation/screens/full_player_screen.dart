// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:finmusic/config/utils/pretty_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:marquee/marquee.dart';

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
                              const Text(
                                'FinMusic',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Titulo'
                                ),
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
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final size = constraints.maxWidth * 0.8;
                              return Center(
                                child: SizedBox(
                                  width: size,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.15),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.5),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                            offset: const Offset(0, 10),
                                          ),
                                          BoxShadow(
                                            color: Colors.white.withOpacity(0.15),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 0),
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
                                              )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                                    SizedBox(
                                      height: 35,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          // Crear un TextSpan para medir el ancho del texto
                                          final textSpan = TextSpan(
                                            text: currentSong.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.2,
                                            ),
                                          );
                                    
                                          // Usar TextPainter para calcular el ancho del texto
                                          final textPainter = TextPainter(
                                            text: textSpan,
                                            maxLines: 1,
                                            textDirection: TextDirection.ltr,
                                          )..layout(maxWidth: constraints.maxWidth);
                                    
                                          // Verificar si el texto excede el ancho disponible
                                          final isOverflow = textPainter.didExceedMaxLines;
                                    
                                          if (isOverflow) {
                                            // Si excede, usar Marquee
                                            return Marquee(
                                              text: currentSong.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.2,
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              blankSpace: 20.0,
                                              velocity: 30.0,
                                              pauseAfterRound: const Duration(seconds: 3),
                                              startPadding: 10.0,
                                              accelerationDuration: const Duration(seconds: 1),
                                              accelerationCurve: Curves.linear,
                                              decelerationDuration: const Duration(milliseconds: 500),
                                              decelerationCurve: Curves.easeOut,
                                            );
                                          } else {
                                            // Si no, mostrar texto estático
                                            return Text(
                                              currentSong.title,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.2,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          }
                                        },
                                      ),
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

                              SizedBox(height: screenHeight * 0.01),
                  
                              // Barra de progreso
                              Consumer(
                                builder: (context, ref, child) {
                                  final isLoading = ref.watch(loadingProvider);
                                  printINFO('Estado de carga en FullPlayerScreen: $isLoading');

                                  if (isLoading) {
                                    // Mostrar mensaje de carga mientras se obtiene el streamUrl
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 20,
                                          child: LoadingIndicator(
                                            indicatorType: Indicator.ballPulseSync,
                                            colors: [Colors.white.withOpacity(0.7)],
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Cargando canción...",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  // Mostrar barra de progreso y duración cuando no está cargando
                                  return StreamBuilder<Duration>(
                                    stream: playerService.positionStream,
                                    builder: (context, positionSnapshot) {
                                      return StreamBuilder<Duration?>(
                                        stream: playerService.durationStream,
                                        builder: (context, durationSnapshot) {
                                          final position = positionSnapshot.data ?? Duration.zero;
                                          final duration = durationSnapshot.data;

                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 23),
                                                child: MusicProgressBar(
                                                  currentPosition: position,
                                                  duration: duration ?? Duration.zero,
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
                                                      _formatDuration(duration ?? Duration.zero),
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
                                  );
                                },
                              ),

                              SizedBox(height: screenHeight * 0.02),
                  
                              // Controles de reproducción
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Iconsax.shuffle_outline),
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
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Iconsax.message_square_outline),
                                      iconSize: 30,
                                      color: Colors.white,
                                      onPressed: () {
                                        
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Iconsax.audio_square_outline),
                                      iconSize: 30,
                                      color: Colors.white,
                                      onPressed: () {
                                        
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Iconsax.music_square_outline),
                                      iconSize: 30,
                                      color: Colors.white,
                                      onPressed: () {
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
                                    ),
                                  ],
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