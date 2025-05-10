import 'dart:async';
import 'package:ritmora/infrastructure/services/base_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../config/utils/background_tasks.dart';
import '../../../domain/entities/song.dart';

class AudioPlayersService extends BasePlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _songController = StreamController<Song?>.broadcast();
  final _queueController = StreamController<List<Song>>.broadcast();
  final StreamController<bool> _playingController = StreamController<bool>.broadcast();
  final StreamController<Duration> _positionController = StreamController<Duration>.broadcast();
  final StreamController<Duration?> _durationController = StreamController<Duration?>.broadcast();
  
  Song? _currentSong;
  bool _isPlaying = false;
  
  // Historial y cola de reproducción
  final List<Song> _history = [];
  final List<Song> _queue = [];

  Duration _lastKnownPosition = Duration.zero;
  Duration _lastKnownDuration = Duration.zero;

  AudioPlayersService() {
    // Escuchar cambios de estado del reproductor
    _audioPlayer.onPlayerComplete.listen((_) {
      playNext();
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _playingController.add(_isPlaying);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _lastKnownPosition = position;
      _positionController.add(position);
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      _lastKnownDuration = duration;
      _durationController.add(duration);
    });
  }

  // Getters
  @override
  Song? get currentSong => _currentSong;

  @override
  bool get isPlaying => _isPlaying;

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<Song?> get currentSongStream => _songController.stream;

  @override
  List<Song> get queue => List.unmodifiable(_queue);

  @override
  Stream<List<Song>> get queueStream => _queueController.stream;

  @override
  Duration get currentPosition {
    try {
      return _audioPlayer.state == PlayerState.disposed 
        ? Duration.zero 
        : _lastKnownPosition;
    } catch (_) {
      return Duration.zero;
    }
  }
  
  @override
  Duration get totalDuration {
    try {
      return _audioPlayer.state == PlayerState.disposed
        ? Duration.zero
        : _lastKnownDuration;
    } catch (_) {
      return Duration.zero;
    }
  }

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<Duration?> get durationStream => _durationController.stream;

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void updateCurrentSong(Song song) {
    _currentSong = song;
    _songController.add(song);
  }

  @override
  Future<void> playSong(Song song) async {
    if (_currentSong != null) {
      _history.add(_currentSong!);
    }

    _queueController.add(_queue);

    _currentSong = song;
    _songController.add(song);

    try {
      await _audioPlayer.play(UrlSource(song.streamUrl));
      _isPlaying = true;
    } catch (e) {
      if (_queue.isNotEmpty) {
        final nextSong = _queue.removeAt(0);
        await playSong(nextSong);
      }
    }
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
  }

  @override
  Future<void> resume() async {
    if (_currentSong != null) {
      await _audioPlayer.resume();
      _isPlaying = true;
    }
  }

  @override
  Future<void> togglePlay() async {
    if (_currentSong == null) return;

    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  @override
  Future<void> addToQueue(Song song) async {
    if (!_queue.contains(song)) {
      if(song.streamUrl.isEmpty) {
        final streamUrl = await getStreamUrlInBackground(song.songId);
        if (streamUrl == null || streamUrl.isEmpty) return;
        song.streamUrl = streamUrl;
      }
      
      _queue.add(song);
      
      if (_queue.length == 1 && _currentSong == null) {
        await playSong(song);
      }
      
      _queueController.add(_queue);
    }
  }

  @override
  Future<void> addNext(Song song) async {
    if (!_queue.contains(song)) {
      if(song.streamUrl.isEmpty) {
        final streamUrl = await getStreamUrlInBackground(song.songId);
        if (streamUrl == null || streamUrl.isEmpty) return;
        song.streamUrl = streamUrl;
      }
  
      _queue.insert(0, song);
      _queueController.add(_queue);
    }
  }

  @override
  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _queue.length) return;
    if (newIndex < 0 || newIndex >= _queue.length) return;

    final item = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, item);
    _queueController.add(_queue);
  }

  @override
  Future<void> playNext() async {
    if (_queue.isNotEmpty) {
      final nextSong = _queue.removeAt(0);
      await playSong(nextSong);
    } else {
      await _audioPlayer.stop();
      _isPlaying = false;
    }
    _queueController.add(_queue);
  }

  @override
  Future<void> playPrevious() async {
    if (_history.isNotEmpty) {
      final previousSong = _history.removeLast();
      if (_currentSong != null) {
        _queue.insert(0, _currentSong!);
      }
      await playSong(previousSong);
    } else {
      await _audioPlayer.seek(Duration.zero);
      await resume();
    }
    _queueController.add(_queue);
  }

  @override
  void removeFromQueue(int index) {
    if (index < 0 || index >= _queue.length) return;
    _queue.removeAt(index);
    _queueController.add(_queue);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _songController.close();
    _queueController.close();
    _playingController.close();
    _positionController.close();
    _durationController.close();
  }

  @override
  Future<void> resetPlayer() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    _queue.clear();
    _currentSong = null;
    _isPlaying = false;
    _history.clear();
  }

}