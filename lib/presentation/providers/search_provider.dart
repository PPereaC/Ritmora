import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/song.dart';
import 'search_repository_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchSongsProvider = StateNotifierProvider<SearchedSongsNotifier, List<Song>>((ref) {

  final songRepository = ref.read(songRepositoryProvider);

  return SearchedSongsNotifier(
    searchSongs: songRepository.searchSongs,
    ref: ref
  );
});

typedef SearchSongsCallback = Future<List<Song>> Function(String query, String filter);

class SearchedSongsNotifier extends StateNotifier<List<Song>> {

  final SearchSongsCallback searchSongs;
  final Ref ref;
  String _lastQuery = '';

  SearchedSongsNotifier({
    required this.searchSongs,
    required this.ref
  }) : super([]);

  Future<List<Song>> searchSongsByQuery(String query, { String filter = "songs" }) async {

    // Si el query es igual al último y tenemos resultados, devolvemos el cache
    if (query == _lastQuery && state.isNotEmpty) {
      return state;
    }

    final List<Song> songs = await searchSongs(query, filter);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    // Actualizamos el último query
    _lastQuery = query;

    state = songs;
    return songs;
  }

}