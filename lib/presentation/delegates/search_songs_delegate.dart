import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/background_tasks.dart';
import '../../domain/entities/song.dart';
import '../providers/song_player_provider.dart';
import '../providers/theme/theme_provider.dart';


typedef SearchSongsCallback = Future<List<Song>> Function(String query);

class SearchSongsDelegate extends SearchDelegate<Song?> {

  final SearchSongsCallback searchSongs;
  List<Song> initialSongs;
  StreamController<List<Song>> debouncesSongs = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchSongsDelegate({
    required this.searchSongs,
    required this.initialSongs
  }): super(
    searchFieldLabel: 'Buscar canciones o videos'
  );

  void clearStreams() {
    debouncesSongs.close();
  }

  void _onQueryChanged(String query) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      final songs = await searchSongs(query);
      initialSongs = songs;
      debouncesSongs.add(songs);
    });
  }

  Widget buildResultsAndSuggestions (BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: StreamBuilder(
        initialData: initialSongs,
        stream: debouncesSongs.stream,
        builder: (context, snapshot) {

          final songs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) => _SongItem(
              song: songs[index],
              onSongSelected: (context, song) async {

                // Obtener el stream url de la canción en segundo plano
                await getStreamUrlInBackground(song.songId).then((streamUrl) {
                  song.streamUrl = streamUrl;
                  clearStreams();
                  close(context, song);
                });

                // Reproducir la canción
                context.read(songPlayerProvider).playSong(song);

              },
            )
          );

        },
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Buscar canción o video';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        FadeIn(
          animate: query.isNotEmpty,
          child: IconButton(
            onPressed: () => query = '',
            icon: const Icon(Iconsax.close_square_outline)
          ),
        )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_outlined)
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return buildResultsAndSuggestions(context);

  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return buildResultsAndSuggestions(context);

  }
}

class _SongItem extends ConsumerWidget {

  final Song song;
  final Function onSongSelected;

  const _SongItem({required this.song, required this.onSongSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkmode;
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

      return GestureDetector(
        onTap: () {
          onSongSelected(context, song);
        },
        child: Column(
          children: [

            // Información de la canción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
            
                  // Imagen de la canción
                  SizedBox(
                    width: size.width * 0.14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        song.thumbnailUrl,
                        loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      ),
                    ),
                  ),
            
                  const SizedBox(width: 5),
            
                  // Detalles de la canción
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de la canción
                          Text(
                            song.title,
                            style: textStyles.titleMedium!.copyWith(
                              color: isDarkMode ? Colors.white : Colors.black
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis
                          ),
            
                          // Autor de la canción
                          Text(
                            'Canción · ${song.author}',
                            style: textStyles.bodyLarge!.copyWith(
                              color: Colors.grey
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
            
                          const SizedBox(height: 5),
            
                        ],
                      ),
                    ),
                  ),

                  // Icono de ajustes de la canción
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Iconsax.more_square_outline,
                      size: 23,
                    ),
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),

                ],
              ),
            ),

            // Separador
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Divider(
                color: Colors.grey,
                thickness: 0.3,
                height: 1,
              ),
            ),

          ],
        ),
      );
  }
}