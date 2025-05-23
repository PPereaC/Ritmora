import 'package:ritmora/domain/datasources/playlist_datasource.dart';
import 'package:ritmora/domain/entities/playlist.dart';
import 'package:ritmora/domain/entities/song.dart';
import 'package:ritmora/domain/entities/youtube_playlist.dart';
import 'package:ritmora/domain/entities/youtube_song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/utils/pretty_print.dart';
import '../../domain/repositories/playlist_repository.dart';

class PlaylistRepositoryImpl extends PlaylistRepository {

  final PlaylistDatasource datasource;

  PlaylistRepositoryImpl({required this.datasource});

  @override
  Future<void> addNewPlaylist(Playlist playlist) {
    return datasource.addNewPlaylist(playlist);
  }

  @override
  Future<void> addSongToPlaylist(BuildContext context, int playlistID, Song song, {bool showNotifications = true, bool reloadPlaylists = true}) {
    return datasource.addSongToPlaylist(context, playlistID, song, showNotifications: showNotifications);
  }

  @override
  Future<List<Playlist>> getPlaylists() {
    return datasource.getPlaylists();
  }

  @override
  Future<void> removePlaylist(Playlist playlist) {
    return datasource.removePlaylist(playlist);
  }

  @override
  Future<void> updatePlaylist(Playlist playlist) {
    return datasource.updatePlaylist(playlist);
  }
  
  @override
  Future<Playlist> getPlaylistByID(int playlistID) {
    return datasource.getPlaylistByID(playlistID);
  }
  
  @override
  Future<void> updatePlaylistThumbnail(int playlistID, String thumbnailURL) {
    return datasource.updatePlaylistThumbnail(playlistID, thumbnailURL);
  }
  
  @override
  Future<List<Song>> getSongsFromPlaylist(int playlistID) {
    return datasource.getSongsFromPlaylist(playlistID);
  }
  
  @override
  Future<void> createLocalPlaylist(BuildContext context, final TextEditingController playlistNameController, WidgetRef ref) {
    return datasource.createLocalPlaylist(context, playlistNameController, ref);
  }

  @override
  Future<void> addSongsToYoutubePlaylist(String playlistID, List<YoutubeSong> songs) {
    return datasource.addSongsToYoutubePlaylist(playlistID, songs);
  }

  @override
  Future<void> addYoutubePlaylist(YoutubePlaylist playlist) {
    return datasource.addYoutubePlaylist(playlist);
  }

  @override
  Future<List<YoutubePlaylist>> getYoutubePlaylists() async {
    try {
      return await datasource.getYoutubePlaylists();
    } catch (e) {
      printERROR('Error al cargar playlists de YouTube: $e');
      return [];
    }
  }
  
  @override
  Future<List<YoutubeSong>> getYoutubeSongsFromPlaylist(String playlistId) {
    return datasource.getYoutubeSongsFromPlaylist(playlistId);
  }
  
  @override
  Future<void> updateYoutubePlaylistThumbnail(String playlistID, String thumbnailURL) {
    return datasource.updateYoutubePlaylistThumbnail(playlistID, thumbnailURL);
  }
  
  @override
  Future<void> removeYoutubePlaylist(String youtubePlaylistID) {
    return datasource.removeYoutubePlaylist(youtubePlaylistID);
  }
  
  @override
  Future<bool> isThisYoutubePlaylistSaved(String playlistID) {
    return datasource.isThisYoutubePlaylistSaved(playlistID);
  }
  
  @override
  Future<bool> checkIfSongIsInDB(String songID) {
    return datasource.checkIfSongIsInDB(songID);
  }
  
  @override
  Future<Song> getSongFromDB(String songID) {
    return datasource.getSongFromDB(songID);
  }
  
  @override
  Future<void> updateStreamUrl(Song song) {
    return datasource.updateStreamUrl(song);
  }
  
  @override
  Future<List<Song>> getSongsFromLocalPlaylist(String playlistID) {
    return datasource.getSongsFromLocalPlaylist(playlistID);
  }
  
  @override
  Future<List<YoutubeSong>> getSongsFromYoutubePlaylist(String playlistID) {
    return datasource.getSongsFromYoutubePlaylist(playlistID);
  }
  
}