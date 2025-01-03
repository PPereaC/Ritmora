import 'package:apolo/domain/datasources/playlist_datasource.dart';
import 'package:apolo/domain/entities/playlist.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqflitePlaylistDatasource extends PlaylistDatasource {

  Future<Database> openDB() async {
    var databasesPath = await getDatabasesPath();
  
    // Construir la ruta completa de la base de datos
    String path = join(databasesPath, 'playlists.db');
    
    // Abrir la base de datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        // Tabla para playlists
        await db.execute(
          '''
          CREATE TABLE playlist (
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            thumbnailUrl TEXT,
            playlistId TEXT,
            isLocal INTEGER NOT NULL
          )
          '''
        );

        // Tabla para canciones de playlist
        await db.execute(
          '''
          CREATE TABLE playlist_song (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            playlistId INTEGER,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            thumbnailUrl TEXT NOT NULL,
            streamUrl TEXT NOT NULL,
            endUrl TEXT NOT NULL,
            songId TEXT NOT NULL,
            isLiked INTEGER NOT NULL DEFAULT 0,
            duration TEXT NOT NULL,
            videoId TEXT NOT NULL DEFAULT '',
            isVideo INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (playlistId) REFERENCES playlist(id) ON DELETE CASCADE
          )
          '''
        );

      },
    );
  }

  @override
  Future<void> addNewPlaylist(Playlist playlist) async {
    return openDB().then((db) async {
      await db.transaction((txn) async {
        await txn.rawInsert(
          '''
          INSERT INTO playlist (
            id,
            title,
            author,
            thumbnailUrl,
            playlistId,
            isLocal
          ) VALUES (?, ?, ?, ?, ?)
          ''',
          [
            playlist.id,
            playlist.title,
            playlist.author,
            playlist.thumbnailUrl,
            playlist.playlistId,
            playlist.isLocal
          ]
        );
      });
    });
  }

  @override
  Future<void> addSongToPlaylist(BuildContext context, int playlistID, Song song, {bool showNotifications = true, bool reloadPlaylists = true}) {
    // TODO: implement addSongToPlaylist
    throw UnimplementedError();
  }

  @override
  Future<Playlist> getPlaylistByID(int playlistID) {
    // TODO: implement getPlaylistByID
    throw UnimplementedError();
  }

  @override
  Future<List<Playlist>> getPlaylists() {
    return openDB().then((db) async {
      // Obtener todas las playlists
      final List<Map<String, dynamic>> playlists = await db.query('playlist');
  
      // Mapear resultados a objetos Playlist
      return playlists.map((map) => Playlist(
        id: map['id'],
        title: map['title'],
        author: map['author'],
        thumbnailUrl: map['thumbnailUrl'],
        playlistId: map['playlistId'],
        isLocal: map['isLocal']
      )).toList();
    });
  }

  @override
  Future<void> removePlaylist(Playlist playlist) {
    // TODO: implement removePlaylist
    throw UnimplementedError();
  }

  @override
  Future<void> updatePlaylist(Playlist playlist) {
    // TODO: implement updatePlaylist
    throw UnimplementedError();
  }

  @override
  Future<void> updatePlaylistThumbnail(int playlistID, String thumbnailURL) {
    // TODO: implement updatePlaylistThumbnail
    throw UnimplementedError();
  }

}