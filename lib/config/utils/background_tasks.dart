// Función para obtener los stream urls de las canciones en segundo plano
import 'package:finmusic/config/utils/pretty_print.dart';
import '../../infrastructure/services/youtube_service.dart';

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

Future<String?> getStreamUrlInBackground(String songId) async {
  try {
    
    final ytService = YoutubeService();
    final url = await ytService.getCachedStreamUrl(songId);
    
    return url;
  } catch (e) {
    printERROR('Error getting stream URL: $e');
    return null;
  }
}