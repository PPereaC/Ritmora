import 'package:apolo/config/utils/pretty_print.dart';
import 'package:apolo/domain/datasources/playlist_datasource.dart';
import 'package:apolo/domain/entities/playlist.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarPlaylistDatasource extends PlaylistDatasource {

  late Future<Isar> db;
	
	IsarPlaylistDatasource() {
	
		db = openDB();
	
	}

	Future<Isar> openDB() async {
	
		final dir = await getApplicationDocumentsDirectory();

		if (Isar.instanceNames.isEmpty){
			return await Isar.open(
				[PlaylistSchema, SongSchema],
				inspector: true,
				directory: dir.path
			);
		}
	
		return Future.value(Isar.getInstance());
	
	}

  @override
  Future<void> addNewPlaylist(Playlist playlist) async {
    final isar = await db;
  
    await isar.writeTxn(() async {
      await isar.playlists.put(playlist);
    });
  }

  @override
  Future<void> addSongToPlaylist(int playlistID, Song song) async {
    final isar = await db;
  
    printINFO('Añadiendo ${song.title} a la playlist $playlistID');
  
    await isar.writeTxn(() async {
      // Guardar la canción en la base de datos para que sea un objeto gestionado
      await isar.songs.put(song);
  
      final playlist = await isar.playlists.get(playlistID);
      if (playlist != null) {
        // Añadir la canción a los links de la playlist
        playlist.songLinks.add(song);
  
        // Guardar los links actualizados de la playlist
        await playlist.songLinks.save();
      }
    });
  }

  @override
  Future<List<Playlist>> getPlaylists() async {
    try {
      final isar = await db;
      final playlists = await isar.playlists.where().findAll();
      for (var playlist in playlists) {
        await playlist.songLinks.load();
        playlist.songs = playlist.songLinks.toList();
      }
      return playlists;
    } catch (e) {
      printERROR('Error al obtener las playlists: $e');
      return [];
    }
  }

  @override
  Future<void> removePlaylist(Playlist playlist) async {
    final isar = await db;
  
    // Borrar la playlist según el id de Isar
    await isar.writeTxn(() async {
      await isar.playlists.delete(playlist.id);
    });
  }

  @override
  Future<void> updatePlaylist(Playlist playlist) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.playlists.put(playlist);
    });

  }

}