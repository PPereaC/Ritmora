import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/background_tasks.dart';
import '../../domain/entities/song.dart';
import '../providers/song_player_provider.dart';
import '../providers/theme/theme_provider.dart';
import '../widgets/bottom_sheet_bar_widget.dart';


typedef SearchSongsCallback = Future<List<Song>> Function(String query);

class SearchSongsDelegate extends SearchDelegate<Song?> {

  final SearchSongsCallback searchSongs;
  List<Song> initialSongs;
  StreamController<List<Song>> debouncesSongs = StreamController.broadcast();
  Timer? _debounceTimer;
  final bool isDarkMode;

  SearchSongsDelegate({
    required this.searchSongs,
    required this.initialSongs,
    required this.isDarkMode,
   }): super(
    searchFieldLabel: 'Buscar canciones o videos',
    searchFieldStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white, // Color de fondo
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // Color de los iconos
        toolbarHeight: 60,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.grey),
        border: InputBorder.none,
        filled: true,
        fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

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
      color: isDarkMode ? Colors.grey[900] : Colors.white,
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
              onSongOptions: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return BottomSheetBarWidget(
                      song: songs[index],
                    );
                  },
                );
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
  final Function onSongOptions;

  const _SongItem({required this.song, required this.onSongSelected, required this.onSongOptions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkmode;
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return ListTile(
      onTap: () => onSongSelected(context, song),
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
        'Canción · ${song.author}',
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