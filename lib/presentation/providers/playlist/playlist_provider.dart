import 'package:finmusic/config/utils/pretty_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmusic/domain/entities/playlist.dart';

import '../../../domain/entities/song.dart';
import '../../../domain/entities/youtube_playlist.dart';
import '../../../domain/entities/youtube_song.dart';
import '../../../infrastructure/repositories/playlist_repository_impl.dart';
import 'playlist_repository_provider.dart';

class PlaylistState {
  final List<Playlist> playlists;
  final List<YoutubePlaylist> youtubePlaylists;
  final bool isLoading;
  final String? errorMessage;

  PlaylistState({
    required this.playlists,
    required this.youtubePlaylists,
    this.isLoading = false,
    this.errorMessage,
  });

  PlaylistState copyWith({
    List<Playlist>? playlists,
    List<YoutubePlaylist>? youtubePlaylists,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      youtubePlaylists: youtubePlaylists ?? this.youtubePlaylists,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier que maneja la lógica
class PlaylistNotifier extends StateNotifier<PlaylistState> {
  final PlaylistRepositoryImpl _repository;

  PlaylistNotifier(this._repository) : super(PlaylistState(playlists: [], youtubePlaylists: [])) {
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final playlists = await _repository.getPlaylists();
      final youtubePlaylists = await _repository.getYoutubePlaylists();
      state = state.copyWith(
        playlists: playlists,
        youtubePlaylists: youtubePlaylists,
        isLoading: false
      );
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

  Future<void> removeYoutubePlaylist(String youtubePlaylistID) async {
    try {
      printINFO('Eliminando la playlist de Youtube: $youtubePlaylistID');
      await _repository.removeYoutubePlaylist(youtubePlaylistID);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      printERROR('Error al eliminar la playlist de Youtube: $e');
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

  Future<void> createLocalPlaylist(BuildContext context, final TextEditingController playlistNameController, WidgetRef ref) async {
    try {
      await _repository.createLocalPlaylist(context, playlistNameController, ref);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al añadir la playlist: $e',
      );
    }
  }

  Future<void> addYoutubePlaylist(YoutubePlaylist playlist) async {
    try {
      await _repository.addYoutubePlaylist(playlist);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      printERROR('Error al añadir la playlist de Youtubee: $e');
    }
  }

  Future<void> addSongsToYoutubePlaylist(String playlistID, List<YoutubeSong> songs) async {
    try {
      await _repository.addSongsToYoutubePlaylist(playlistID, songs);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      printERROR('Error al añadir las canciones a la playlist de Youtubee: $e');
    }
  }

  Future<List<YoutubeSong>> getYoutubeSongsFromPlaylist(String playlistId) async {
    try {
      return await _repository.getYoutubeSongsFromPlaylist(playlistId);
    } catch (e) {
      printERROR('Error obteniendo canciones de YouTube del repositorio: $e');
      return [];
    }
  }

  Future<void> updateYoutubePlaylistThumbnail(String playlistID, String thumbnailURL) async {
    try {
      await _repository.updateYoutubePlaylistThumbnail(playlistID, thumbnailURL);
      await loadPlaylists(); // Recargar la lista
    } catch (e) {
      printERROR('Error al actualizar la carátula de la playlist de Youtube: $e');
    }
  }

  Future<bool> isThisYoutubePlaylistSaved(String playlistID) async {
    return await _repository.isThisYoutubePlaylistSaved(playlistID);
  }

  Future<void> updateSongStreamUrl(Song song) async {
    try {
      await _repository.updateStreamUrl(song);
    } catch (e) {
      printERROR('Error al actualizar la URL de la canción: $e');
    }
  }

  Future<bool> checkIfSongIsInDB(String songID) async {
    return await _repository.checkIfSongIsInDB(songID);
  }

  Future<Song> getSongFromDB(String songID) async {
    return await _repository.getSongFromDB(songID);
  }

  Future<List<Song>> getSongsFromLocalPlaylist(int playlistID) async {
    try {
      return await _repository.getSongsFromPlaylist(playlistID);
    } catch (e) {
      printERROR('Error obteniendo canciones de la playlist local del repositorio: $e');
      return [];
    }
  }

  Future<List<YoutubeSong>> getSongsFromYoutubePlaylist(String playlistID) async {
    try {
      return await _repository.getSongsFromYoutubePlaylist(playlistID);
    } catch (e) {
      printERROR('Error obteniendo canciones de la playlist de YouTube del repositorio: $e');
      return [];
    }
  }

}

final playlistProvider = StateNotifierProvider<PlaylistNotifier, PlaylistState>(
  (ref) => PlaylistNotifier(ref.watch(playlistRepositoryProvider)),
);