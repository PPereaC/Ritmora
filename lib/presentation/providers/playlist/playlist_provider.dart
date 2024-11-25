// playlist_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apolo/domain/entities/playlist.dart';
import 'package:apolo/domain/entities/song.dart';
import '../../../infrastructure/repositories/playlist_repository_impl.dart';
import './playlist_repository_provider.dart';

// Estado para manejar las playlists
class PlaylistState {
  final List<Playlist> playlists;
  final bool isLoading;
  final String? errorMessage;

  PlaylistState({
    required this.playlists,
    this.isLoading = false,
    this.errorMessage,
  });

  PlaylistState copyWith({
    List<Playlist>? playlists,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Notifier que maneja la lógica
class PlaylistNotifier extends StateNotifier<PlaylistState> {
  final PlaylistRepositoryImpl _repository;

  PlaylistNotifier(this._repository) : super(PlaylistState(playlists: [])) {
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final playlists = await _repository.getPlaylists();
      state = state.copyWith(playlists: playlists, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar las playlists: $e',
      );
    }
  }

  Future<void> addPlaylist(Playlist playlist) async {
    try {
      await _repository.addNewPlaylist(playlist);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al añadir playlist: $e',
      );
    }
  }

  Future<void> addSongToPlaylist(int playlistId, Song song) async {
    try {
      await _repository.addSongToPlaylist(playlistId, song);
      await loadPlaylists(); // Recargar para reflejar cambios
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al añadir canción: $e',
      );
    }
  }

  Future<void> removePlaylist(Playlist playlist) async {
    try {
      await _repository.removePlaylist(playlist);
      await loadPlaylists();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al eliminar playlist: $e',
      );
    }
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    try {
      await _repository.updatePlaylist(playlist);
      await loadPlaylists();
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al actualizar playlist: $e',
      );
    }
  }
}

// Providers
final playlistProvider = StateNotifierProvider<PlaylistNotifier, PlaylistState>((ref) {
  final repository = ref.watch(playlistRepositoryProvider);
  return PlaylistNotifier(repository);
});