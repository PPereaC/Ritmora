// ignore_for_file: use_build_context_synchronously

import 'package:apolo/presentation/providers/providers.dart';
import 'package:apolo/presentation/widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/background_tasks.dart';
import '../../config/utils/constants.dart';
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

        bool isPlayable = true;

        // Quitar el foco para ocultar el teclado
        FocusScope.of(context).unfocus();
        
        // Obtener el stream url de la canción en segundo plano
        await getStreamUrlInBackground(song.songId).then((url) {
          if (url == null) {
            CustomSnackbar.show(
              context,
              'No es posible reproducir esta canción',
              Colors.red,
              Iconsax.warning_2_outline,
              duration: 3,
            );
            isPlayable = false;
            return;
          }
          song.streamUrl = url;
        });
        
        if(isPlayable) { // Reproducir la canción si no hay problemas
          ref.read(songPlayerProvider).playSong(song);
        }
        
      },
      contentPadding: const EdgeInsets.only(left: 10, right: 0),
      // Imagen de la canción
      leading: SizedBox(
        width: size.width * 0.13,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              key: ValueKey(song.thumbnailUrl),
              imageUrl: song.thumbnailUrl,
              fit: BoxFit.cover,
              memCacheWidth: 300,
              maxWidthDiskCache: 300,
              useOldImageOnUrlChange: true,
              placeholderFadeInDuration: const Duration(milliseconds: 300),
              fadeOutDuration: const Duration(milliseconds: 300),
              placeholder: (context, url) => Center(
                child: Image.asset(
                  defaultLoader,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                child: Image.asset(
                  defaultPoster,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )
              ),
              maxHeightDiskCache: 300,
              // Timeout después de 10 segundos
              httpHeaders: const {'Cache-Control': 'max-age=7200'},
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