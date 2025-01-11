import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/audio/audioplayers.dart';
import '../../infrastructure/services/audio/just_audio.dart';
import '../../infrastructure/services/base_player_service.dart';

final songPlayerProvider = Provider<BasePlayerService>((ref) {
  if (Platform.isAndroid || Platform.isIOS) {
    return JustAudioService();
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return AudioPlayersService();
  }
  // Por defecto usar JustAudio
  return JustAudioService();
});