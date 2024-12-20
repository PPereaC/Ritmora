import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';
import '../../infrastructure/services/song_player_service.dart';

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

    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 68,
      child: Container(
        color:Colors.grey[900],
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
                colors: [Colors.grey[800]!,Colors.grey[800]!],
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
              
                // Título y autor
                title: Text(
                  currentSong.title,
                  style: textStyles.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  currentSong.author,
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
                  color: Colors.white
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}