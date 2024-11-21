import '../entities/song.dart';

abstract class SongsRepository {

  Future<List<Song>> searchSongs(String query, String filter);

}