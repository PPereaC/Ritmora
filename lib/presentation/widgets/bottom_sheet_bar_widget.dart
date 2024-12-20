// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:apolo/presentation/providers/playlist/playlist_repository_provider.dart';
import 'package:apolo/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';

class BottomSheetBarWidget extends ConsumerWidget {
  final Song song;

  const BottomSheetBarWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textStyle = Theme.of(context).textTheme;

    return Container(
      color: Colors.grey[900],
      height: MediaQuery.of(context).size.height * 0.44,
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
                ClipRRect(
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: textStyle.bodyLarge!.copyWith(color: Colors.white),
                      ),
                      Text(
                        song.author,
                        style: textStyle.bodyMedium!.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
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
                  Iconsax.voice_square_outline,
                  'Ecualizador',
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
        ],
      ),
    );
  }

  Widget _buildListOption(IconData icon, String title, TextTheme textStyle, Function onPressed) {
    return ListTile(
      leading: Icon(
        icon,
        size: 28,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: textStyle.titleLarge!.copyWith(color: Colors.white),
      ),
      onTap: () => onPressed(),
    );
  }
}