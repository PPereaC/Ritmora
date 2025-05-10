// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';
import '../providers/playlist/playlist_repository_provider.dart';
import '../providers/providers.dart';

class BottomSheetBarWidget extends ConsumerWidget {
  final Song song;

  const BottomSheetBarWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          left: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          right: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        )
      ),
      height: MediaQuery.of(context).size.height * 0.54,
      child: Column(
        children: [

          // Indicador de arrastre
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Información de la canción
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 55,
                      height: 55,
                      child: Image.network(
                        song.thumbnailUrl,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: textStyle.bodyLarge!.copyWith(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        song.author,
                        style: textStyle.bodyMedium!.copyWith(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildListOption(
                    Iconsax.music_filter_outline,
                    'Añadir a la cola',
                    textStyle,
                    () {
                      ref.read(songPlayerProvider).addToQueue(song);
                      context.pop();
                    },
                  ),
                  _buildListOption(
                    Iconsax.play_circle_outline,
                    'Añadir a continuación',
                    textStyle,
                    () {
                      ref.read(songPlayerProvider).addNext(song);
                      context.pop();
                    },
                  ),
                  _buildListOption(
                    Iconsax.music_playlist_outline,
                    'Añadir a una playlist',
                    textStyle,
                    () async {
              
                      // Obtener las playlists
                      final playlists = await ref.read(playlistRepositoryProvider).getPlaylists();
              
                      // Navegar y obtener el resultado (lista de ids de las playlists seleccionadas)
                      final selectedIds = await context.push<List<String>>(
                        '/select-playlist',
                        extra: playlists,
                      );
              
                      if (selectedIds == null) {
                        // No hacer nada si no se selecciona ninguna playlist
                      } else {
                        if (selectedIds.isNotEmpty) {
                          for (final id in selectedIds) {
                            await ref.read(playlistRepositoryProvider).addSongToPlaylist(context, int.parse(id), song);
                          }
                        }
                      }
                        
                    },
                  ),
                  _buildListOption(
                    Iconsax.heart_outline,
                    'Añadir a canciones que te gustan',
                    textStyle,
                    () {},
                  ),
                  _buildListOption(
                    Iconsax.cd_outline,
                    'Ver álbum',
                    textStyle,
                    () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListOption(IconData icon, String title, TextTheme textStyle, Function onPressed) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
      leading: Icon(
        icon,
        size: 24,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: textStyle.bodyLarge!.copyWith(
          color: Colors.white,
          fontSize: 18
        ),
      ),
      onTap: () => onPressed(),
    );
  }
}