import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

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
    final currentSong = playerService.currentSong;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
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
                // Barra superior mejorada
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                
                // Imagen de la canción con sombras
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02
                    ),
                    child: Hero(
                      tag: currentSong!.songId,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            currentSong.thumbnailUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, _) => Container(
                              color: Colors.grey[900],
                              child: const Icon(
                                Icons.music_note,
                                size: 80,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          
                // Sección de información y controles
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Título y artista
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
          
                      // Barra de progreso y tiempo
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
                                        // Esto se usará para actualizar el texto del tiempo
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
          
                      // Controles principales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            iconSize: 35,
                            icon: const Icon(Iconsax.previous_bold, color: Colors.white),
                            onPressed: () {},
                          ),
                          StreamBuilder<bool>(
                            stream: playerService.playingStream,
                            builder: (context, snapshot) {
                              final isPlaying = snapshot.data ?? false;
                              return IconButton(
                                iconSize: 64,
                                icon: Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () => playerService.togglePlay(),
                              );
                            },
                          ),
                          IconButton(
                            iconSize: 35,
                            icon: const Icon(Iconsax.next_bold, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      // Spacer para empujar los controles adicionales hacia abajo
                      const Spacer(flex: 2),

                      // Controles adicionales
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildControlButton(Iconsax.voice_square_outline, () {}),
                              _buildControlButton(Iconsax.music_square_outline, () {}),
                              _buildControlButton(Iconsax.setting_3_outline, () {}),
                            ],
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
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      iconSize: 30,
      icon: Icon(icon, color: Colors.white70),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(5),
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