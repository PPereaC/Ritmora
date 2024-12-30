// Función para obtener los stream urls de las canciones en segundo plano
import 'dart:isolate';

import 'package:apolo/config/utils/pretty_print.dart';

import '../../infrastructure/models/player_response.dart';

Future<String?> getStreamUrlInBackground(String songId) async {
  printINFO(songId);
  return await Isolate.run(() async {
    final playerResponse = await PlayerResponse.fetch(songId, option: 0);
    if (playerResponse != null && playerResponse.playable) {
      final highestQualityAudio = playerResponse.highestQualityAudio;
      return highestQualityAudio.url;
    }
    return null;
  });
}