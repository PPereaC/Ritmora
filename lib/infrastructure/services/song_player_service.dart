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

  // Historial y cola de reproducción
  final List<Song> _history = []; // Añadimos esta lista para el historial
  final List<Song> _queue = [];

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

  // Reproducir una canción
  Future<void> playSong(Song song) async {
    // Si hay una canción actual, moverla al historial
    if (_currentSong != null) {
      _history.add(_currentSong!);
    }

    _currentSong = song;
    _songController.add(song);

    // Cargar y reproducir la canción
    if(song.streamUrl.isEmpty) {
      // Si la url está vacía, no hacer nada
    } else {
      await _justAudioPlayer.setUrl(song.streamUrl);
      await _justAudioPlayer.play();
      _isPlaying = true;

      _queueController.add(_queue);
    }
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

  // Añadir canción al final de la cola
  Future<void> addToQueue(Song song) async {
    if (!_queue.contains(song)) {
      song.streamUrl = (await getStreamUrlInBackground(song.songId)) ?? '';
      _queue.add(song);
      _queueController.add(_queue);
    }
  }

  // Añadir canción siguiente en la cola
  Future<void> addNext(Song song) async {
    if (!_queue.contains(song)) {
      song.streamUrl = (await getStreamUrlInBackground(song.songId))!;
      _queue.insert(0, song);
      _queueController.add(_queue);
    }
  }

  // Este método modifica la lista mutable interna _queue y luego actualiza el stream de la cola.
  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _queue.length) return;
    if (newIndex < 0 || newIndex >= _queue.length) return;

    final item = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, item);
    _queueController.add(_queue);
  }

  // Reproducir siguiente canción
  Future<void> playNext() async {
    if (_queue.isNotEmpty) {
      final nextSong = _queue.removeAt(0);
      await playSong(nextSong);
    } else {
      // No hay más canciones en la cola
      await _justAudioPlayer.stop();
      _isPlaying = false;
    }
    _queueController.add(_queue);
  }

  // Reproducir canción anterior
  Future<void> playPrevious() async {
    if (_history.isNotEmpty) {
      final previousSong = _history.removeLast();
      // Añadir la canción actual al inicio de la cola para no perderla
      if (_currentSong != null) {
        _queue.insert(0, _currentSong!);
      }
      await playSong(previousSong);
    } else {
      // No hay canción anterior; reiniciar la canción actual
      await _justAudioPlayer.seek(Duration.zero);
      await resume();
    }
    _queueController.add(_queue);
  }

  // Eliminar canción de la cola
  void removeFromQueue(int index) {
    if (index < 0 || index >= _queue.length) return;
    _queue.removeAt(index);
    _queueController.add(_queue);
  }

  void dispose() {
    _justAudioPlayer.dispose();
    _songController.close();
    _queueController.close();
    _playerStateListener?.cancel();
  }
}