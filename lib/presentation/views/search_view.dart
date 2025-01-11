import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/song.dart';
import '../delegates/search_songs_delegate.dart';
import '../providers/providers.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  SearchViewState createState() => SearchViewState();
}

class SearchViewState extends ConsumerState<SearchView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSearch();
    });
  }

  void _showSearch() async {
    final colors = Theme.of(context).colorScheme;
    final searchSongs = ref.read(searchSongsProvider.notifier).searchSongsByQuery;

    final song = await showSearch<Song?>(
      context: context,
      delegate: SearchSongsDelegate(
        searchSongs: searchSongs,
        colors: colors,
      ),
    );

    // Manejar el resultado de la búsqueda
    if (song != null) {
      // Hacer algo con la canción seleccionada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
      ),
      body: const Center(
        child: Text('Buscar canciones o videos'),
      ),
    );
  }
}