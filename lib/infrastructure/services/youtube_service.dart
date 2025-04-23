import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../config/utils/pretty_print.dart';
import '../../domain/entities/song.dart';
import '../../domain/entities/youtube_playlist.dart';
import '../../domain/entities/youtube_song.dart';

class YoutubeService {
  static final YoutubeService _instance = YoutubeService._internal();
  final YoutubeExplode yt = YoutubeExplode();
  final Map<String, CachedUrl> _cache = {};
  
  factory YoutubeService() => _instance;
  YoutubeService._internal();

  Future<String?> getCachedStreamUrl(String videoId) async {
    // Verificar caché primero
    if (_cache.containsKey(videoId) && _cache[videoId]!.isValid) {
      printINFO('✅ URL encontrada en caché');
      return _cache[videoId]!.url;
    }

    // Timeout de 5 segundos
    try {
      final manifest = await yt.videos.streamsClient
          .getManifest(videoId)
          .timeout(const Duration(seconds: 5));
          
      final url = manifest.audioOnly.withHighestBitrate().url.toString();
          
      _cache[videoId] = CachedUrl(url);
      return url;
    } catch (e) {
      printERROR('Error: $e');
      return null;
    }
  }

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

  static String _getHighQualityThumbnail(String videoId) {
    return 'https://i.ytimg.com/vi/$videoId/maxresdefault.jpg';
  }

  Future<List<YoutubeSong>> getYoutubePlaylistSongs(String playlistUrl) async {
    List<YoutubeSong> youtubeSongs = [];
    
    try {
      var playlist = await yt.playlists.get(playlistUrl);
      
      // Utilizamos getAllVideos en lugar de getVideos para asegurar que obtenemos todos los elementos
      var videos = await yt.playlists.getVideos(playlist.id).toList();
      
      printINFO('📝 Obteniendo ${videos.length} canciones de la playlist ${playlist.title}');
  
      for (var song in videos) {
        youtubeSongs.add(
          YoutubeSong(
            songId: song.id.toString(),
            playlistId: playlist.id.toString(),
            title: song.title,
            author: song.author,
            thumbnailUrl: _getHighQualityThumbnail(song.id.toString()),
            streamUrl: '',
            endUrl: '/watch?v=${song.id}',
            duration: song.duration.toString()
          )
        );
      }
  
      printINFO('✅ Se obtuvieron ${youtubeSongs.length} canciones exitosamente');
      return youtubeSongs;
  
    } catch (e) {
      printERROR('Error obteniendo canciones de la playlist: $e');
      return youtubeSongs;
    }
  }


}

class CachedUrl {
  final String url;
  final DateTime expiresAt;

  CachedUrl(this.url) : expiresAt = DateTime.now().add(const Duration(hours: 1));

  bool get isValid => DateTime.now().isBefore(expiresAt);
}