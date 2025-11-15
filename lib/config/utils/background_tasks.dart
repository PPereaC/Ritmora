// Función para obtener los stream urls de las canciones en segundo plano
import 'dart:isolate';
import 'package:ritmora/config/utils/pretty_print.dart';
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
    // Usamos RegExp para extraer el parámetro 'expire' de la URL
    final RegExpMatch? match =
        RegExp(r".expire=([0-9]+)&").firstMatch(streamUrl);

    if (match == null) {
      // Si no se encuentra el parámetro 'expire', se considera caducado
      return true;
    }

    // Parseamos el timestamp
    final int epoch = int.parse(match[1]!);

    // Timestamp actual con un buffer de 30 minutos (1800 segundos)
    final int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Si el tiempo actual es menor que el timestamp de expiración, la URL no ha expirado
    return currentTimestamp + 1800 >= epoch;
  } catch (e) {
    // Si ocurre algún error al analizar la URL, se considera caducada
    printERROR('Error checking stream URL expiration: $e');
    return true;
  }
}

Future<void> updateExpiredStreamUrls(
    WidgetRef ref,
    List<entitie.Playlist> localPlaylists,
    List<YoutubePlaylist> youtubePlaylists) async {
  final expiredSongIds = <String>[];
  final songMap = <String, Song>{};
  
  // Recolectar todas las canciones con URLs expiradas
  // Playlist locales
  for (final playlist in localPlaylists) {
    final songs = await ref
        .read(playlistProvider.notifier)
        .getSongsFromLocalPlaylist(playlist.id);
    for (final song in songs) {
      if (await isStreamUrlExpired(song.streamUrl)) {
        expiredSongIds.add(song.songId);
        songMap[song.songId] = song;
      }
    }
  }

  // Playlist de YouTube
  for (final playlist in youtubePlaylists) {
    final songs = await ref
        .read(playlistProvider.notifier)
        .getSongsFromYoutubePlaylist(playlist.playlistId);
    for (final song in songs) {
      if (await isStreamUrlExpired(song.streamUrl)) {
        expiredSongIds.add(song.songId);
        // Convertir YoutubeSong a Song
        songMap[song.songId] = Song(
            title: song.title,
            author: song.author,
            thumbnailUrl: song.thumbnailUrl,
            streamUrl: song.streamUrl,
            endUrl: song.endUrl,
            songId: song.songId,
            duration: song.duration,
            videoId: song.videoId,
            isVideo: song.isVideo,
            isLiked: song.isLiked);
      }
    }
  }
  
  // Si no hay canciones expiradas, salir
  if (expiredSongIds.isEmpty) return;
  
  // Obtener todas las nuevas URLs en paralelo (optimizado)
  final newStreamUrls = await getMultipleStreamUrls(expiredSongIds);
  
  // Actualizar las canciones con las nuevas URLs
  for (final songId in expiredSongIds) {
    final song = songMap[songId];
    final newUrl = newStreamUrls[songId];
    if (song != null && newUrl != null && newUrl.isNotEmpty) {
      ref.read(playlistProvider.notifier).updateSongStreamUrl(Song(
          title: song.title,
          author: song.author,
          thumbnailUrl: song.thumbnailUrl,
          streamUrl: newUrl,
          endUrl: song.endUrl,
          songId: song.songId,
          duration: song.duration,
          videoId: song.videoId,
          isVideo: song.isVideo,
          isLiked: song.isLiked));
    }
  }
}

// Función que se ejecuta en el isolate (solo para batch processing)
Future<String?> _fetchStreamUrlIsolate(String songId) async {
  YoutubeExplode? yt;
  try {
    yt = YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest(songId);
    
    if (manifest.audioOnly.isEmpty) {
      return null;
    }
    
    final streamInfo = manifest.audioOnly.withHighestBitrate();
    return streamInfo.url.toString();
  } catch (e) {
    return null;
  } finally {
    yt?.close();
  }
}

// Función principal - ejecución directa (más confiable para casos individuales)
Future<String?> getStreamUrlInBackground(String songId) async {
  YoutubeExplode? yt;
  try {
    yt = YoutubeExplode();
    final manifest = await yt.videos.streamsClient.getManifest(songId);
    
    if (manifest.audioOnly.isEmpty) {
      printERROR('No hay streams de audio disponibles para: $songId');
      return null;
    }
    
    final streamInfo = manifest.audioOnly.withHighestBitrate();
    return streamInfo.url.toString();
  } catch (e) {
    printERROR('Error obteniendo URL del stream: $e');
    return null;
  } finally {
    yt?.close();
  }
}

// Función optimizada para obtener múltiples URLs en paralelo (con isolates)
Future<Map<String, String>> getMultipleStreamUrls(List<String> songIds) async {
  final results = <String, String>{};
  
  // Procesar en lotes de 5 para no sobrecargar
  const batchSize = 5;
  for (var i = 0; i < songIds.length; i += batchSize) {
    final batch = songIds.skip(i).take(batchSize).toList();
    
    // Ejecutar solicitudes en paralelo con isolates
    final futures = batch.map((songId) async {
      try {
        final url = await Isolate.run(() => _fetchStreamUrlIsolate(songId));
        return MapEntry(songId, url ?? '');
      } catch (e) {
        printERROR('Error en isolate para $songId: $e');
        return MapEntry(songId, '');
      }
    });
    
    final batchResults = await Future.wait(futures);
    
    for (final entry in batchResults) {
      if (entry.value.isNotEmpty) {
        results[entry.key] = entry.value;
      }
    }
  }
  
  return results;
}
