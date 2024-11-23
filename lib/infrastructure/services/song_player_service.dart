import 'dart:async';

import 'package:just_audio/just_audio.dart';

import '../../domain/entities/song.dart';

class SongPlayerService {
  final AudioPlayer _justAudioPlayer = AudioPlayer();
  final _songController = StreamController<Song?>.broadcast();
  Song? _currentSong;
  bool _isPlaying = false;

  // Getters
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Stream<bool> get playingStream => _justAudioPlayer.playingStream;
  Stream<Song?> get currentSongStream => _songController.stream;

  // Getters para la posición y duración de la canción
  Duration get currentPosition => _justAudioPlayer.position;
  Duration get totalDuration => _justAudioPlayer.duration ?? Duration.zero;
  Stream<Duration> get positionStream => _justAudioPlayer.positionStream;
  Stream<Duration?> get durationStream => _justAudioPlayer.durationStream;

  // Método para buscar una posición específica
  Future<void> seek(Duration position) async {
    await _justAudioPlayer.seek(position);
  }

  Future<void> playSong(Song song) async {
    _currentSong = song;
    _songController.add(song); // Notificar cambio de canción
    await _justAudioPlayer.setUrl(song.streamUrl);
    await _justAudioPlayer.play();
    _isPlaying = true;
  }

  Future<void> pause() async {
    await _justAudioPlayer.pause();
    _isPlaying = false;
  }

  Future<void> resume() async {
    if (_currentSong != null) {
      await _justAudioPlayer.play();
      _isPlaying = true;
    }
  }

  Future<void> togglePlay() async {
    if (_currentSong == null) return;
      
    if (_justAudioPlayer.playing) {
      await pause();
    } else {
      await resume();
    }
    
    _isPlaying = _justAudioPlayer.playing;
  }

  void dispose() {
    _justAudioPlayer.dispose();
    _songController.close();
  }
}