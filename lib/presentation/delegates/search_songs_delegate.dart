import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../domain/entities/song.dart';
import '../widgets/widgets.dart';

typedef SearchSongsCallback = Future<List<Song>> Function(String query, {String filter});

class SearchSongsDelegate extends SearchDelegate<Song?> {
  final SearchSongsCallback searchSongs;
  final ValueNotifier<String> _queryNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _filterNotifier = ValueNotifier<String>('songs');
  Timer? _searchTimer;
  final ColorScheme colors;

  SearchSongsDelegate({
    required this.searchSongs,
    required this.colors,
  }) : super(
      searchFieldLabel: 'Buscar canciones o videos',
      searchFieldStyle: const TextStyle(color: Colors.white, fontSize: 20),
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: const TextTheme(
        titleMedium: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
        labelStyle: TextStyle(color: Colors.white),
        counterStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<List<Song>> _debouncedSearch(String query, String filter) async {
    _searchTimer?.cancel();

    if (query.isEmpty) return [];

    final completer = Completer<List<Song>>();

    if (Platform.isAndroid || Platform.isIOS) {
      _searchTimer = Timer(const Duration(milliseconds: 500), () async {
        try {
          _queryNotifier.value = query;
          final results = await searchSongs(query, filter: filter);
          if (!completer.isCompleted) {
            completer.complete(results);
          }
        } catch (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }
      });
    } else {
      _searchTimer = Timer(const Duration(milliseconds: 200), () async {
        try {
          _queryNotifier.value = query;
          final results = await searchSongs(query, filter: filter);
          if (!completer.isCompleted) {
            completer.complete(results);
          }
        } catch (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        }
      });
    }

    return completer.future;
  }

  void _onFilterChanged(String newFilter) {
    if (_filterNotifier.value != newFilter) {
      _filterNotifier.value = newFilter;
      // Forzar una nueva búsqueda con la query actual
      if (query.isNotEmpty) {
        // Actualizar el valor del notifier de query para forzar la reconstrucción
        _queryNotifier.value = query;
        // Llamar explícitamente a _debouncedSearch
        _debouncedSearch(query, newFilter);
      }
    }
  }

  @override 
  void showResults(BuildContext context) {
    // Forzar búsqueda inicial con filtro 'songs'
    _queryNotifier.value = query;
    _debouncedSearch(query, _filterNotifier.value);
    super.showResults(context);
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _queryNotifier.dispose();
    _filterNotifier.dispose();
    super.dispose();
  }

  Widget buildResultsAndSuggestions(ColorScheme colors) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder<String>(
            valueListenable: _filterNotifier,
            builder: (context, filter, _) {
              return Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _onFilterChanged('songs'),
                      icon: const Icon(
                        Iconsax.music_square_outline,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Canciones',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: filter == 'songs'
                            ? (colors.primary)
                            : (colors.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _onFilterChanged('videos'),
                      icon: const Icon(
                        Iconsax.video_play_outline,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Videos',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: filter == 'videos'
                            ? (colors.primary)
                            : (colors.secondary),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
            
        Expanded(
          child: ValueListenableBuilder<String>(
            valueListenable: _queryNotifier,
            builder: (context, query, _) {
              return ValueListenableBuilder<String>(
                valueListenable: _filterNotifier,
                builder: (context, filter, _) {
                  if (query.isEmpty) {
                    return const Center(
                      child: Text(
                        'Ingresa una búsqueda para ver resultados',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  
                  return FutureBuilder<List<Song>>(
                    // Agregar key única basada en query y filter para forzar la reconstrucción
                    key: ValueKey('$query-$filter'),
                    future: _debouncedSearch(query, filter),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No se encontraron resultados',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
            
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final song = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: SongListTile(
                              song: song,
                              onSongOptions: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => BottomSheetBarWidget(song: song),
                                );
                              },
                              isPlaylist: false,
                              isVideo: song.title.contains('Vídeo') || 
                                song.title.contains('Episodio') ||
                                song.author.contains('Vídeo') ||
                                song.author.contains('Episodio'),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        FadeIn(
          animate: query.isNotEmpty,
          child: IconButton(
            onPressed: () {
              query = '';
              _queryNotifier.value = '';
              _searchTimer?.cancel();
            },
            icon: const Icon(Iconsax.close_square_outline, color: Colors.white),
          ),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildResultsAndSuggestions(colors),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (query.isNotEmpty) {
      _queryNotifier.value = query;
      _debouncedSearch(query, _filterNotifier.value);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          buildResultsAndSuggestions(colors),
        ],
      ),
    );
  }
}