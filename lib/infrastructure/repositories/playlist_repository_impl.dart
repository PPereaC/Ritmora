import 'package:apolo/domain/datasources/playlist_datasource.dart';
import 'package:apolo/domain/entities/playlist.dart';
import 'package:apolo/domain/entities/song.dart';

import '../../domain/repositories/playlist_repository.dart';

class PlaylistRepositoryImpl extends PlaylistRepository {

  final PlaylistDatasource datasource;

  PlaylistRepositoryImpl({required this.datasource});

  @override
  Future<void> addNewPlaylist(Playlist playlist) {
    return datasource.addNewPlaylist(playlist);
  }

  @override
  Future<void> addSongToPlaylist(int playlistID, Song song) {
    return datasource.addSongToPlaylist(playlistID, song);
  }

  @override
  Future<List<Playlist>> getPlaylists() {
    return datasource.getPlaylists();
  }

  @override
  Future<void> removePlaylist(Playlist playlist) {
    return datasource.removePlaylist(playlist);
  }

  @override
  Future<void> updatePlaylist(Playlist playlist) {
    return datasource.updatePlaylist(playlist);
  }

}