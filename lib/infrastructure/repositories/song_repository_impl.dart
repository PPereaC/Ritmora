import 'package:apolo/domain/datasources/songs_datasource.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:apolo/domain/repositories/songs_repository.dart';

class SongRepositoryImpl extends SongsRepository {

  final SongsDatasource datasource;

  SongRepositoryImpl({required this.datasource});

  @override
  Future<List<Song>> searchSongs(String query, String filter) {
    return datasource.searchSongs(query, filter);
  }

}