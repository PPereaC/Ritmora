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
    } else {
      printINFO('Probando segunda opción');
      final playerResponseOption1 = await PlayerResponse.fetch(songId, option: 1);
      if (playerResponseOption1 != null && playerResponseOption1.playable) {
        final highestQualityAudio = playerResponseOption1.highestQualityAudio;
        return highestQualityAudio.url;
      } else {
        printINFO('Probando tercera opción');
        final playerResponseOption2 = await PlayerResponse.fetch(songId, option: 2);
        if (playerResponseOption2 != null && playerResponseOption2.playable) {
          final highestQualityAudio = playerResponseOption2.highestQualityAudio;
          return highestQualityAudio.url;
        }
      }
    }
    return null;
  });
}