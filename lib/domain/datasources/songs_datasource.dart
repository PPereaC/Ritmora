import '../entities/song.dart';

abstract class SongsDatasource {

  Future<List<Song>> searchSongs(String query, String filter);

}
