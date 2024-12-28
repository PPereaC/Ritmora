import 'package:apolo/domain/repositories/songs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/playlist.dart';
import '../song_repository_provider.dart';

final playlistSongsProvider = StateNotifierProvider.family<PlaylistSongsNotifier, Playlist, String>((ref, playlistId) {
  final songRepository = ref.watch(songRepositoryProvider);
  return PlaylistSongsNotifier(
    songRepository: songRepository,
    playlistId: playlistId
  );
});

// Notifier que maneja el estado
class PlaylistSongsNotifier extends StateNotifier<Playlist> {
  final SongsRepository songRepository;
  final String playlistId;

  PlaylistSongsNotifier({
    required this.songRepository,
    required this.playlistId
  }): super(
    Playlist(
      title: '',
      author: '',
      thumbnailUrl: '',
      isLocal: playlistId.startsWith('PL') || playlistId.startsWith('VL') ? false : true
    )
  ); // Estado inicial: lista vacía

  Future<void> loadPlaylist() async {
    try {
      final playlist = await songRepository.getPlaylistWSongs(playlistId);
      state = playlist;
    } catch (e) {
      throw Exception('Error al cargar las canciones de la playlist');
    }
  }

}