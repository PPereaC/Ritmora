// ignore_for_file: use_build_context_synchronously

import 'package:apolo/config/utils/pretty_print.dart';
import 'package:apolo/domain/datasources/playlist_datasource.dart';
import 'package:apolo/domain/entities/playlist.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../presentation/widgets/widgets.dart';

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
  Future<void> addSongToPlaylist(BuildContext context, int playlistID, Song song) async {
    final isar = await db;
    
    try {
      // Obtener la playlist a partir del id pasado por parámetro y cargar todas sus canciones
      final playlist = await isar.playlists.get(playlistID);
      if (playlist == null) return; // Si no existe la playlist, se sale
  
      // Cargar las canciones de la playlist
      await playlist.songLinks.load();
      
      // Verificar los duplicados comparando el songId para ver si existe la canción en la playlist ya
      final isDuplicate = playlist.songLinks
          .any((existingSong) => existingSong.songId == song.songId);
  
      if (isDuplicate) {
        CustomSnackbar.show(
          context,
          'Esta canción ya está en la playlist',
          Colors.red,
          Iconsax.warning_2_outline,
        );
        return;
      }
  
      // Si no está duplicada, añadir la canción a la playlist
      await isar.writeTxn(() async {
        await isar.songs.put(song);
        playlist.songLinks.add(song);
        await playlist.songLinks.save();
      });
  
      CustomSnackbar.show(
        context,
        'Canción añadida a la playlist',
        Colors.green,
        Iconsax.tick_circle_outline,
      );
  
    } catch (e) { // Si hay un error, mostrar un snackbar de error con la excepción
      CustomSnackbar.show(
        context,
        'Error al añadir la canción',
        Colors.red,
        Iconsax.warning_2_outline,
      );
    }
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
  
  @override
  Future<Playlist> getPlaylistByID(int playlistID) {
    final isar = db;
    return isar.then((isar) async {
      final playlist = await isar.playlists.get(playlistID);
      await playlist?.songLinks.load();
      playlist?.songs = playlist.songLinks.toList();
      return playlist!;
    });
  }

}