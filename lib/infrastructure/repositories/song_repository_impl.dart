import '../../domain/datasources/songs_datasource.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/songs_repository.dart';

class SongRepositoryImpl extends SongsRepository {

  final SongsDatasource datasource;

  SongRepositoryImpl({required this.datasource});

  @override
  Future<List<Song>> searchSongs(String query, String filter) {
    return datasource.searchSongs(query, filter);
  }
  
  @override
  Future<List<Song>> getTrendingSongs() {
    return datasource.getTrendingSongs();
  }
  
  @override
  Future<List<Song>> getQuickPicks() {
    return datasource.getQuickPicks();
  }
  
  @override
  Future<Playlist> getPlaylistWSongs(String playlistID) {
    return datasource.getPlaylistWSongs(playlistID);
  }
  
  @override
  Future<Map<String, List<Playlist>>> getHomePlaylists() {
    return datasource.getHomePlaylists();
  }

}