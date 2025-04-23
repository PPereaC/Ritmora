import 'dart:io';

import 'package:finmusic/config/utils/pretty_print.dart';
import 'package:finmusic/domain/datasources/playlist_datasource.dart';
import 'package:finmusic/domain/entities/playlist.dart';
import 'package:finmusic/domain/entities/song.dart';
import 'package:finmusic/domain/entities/youtube_playlist.dart';
import 'package:finmusic/domain/entities/youtube_song.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:synchronized/synchronized.dart';

import '../../config/utils/constants.dart';
import '../../presentation/providers/playlist/playlist_provider.dart';
import '../../presentation/widgets/widgets.dart';

class SqflitePlaylistDatasource extends PlaylistDatasource {
  static SqflitePlaylistDatasource? _instance;
  Database? _database;
  final _lock = Lock();
  static const _timeout = Duration(seconds: 10);

  // Constructor privado
  SqflitePlaylistDatasource._();

  // Factory constructor
  factory SqflitePlaylistDatasource() {
    _instance ??= SqflitePlaylistDatasource._();
    return _instance!;
  }

  // Getter para singleton
  static SqflitePlaylistDatasource get instance {
    _instance ??= SqflitePlaylistDatasource._();
    return _instance!;
  }

  // Inicializar DB
  Future<void> init() async {
    if (_database != null) return;

    await _lock.synchronized(() async {

      // Inicializar sqflite_ffi solo en desktop
      if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'playlists.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
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

          await db.execute(
            '''
            CREATE TABLE playlist_song (
              id INTEGER PRIMARY KEY,
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

          await db.execute(
            '''
            CREATE TABLE youtube_playlists (
              playlistId TEXT PRIMARY KEY,
              title TEXT,
              author TEXT,
              thumbnailUrl TEXT
            )
            '''
          );

          await db.execute(
            '''
            CREATE TABLE youtube_songs (
              songId TEXT PRIMARY KEY,
              playlistId TEXT,
              title TEXT,
              author TEXT,
              thumbnailUrl TEXT,
              streamUrl TEXT,
              endUrl TEXT,
              isLiked INTEGER,
              duration TEXT,
              videoId TEXT,
              isVideo INTEGER,
              FOREIGN KEY (playlistId) REFERENCES playlists(playlistId)
            )
            '''
          );

        },
      );
    }, timeout: _timeout);
  }

  Future<Database> _getDB() async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  @override
  Future<void> addNewPlaylist(Playlist playlist) async {
    final db = await _getDB();
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
        ) VALUES (?, ?, ?, ?, ?, ?)
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
  }

  @override
  Future<void> addSongToPlaylist(BuildContext context, int playlistID, Song song, {bool showNotifications = true, bool reloadPlaylists = true}) async {
    final db = await _getDB();
    await db.transaction((txn) async {
      await txn.rawInsert(
        '''
        INSERT INTO playlist_song (
          playlistId,
          title,
          author,
          thumbnailUrl,
          streamUrl,
          endUrl,
          songId,
          isLiked,
          duration,
          videoId,
          isVideo
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          playlistID,
          song.title,
          song.author,
          song.thumbnailUrl,
          song.streamUrl,
          song.endUrl,
          song.songId,
          song.isLiked,
          song.duration,
          song.videoId,
          song.isVideo
        ]
      );
      printINFO('Song added: ${song.title} - ${song.author} - ${song.songId}');
    });
  }

  @override
  Future<Playlist> getPlaylistByID(int playlistID) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> playlists = await db.query(
      'playlist',
      where: 'id = ?',
      whereArgs: [playlistID]
    );

    if (playlists.isEmpty) throw Exception('Playlist not found');

    return Playlist(
      id: playlists.first['id'],
      title: playlists.first['title'],
      author: playlists.first['author'],
      thumbnailUrl: playlists.first['thumbnailUrl'],
      playlistId: playlists.first['playlistId'],
      isLocal: playlists.first['isLocal']
    );
  }

  @override
  Future<List<Playlist>> getPlaylists() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> playlists = await db.query('playlist');

    return playlists.map((map) => Playlist(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      thumbnailUrl: map['thumbnailUrl'],
      playlistId: map['playlistId'],
      isLocal: map['isLocal']
    )).toList();
  }

  @override
  Future<List<Song>> getSongsFromPlaylist(int playlistID) async {
    final db = await _getDB();
    try {
      final List<Map<String, dynamic>> songs = await db.query(
        'playlist_song',
        where: 'playlistId = ?',
        whereArgs: [playlistID]
      );

      return songs.map((map) => Song(
        title: map['title'],
        author: map['author'],
        thumbnailUrl: map['thumbnailUrl'],
        streamUrl: map['streamUrl'],
        endUrl: map['endUrl'],
        songId: map['songId'],
        duration: map['duration'],
        videoId: map['videoId'] ?? '',
        isVideo: (map['isVideo'] == 1) ? 1 : 0,
        isLiked: (map['isLiked'] == 1) ? 1 : 0,
      )).toList();
    } catch (e) {
      printINFO('Error getting songs from playlist: $e');
      return [];
    }
  }

  @override
  Future<void> removePlaylist(Playlist playlist) async {
    final db = await _getDB();
    await db.delete(
      'playlist',
      where: 'id = ?',
      whereArgs: [playlist.id]
    );
  }

  @override
  Future<void> updatePlaylist(Playlist playlist) async {
    final db = await _getDB();
    await db.update(
      'playlist',
      {
        'title': playlist.title,
        'author': playlist.author,
        'thumbnailUrl': playlist.thumbnailUrl,
        'playlistId': playlist.playlistId,
        'isLocal': playlist.isLocal
      },
      where: 'id = ?',
      whereArgs: [playlist.id]
    );
  }

  @override
  Future<void> updatePlaylistThumbnail(int playlistID, String thumbnailURL) async {
    final db = await _getDB();
    await db.update(
      'playlist',
      {'thumbnailUrl': thumbnailURL},
      where: 'id = ?',
      whereArgs: [playlistID]
    );
  }

  // Método para cerrar la DB al finalizar la app
  Future<void> dispose() async {
    await _lock.synchronized(() async {
      if (_database != null) {
        await _database!.close();
        _database = null;
      }
    });
  }
  
  @override
  Future<void> createLocalPlaylist(BuildContext context, final TextEditingController playlistNameController, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Nueva Playlist',
        hintText: 'Nombre de la playlist',
        cancelButtonText: 'Cancelar',
        confirmButtonText: 'Crear',
        controller: playlistNameController,
        onCancel: () {
          playlistNameController.clear();
          Navigator.pop(context);
        },
        onConfirm: (value) async {
          final playlist = Playlist(
            title: value,
            author: 'anonymous',
            thumbnailUrl: defaultPoster,
            playlistId: 'XXXXX'
          );
          
          await ref.read(playlistProvider.notifier).addPlaylist(playlist);
          
          if (context.mounted) {
            Navigator.pop(context);
          }
          playlistNameController.clear();
        },
      ),
    );
  }

  @override
  Future<void> addYoutubePlaylist(YoutubePlaylist playlist) async {
    final db = await _getDB();
    await db.transaction((txn) async {
      await txn.rawInsert(
        '''
        INSERT INTO youtube_playlists (
          playlistId,
          title,
          author,
          thumbnailUrl
        ) VALUES (?, ?, ?, ?)
        ''',
        [
          playlist.playlistId,
          playlist.title,
          playlist.author,
          playlist.thumbnailUrl
        ]
      );
    });
  }

  @override
  Future<void> addSongsToYoutubePlaylist(String playlistID, List<YoutubeSong> songs) async {
    final db = await _getDB();
    
    try {
      await db.transaction((txn) async {
        // Primero verificamos que la playlist exista
        final playlistExists = await txn.rawQuery(
          'SELECT 1 FROM playlists WHERE playlistId = ? LIMIT 1',
          [playlistID]
        );
        
        if (playlistExists.isEmpty) {
          throw Exception('La playlist con id $playlistID no existe');
        }
        
        // Insertamos cada canción
        for (final song in songs) {
          await txn.rawInsert(
            '''
            INSERT OR REPLACE INTO playlist_song (
              playlistId,
              title,
              author,
              thumbnailUrl,
              streamUrl,
              endUrl,
              songId,
              isLiked,
              duration,
              videoId,
              isVideo
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            ''',
            [
              playlistID,
              song.title,
              song.author,
              song.thumbnailUrl,
              song.streamUrl,
              song.endUrl,
              song.songId,
              song.isLiked,
              song.duration,
              song.videoId,
              song.isVideo
            ]
          );
          printINFO('Canción añadida: ${song.title} - ${song.author} - ${song.songId}');
        }
      });
      
      printINFO('Se han añadido ${songs.length} canciones a la playlist $playlistID');
    } catch (e) {
      printERROR('Error al añadir canciones a la playlist: $e');
      rethrow;
    }
  }
  
}