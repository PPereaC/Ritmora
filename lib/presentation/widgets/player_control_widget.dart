import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/song.dart';
import '../../infrastructure/services/song_player_service.dart';
import '../providers/theme/theme_provider.dart';

class PlayerControlWidget extends ConsumerWidget {
  final Song currentSong;
  final SongPlayerService playerService;
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

    final isDarkMode = ref.watch(themeNotifierProvider).isDarkmode;
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 68,
      child: Container(
        color: isDarkMode 
          ? Colors.grey[900]
          : Colors.grey,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                  isDarkMode ? Colors.grey[800]! : Colors.grey[400]!,
                ],
              ),
            ),
            child: GestureDetector(
              onTap: () {
                context.push('/full-player');
              },
              child: ListTile(
                // Imagen de la canción
                leading: SizedBox(
                  width: size.width * 0.12,
                  child: AspectRatio(
                    aspectRatio: 1, // Forzar forma cuadrada
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        currentSong.thumbnailUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) => 
                          FadeIn(child: child),
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              
                // Título y autor
                title: Text(
                  currentSong.title,
                  style: textStyles.bodyLarge!.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'Canción · ${currentSong.author}',
                  style: textStyles.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              
                // Botón play/pause
                trailing: IconButton(
                  onPressed: onPlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    size: 30,
                  ),
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}