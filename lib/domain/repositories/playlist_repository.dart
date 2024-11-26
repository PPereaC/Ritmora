import '../entities/playlist.dart';
import '../entities/song.dart';

abstract class PlaylistRepository {

  Future<List<Playlist>> getPlaylists();
  Future<void> addNewPlaylist(Playlist playlist);
  Future<void> removePlaylist(Playlist playlist);
  Future<void> updatePlaylist(Playlist playlist);
  Future<void> addSongToPlaylist(int playlistID, Song song);
  Future<Playlist> getPlaylistByID(int playlistID);

}