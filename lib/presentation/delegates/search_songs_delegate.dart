import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:apolo/config/utils/pretty_print.dart';
import 'package:apolo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../domain/entities/song.dart';


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
  
    if (debouncesSongs.isClosed) return;
  
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      try {
        final songs = await searchSongs(query);
        if (!debouncesSongs.isClosed) {
          initialSongs = songs;
          debouncesSongs.add(songs);
        }
      } catch (e) {
        printERROR('Error al buscar canciones: $e');
      }
    });
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    debouncesSongs.close();
    super.dispose();
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
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: SongListTile(
                  song: songs[index],
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
                ),
              );
            }
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

