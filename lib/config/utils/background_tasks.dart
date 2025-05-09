// Función para obtener los stream urls de las canciones en segundo plano
import 'package:finmusic/config/utils/pretty_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../../domain/entities/playlist.dart' as entitie;
import '../../domain/entities/song.dart';
import '../../domain/entities/youtube_playlist.dart';
import '../../presentation/providers/playlist/playlist_provider.dart';

// Future<String?> getStreamUrlInBackground(String songId) async {
//   printINFO(songId);
//   return await Isolate.run(() async {
//     final playerResponse = await PlayerResponse.fetch(songId, option: 0);
//     if (playerResponse != null && playerResponse.playable) {
//       final highestQualityAudio = playerResponse.highestQualityAudio;
//       printINFO('URL: ${highestQualityAudio.url}');
//       return highestQualityAudio.url;
//     }
//     return null;
//   });
// }

Future<bool> isStreamUrlExpired(String streamUrl) async {
  try {
    // Extraer el parámetro 'expire' del enlace
    final Uri uri = Uri.parse(streamUrl);
    final String? expireParam = uri.queryParameters['expire'];
    
    if (expireParam == null) {
      // Si no se encuentra el parámetro 'expire', se considera caducado
      return true;
    }
    
    // Convertir el parámetro 'expire' a un entero (timestamp Unix)
    final int expireTimestamp = int.parse(expireParam);
    
    // Obtener el timestamp Unix actual
    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    // Comprobar si el tiempo actual ha pasado el tiempo de expiración
    return currentTimestamp >= expireTimestamp;
  } catch (e) {
    // Si hay algún error al analizar la URL o el timestamp, se considera caducado
    printERROR('Error checking stream URL expiration: $e');
    return true;
  }
}

Future<void> updateExpiredStreamUrls(WidgetRef ref,List<entitie.Playlist> localPlaylists, List<YoutubePlaylist> youtubePlaylists) async {
  
  // Playlist locales
  for (final playlist in localPlaylists) {
    final songs = await ref.read(playlistProvider.notifier).getSongsFromLocalPlaylist(playlist.id);
    for (final song in songs) {
      if (await isStreamUrlExpired(song.streamUrl)) {
        final newStreamUrl = await getStreamUrlInBackground(song.songId);
        if (newStreamUrl != null) {
          ref.read(playlistProvider.notifier).updateSongStreamUrl(song);
        }
      }
    }
  }

  // Playlist de YouTube
  for (final playlist in youtubePlaylists) {
    final songs = await ref.read(playlistProvider.notifier).getSongsFromYoutubePlaylist(playlist.playlistId);
    for (final song in songs) {
      if (await isStreamUrlExpired(song.streamUrl)) {
        final newStreamUrl = await getStreamUrlInBackground(song.songId);
        if (newStreamUrl != null) {
          ref.read(playlistProvider.notifier).updateSongStreamUrl(
            Song(
              title: song.title,
              author: song.author,
              thumbnailUrl: song.thumbnailUrl,
              streamUrl: newStreamUrl,
              endUrl: song.endUrl,
              songId: song.songId,
              duration: song.duration,
              videoId: song.videoId,
              isVideo: song.isVideo,
              isLiked: song.isLiked
            )
          );
        }
      }
    }
  }

}

Future<String?> fetchStreamUrlInBackground(String songId) async {
  try {
    final yt = YoutubeExplode();
    final manifest = await yt.videos.streamsClient
        .getManifest(songId)
        .timeout(const Duration(seconds: 5));
        
    final url = manifest.audioOnly.withHighestBitrate().url.toString();
    
    yt.close();
    return url;
  } catch (e) {
    printERROR('Error fetching stream URL: $e');
    return null;
  }
}

Future<String?> getStreamUrlInBackground(String songId) async {
  try {
    // Usamos compute para ejecutar la función en un isolate separado
    return await compute(fetchStreamUrlInBackground, songId);
  } catch (e) {
    printERROR('Background URL fetch error: $e');
    return null;
  }
}