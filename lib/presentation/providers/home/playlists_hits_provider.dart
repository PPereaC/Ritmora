import 'package:finmusic/domain/repositories/songs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/playlist.dart';
import '../song_repository_provider.dart';

// Estado: Lista de canciones
final playlistsHitsProvider = StateNotifierProvider<PlaylistsHitsNotifier, List<Playlist>>((ref) {
  final songRepository = ref.watch(songRepositoryProvider);
  return PlaylistsHitsNotifier(songRepository: songRepository);
});

// Notifier que maneja el estado
class PlaylistsHitsNotifier extends StateNotifier<List<Playlist>> {
  final SongsRepository songRepository;

  PlaylistsHitsNotifier({
    required this.songRepository
  }): super([]); // Estado inicial: lista vacía

  Future<void> loadSongs() async {
    try {
      final quickpicks = await songRepository.getPlaylistsHits();
      state = quickpicks;
    } catch (e) { // En caso de error mantenemos el estado anterior
      throw Exception('Error al cargar las playlists de éxitos');
    }
  }
}