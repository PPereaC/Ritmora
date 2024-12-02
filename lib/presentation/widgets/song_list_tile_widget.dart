import 'package:animate_do/animate_do.dart';
import 'package:apolo/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/background_tasks.dart';
import '../../domain/entities/song.dart';

class SongListTile extends ConsumerWidget {

  final Song song;
  final Function onSongOptions;

  const SongListTile({
    super.key,
    required this.song,
    required this.onSongOptions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isDarkMode = ref.watch(isDarkmodeProvider);
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () async {

        // Quitar el foco para ocultar el teclado
        FocusScope.of(context).unfocus();
        
        // Obtener el stream url de la canción en segundo plano
        await getStreamUrlInBackground(song.songId).then((streamUrl) {
          song.streamUrl = streamUrl!;
        });
        
        // Reproducir la canción
        ref.read(songPlayerProvider).playSong(song);
      },
      contentPadding: const EdgeInsets.only(left: 10, right: 0),
      // Imagen de la canción
      leading: SizedBox(
        width: size.width * 0.13,
        child: AspectRatio(
          aspectRatio: 1, // Forzar forma cuadrada
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              song.thumbnailUrl,
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
        song.title,
        style: textStyles.titleMedium!.copyWith(
          color: isDarkMode ? Colors.white : Colors.black
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        song.author,
        style: textStyles.bodyLarge!.copyWith(
          color: Colors.grey
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    
      // Botón de ajustes
      trailing: IconButton(
        onPressed: () => onSongOptions(),
        icon: const Icon(
          Iconsax.more_square_outline,
          size: 23,
        ),
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }
}