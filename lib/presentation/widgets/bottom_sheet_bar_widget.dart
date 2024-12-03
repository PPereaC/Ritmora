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

    final isDarkMode = ref.watch(isDarkmodeProvider);
    final textStyle = Theme.of(context).textTheme;

    return Container(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      height: MediaQuery.of(context).size.height * 0.44,
      child: Column(
        children: [

          // Indicador de arrastre
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Colors.grey,
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
                        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
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
                        style: textStyle.bodyLarge!.copyWith(color: isDarkMode ? Colors.white : Colors.black),
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
                  isDarkMode,
                  textStyle,
                  () {
                    ref.read(songPlayerProvider).addToQueue(song);
                    context.pop();
                  },
                ),
                _buildListOption(
                  Iconsax.play_circle_outline,
                  'Añadir a continuación',
                  isDarkMode,
                  textStyle,
                  () {
                    ref.read(songPlayerProvider).addNext(song);
                    context.pop();
                  },
                ),
                _buildListOption(
                  Iconsax.music_playlist_outline,
                  'Añadir a una playlist',
                  isDarkMode,
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
                  isDarkMode,
                  textStyle,
                  () {},
                ),
                _buildListOption(
                  Iconsax.cd_outline,
                  'Ver álbum',
                  isDarkMode,
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

  Widget _buildListOption(IconData icon, String title, bool isDarkMode, TextTheme textStyle, Function onPressed) {
    return ListTile(
      leading: Icon(
        icon,
        size: 28,
        color: isDarkMode ? Colors.grey : Colors.black,
      ),
      title: Text(
        title,
        style: textStyle.titleLarge!.copyWith(color: isDarkMode ? Colors.white : Colors.black),
      ),
      onTap: () => onPressed(),
    );
  }
}