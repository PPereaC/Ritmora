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
  @override
  Widget build(BuildContext context) {
    final playerService = ref.watch(songPlayerProvider);
    final currentSong = playerService.currentSong;
    final isPlaying = playerService.isPlaying;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! > 500) {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              // Barra superior con botón para cerrar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Iconsax.arrow_down_1_outline, color: Colors.white, size: 30),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              
              // Imagen de la canción
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      currentSong!.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Sección de progreso actualizada
              Expanded(
                flex: 2,
                child: Column(
                  children: [

                    // Título y artista
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            currentSong.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentSong.author,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

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
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: MusicProgressBar(
                                    currentPosition: position,
                                    duration: duration,
                                    onChanged: (position) {
                                      playerService.seek(position);
                                    },
                                    onChangeEnd: (position) {
                                      playerService.seek(position);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _formatDuration(position),
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                      Text(
                                        _formatDuration(duration),
                                        style: const TextStyle(color: Colors.white70),
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

                    // Controles de reproducción
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            iconSize: 35,
                            icon: const Icon(Iconsax.previous_bold, color: Colors.white),
                            onPressed: () {
                              // Implementar lógica de canción anterior
                            },
                          ),
                          IconButton(
                            iconSize: 50,
                            icon: Icon(
                              isPlaying ? Iconsax.pause_bold : Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () => playerService.togglePlay(),
                          ),
                          IconButton(
                            iconSize: 35,
                            icon: const Icon(Iconsax.next_bold, color: Colors.white),
                            onPressed: () {
                              // Implementar lógica de siguiente canción
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
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}