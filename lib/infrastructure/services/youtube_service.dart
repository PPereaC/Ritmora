import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../domain/entities/song.dart';
import '../../domain/entities/youtube_playlist.dart';
import '../../domain/entities/youtube_song.dart';
import 'music_service.dart';

class YoutubeService {
  static final YoutubeService _instance = YoutubeService._internal();
  final YoutubeExplode yt = YoutubeExplode();
  
  factory YoutubeService() => _instance;
  YoutubeService._internal();

  Future<List<Song>> getPlaylistSongs(String playlistID) async {
    List<Song> songs = [];
    String playlistid = playlistID.substring(2);
    var playlist = await yt.playlists.get('https://music.youtube.com/playlist?list=$playlistid');
    await for (var video in yt.playlists.getVideos(playlist.id)) {
      songs.add(
        Song(
          title: video.title,
          author: video.author,
          thumbnailUrl: video.thumbnails.highResUrl,
          streamUrl: '',
          endUrl: '/watch?v=${video.id}',
          songId: video.id.toString(),
          duration: video.duration.toString(),
        )
      );
    }
    return songs;
  }

  Future<YoutubePlaylist> getYoutubePlaylistInfo(String playlistUrl) async {

    var playlist = await yt.playlists.get(playlistUrl);

    YoutubePlaylist youtubePlaylist = YoutubePlaylist(
      playlistId: playlist.id.toString(),
      title: playlist.title,
      author: playlist.author,
      thumbnailUrl: playlist.thumbnails.highResUrl
    );

    return youtubePlaylist;

  }

  Future<List<YoutubeSong>> getYoutubePlaylistSongs(String playlistUrl) async {
    String playlistId = playlistUrl.split('list=').last;
    
    // Eliminar cualquier parámetro adicional después del & (si existe)
    playlistId = playlistId.split('&').first;
    
    return await MusicService().getPlaylistSongs(playlistUrl);
  }


}