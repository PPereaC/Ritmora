// ignore_for_file: unused_field

import 'dart:async';

import 'package:just_audio/just_audio.dart';

import '../../config/utils/background_tasks.dart';
import '../../domain/entities/song.dart';

class SongPlayerService {
  final AudioPlayer _justAudioPlayer = AudioPlayer();
  final _songController = StreamController<Song?>.broadcast();
  final _queueController = StreamController<List<Song>>.broadcast();
  StreamSubscription? _playerStateListener;
  Song? _currentSong;
  bool _isPlaying = false;

  SongPlayerService() {
    // Escuchar cambios de estado del reproductor
    _playerStateListener = _justAudioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  // Cola de reproducción
  final List<Song> _queue = [];
  int _currentIndex = -1;

  // Getters
  Song? get currentSong => _currentSong;
  bool get isPlaying => _isPlaying;
  Stream<bool> get playingStream => _justAudioPlayer.playingStream;
  Stream<Song?> get currentSongStream => _songController.stream;
  List<Song> get queue => List.unmodifiable(_queue);
  Stream<List<Song>> get queueStream => _queueController.stream;

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
    // Si la canción no está en la cola, añadirla
    if (!_queue.contains(song)) {
      _queue.add(song);
      _currentIndex = _queue.length - 1;
    } else {
      _currentIndex = _queue.indexOf(song);
    }
    
    _currentSong = song;
    _songController.add(song);
    _queueController.add(_queue);
    
    await _justAudioPlayer.setUrl(song.streamUrl);
    await _justAudioPlayer.play();
    _isPlaying = true;
  }

  Future<void> pause() async {
    await _justAudioPlayer.pause();
    _isPlaying = false;
  }

  // Añadir canción a la cola
  void addToQueue(Song song) async {
    song.streamUrl = (await getStreamUrlInBackground(song.songId))!;
    _queue.add(song);
    _queueController.add(_queue);
  }

  // Añadir canción a continuación
  void addNext(Song song) async {
    if (_currentIndex < 0) {
      addToQueue(song);
    } else {
      song.streamUrl = (await getStreamUrlInBackground(song.songId))!;
      _queue.insert(_currentIndex + 1, song);
      _queueController.add(_queue);
    }
  }

  // Reproducir siguiente canción
  Future<void> playNext() async {
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      await playSong(_queue[_currentIndex]);
    }
  }

  // Reproducir canción anterior
  Future<void> playPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await playSong(_queue[_currentIndex]);
    } else if (_currentIndex == 0) {
      // Reiniciar canción actual
      await _justAudioPlayer.seek(Duration.zero);
      await resume();
    }
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

  // Eliminar canción de la cola
  void removeFromQueue(int index) {
    if (index < 0 || index >= _queue.length) return;
    
    if (index < _currentIndex) {
      _currentIndex--;
    }
    
    _queue.removeAt(index);
    _queueController.add(_queue);
  }

  void dispose() {
    _justAudioPlayer.dispose();
    _songController.close();
    _queueController.close();
  }
}