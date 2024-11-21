import 'package:just_audio/just_audio.dart';

import '../../domain/entities/song.dart';

class SongPlayerService {
  final AudioPlayer _justAudioPlayer = AudioPlayer();

  Future<void> playSong(Song song) async {
    await _justAudioPlayer.setUrl(song.streamUrl);
    await _justAudioPlayer.play();
  }
}