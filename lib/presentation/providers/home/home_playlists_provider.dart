import 'package:ritmora/domain/repositories/songs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/playlist.dart';
import '../song_repository_provider.dart';

// Estado: Lista de canciones
final homePlaylistsProvider = StateNotifierProvider<PlaylistsHitsNotifier, Map<String, List<Playlist>>>((ref) {
  final songRepository = ref.watch(songRepositoryProvider);
  return PlaylistsHitsNotifier(songRepository: songRepository);
});

// Notifier que maneja el estado
class PlaylistsHitsNotifier extends StateNotifier<Map<String, List<Playlist>>> {
  final SongsRepository songRepository;

  PlaylistsHitsNotifier({
    required this.songRepository
  }): super({});

  Future<void> loadSongs() async {
    try {
      final playlists = await songRepository.getHomePlaylists();
      state = playlists;
    } catch (e) { // En caso de error mantenemos el estado anterior
      throw Exception('Error al cargar las playlists de éxitos');
    }
  }
}