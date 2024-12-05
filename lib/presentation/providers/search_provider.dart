import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/song.dart';
import 'search_repository_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchFilterProvider = StateProvider<String>((ref) => 'songs'); // Provider para el filtro actual

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
  String _lastFilter = 'songs';

  SearchedSongsNotifier({
    required this.searchSongs,
    required this.ref
  }) : super([]);

  Future<List<Song>> searchSongsByQuery(String query, { String filter = "songs" }) async {
    // Si el query y filtro son iguales a los últimos y tenemos resultados, devolvemos el cache
    if (query == _lastQuery && filter == _lastFilter && state.isNotEmpty) {
      return state;
    }

    final List<Song> songs = await searchSongs(query, filter);
    
    // Actualizamos los providers
    ref.read(searchQueryProvider.notifier).update((state) => query);
    ref.read(searchFilterProvider.notifier).update((state) => filter);

    // Actualizamos los últimos valores
    _lastQuery = query;
    _lastFilter = filter;

    state = songs;
    return songs;
  }
}