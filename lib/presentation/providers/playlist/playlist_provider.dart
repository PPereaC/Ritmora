import 'package:apolo/config/utils/pretty_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apolo/domain/entities/playlist.dart';

import '../../../domain/entities/song.dart';
import '../../../infrastructure/repositories/playlist_repository_impl.dart';
import 'playlist_repository_provider.dart';

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
      errorMessage: errorMessage ?? this.errorMessage,
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

  Future<List<Song>> getSongsFromPlaylist(int playlistID) async {
    try {
      final songs = await _repository.getSongsFromPlaylist(playlistID);
      return songs;
    } catch (e) {
      return [];
    }
  }

  Future<void> addPlaylist(Playlist playlist) async {
    try {
      await _repository.addNewPlaylist(playlist);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al añadir la playlist: $e',
      );
    }
  }

  Future<void> addSongToPlaylist(BuildContext context, int playlistID, Song song, {bool showNotifications = true, bool reloadPlaylists = true}) async {
    try {
      await _repository.addSongToPlaylist(context, playlistID, song, showNotifications: showNotifications);
      if (reloadPlaylists) {
        await loadPlaylists(); // Solo recarga si es necesario
      }
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al añadir la canción a la playlist: $e',
      );
    }
  }

  Future<Playlist> getPlaylistByID(int playlistID) async {
    try {
      final playlist = await _repository.getPlaylistByID(playlistID);
      return playlist;
    } catch (e) {
      return Playlist(
        title: 'Error',
        author: 'Error',
        thumbnailUrl: '',
        playlistId: '',
      );
    }
  }

  Future<void> deletePlaylist(Playlist playlist) async {
    try {
      printINFO('Eliminando la playlist: ${playlist.title}');
      await _repository.removePlaylist(playlist);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      printERROR('Error al eliminar la playlist: $e');
    }
  }

  Future<void> updatePlaylistThumbnail(int playlistID, String thumbnailURL) async {
    try {
      await _repository.updatePlaylistThumbnail(playlistID, thumbnailURL);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      printERROR('Error al actualizar la imagen de la playlist: $e');
    }
  }

}

final playlistProvider = StateNotifierProvider<PlaylistNotifier, PlaylistState>(
  (ref) => PlaylistNotifier(ref.watch(playlistRepositoryProvider)),
);