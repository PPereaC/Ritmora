import 'package:apolo/domain/datasources/songs_datasource.dart';
import 'package:apolo/domain/entities/playlist.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:apolo/domain/repositories/songs_repository.dart';

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
  Future<List<Playlist>> getPlaylistsHits() {
    return datasource.getPlaylistsHits();
  }

}