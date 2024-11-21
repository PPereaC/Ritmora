import 'package:audioplayers/audioplayers.dart';
import '../../domain/entities/song.dart';

class SongPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSong(Song song) async {
    await _audioPlayer.play(UrlSource(song.streamUrl));
  }
}