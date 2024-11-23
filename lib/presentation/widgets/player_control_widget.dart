import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

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

    return Positioned(
      left: 0,
      right: 0,
      bottom: 12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
                  isDarkMode ? Colors.grey[900]! : Colors.grey[400]!,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode 
                    ? Colors.black.withOpacity(0.3) 
                    : Colors.grey.withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                context.go('/full-player');
              },
              child: ListTile(
                
                // Imagen de la canción
                leading: SizedBox(
                  width: size.width * 0.14,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      currentSong.thumbnailUrl,
                      loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.error),
                    ),
                  ),
                ),
              
                // Título y autor
                title: Text(
                  currentSong.title,
                  style: textStyles.titleMedium!.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'Canción · ${currentSong.author}',
                  style: textStyles.bodyLarge!.copyWith(
                    color: Colors.grey
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              
                // Botón play/pause
                trailing: IconButton(
                  onPressed: () => onPlayPause(),
                  icon: Icon(
                    isPlaying ? Iconsax.pause_bold : Iconsax.play_bold,
                    size: 28,
                  ),
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              
              ),
            ),
          ),
        )
      ),
    );
  }
}