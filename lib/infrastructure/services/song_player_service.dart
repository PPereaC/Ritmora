import 'dart:async';

import 'package:apolo/config/utils/pretty_print.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../config/utils/background_tasks.dart';
import '../../domain/entities/song.dart';

class SongPlayerService {
  final AudioPlayer _justAudioPlayer = AudioPlayer();
  final _songController = StreamController<Song?>.broadcast();
  final _queueController = StreamController<List<Song>>.broadcast();
  StreamSubscription? _playerStateListener;
  final _playlist = ConcatenatingAudioSource(children: []);
  Song? _currentSong;
  bool _isPlaying = false;

  SongPlayerService() {
    // Escuchar cambios de estado del reproductor
    _playerStateListener = _justAudioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });

    // Listener para cambios de índice en la cola de reproducción (playlist)
    _justAudioPlayer.currentIndexStream.listen((index) {
      if (index != null && _playlist.length > index) {
        final mediaItem = _playlist.sequence[index].tag as MediaItem;
        final currentSongIndex = _queue.indexWhere((song) => song.songId == mediaItem.id);
        
        if (currentSongIndex != -1) {
          _currentSong = _queue[currentSongIndex];
          _songController.add(_currentSong);
        }
      }
    });
  
    // Configuración de los controles multimedia
    AudioSession.instance.then((session) async {
      await session.configure(const AudioSessionConfiguration(
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
        androidWillPauseWhenDucked: true,
      ));
      await session.setActive(true);
    });
  }

  // Historial y cola de reproducción
  final List<Song> _history = [];
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
  Future<void> playSong(Song song, [int retryCount = 0]) async {

    // Verificar URL primero
    if(song.streamUrl.isEmpty) {
      final streamUrl = await getStreamUrlInBackground(song.songId);
      if (streamUrl == null || streamUrl.isEmpty) {
        // Remover la canción de la cola si está en ella
        final songIndex = _queue.indexWhere((s) => s.songId == song.songId);
        if (songIndex != -1) {
          _queue.removeAt(songIndex);
          _queueController.add(_queue);
        }
        
        // Pasar a la siguiente sin añadir al historial
        if (_queue.isNotEmpty) {
          final nextSong = _queue[0];
          await playSong(nextSong);
        } else {
          await _justAudioPlayer.stop();
          _isPlaying = false;
        }
        return;
      }
      song.streamUrl = streamUrl;
    }

    // Si llegamos aquí, la canción tiene URL válida
    if (_currentSong != null) {
      _history.add(_currentSong!);
    }

    // Limpiar cola actual
    _queue.clear();
    _queueController.add(_queue);

    _currentSong = song;
    _songController.add(song);

    try {
      // Crear el MediaSource para la canción actual
      final currentSource = AudioSource.uri(
        Uri.parse(song.streamUrl),
        tag: MediaItem(
          id: song.songId,
          title: song.title,
          artist: song.author,
          artUri: Uri.parse(song.thumbnailUrl),
        ),
      );

      final sources = [currentSource];
      
      // Agregar el resto de canciones en la cola
      for (var queuedSong in _queue) {
        if (queuedSong.songId != song.songId) {
          sources.add(
            AudioSource.uri(
              Uri.parse(queuedSong.streamUrl.isEmpty ? 
                'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3' : 
                queuedSong.streamUrl),
              tag: MediaItem(
                id: queuedSong.songId,
                title: queuedSong.title,
                artist: queuedSong.author,
                artUri: Uri.parse(queuedSong.thumbnailUrl),
              ),
            ),
          );
        }
      }

      await _playlist.clear();
      await _playlist.addAll(sources);
      await _justAudioPlayer.setAudioSource(_playlist, initialPosition: Duration.zero);
      await _justAudioPlayer.play();
      _isPlaying = true;
    } catch (e) {
      printERROR('Error al reproducir la canción: $e');
      if (_queue.isNotEmpty) {
        final nextSong = _queue.removeAt(0);
        await playSong(nextSong);
      }
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
      // Obtener URL si es necesario y validar
      if(song.streamUrl.isEmpty) {
        final streamUrl = await getStreamUrlInBackground(song.songId);
        if (streamUrl == null || streamUrl.isEmpty) {
          return;
        }
        song.streamUrl = streamUrl;
      }
      
      _queue.add(song);
      
      final audioSource = AudioSource.uri(
        Uri.parse(song.streamUrl),
        tag: MediaItem(
          id: song.songId,
          title: song.title,
          artist: song.author,
          artUri: Uri.parse(song.thumbnailUrl),
          duration: Duration.zero,
        ),
      );

      // Si es la primera canción en la cola y no hay nada reproduciéndose actualmente, reproducir
      if (_queue.length == 1 && _currentSong == null) {
        await playSong(song);
      } else {
        await _playlist.add(audioSource);
        _queueController.add(_queue);
      }
    }
  }

  // Añadir una lista de canciones a la cola
  Future<void> addSongsToQueue(List<Song> songs) async {
    for (var song in songs) {
      if (!_queue.contains(song)) {
        if(song.streamUrl.isEmpty) {
          final streamUrl = await getStreamUrlInBackground(song.songId);
          if (streamUrl == null || streamUrl.isEmpty) {
            continue; // Saltar a la siguiente si no hay una URL válida
          }
          song.streamUrl = streamUrl;
        }
        
        _queue.add(song);
        
        await _playlist.add(
          AudioSource.uri(
            Uri.parse(song.streamUrl),
            tag: MediaItem(
              id: song.songId,
              title: song.title,
              artist: song.author,
              artUri: Uri.parse(song.thumbnailUrl),
              duration: Duration.zero,
            ),
          ),
        );
      }
    }
    
    _queueController.add(_queue);
  }

  // Añadir canción siguiente en la cola
  Future<void> addNext(Song song) async {
    if (!_queue.contains(song)) {
      // Obtener y validar URL primero
      if(song.streamUrl.isEmpty) {
        final streamUrl = await getStreamUrlInBackground(song.songId);
        if (streamUrl == null || streamUrl.isEmpty) {
          return; // No añadir si no hay una URL válida
        }
        song.streamUrl = streamUrl;
      }
  
      try {
        final currentIndex = _justAudioPlayer.currentIndex ?? 0;
        
        _queue.insert(0, song);
        
        final audioSource = AudioSource.uri(
          Uri.parse(song.streamUrl),
          tag: MediaItem(
            id: song.songId,
            title: song.title,
            artist: song.author,
            artUri: Uri.parse(song.thumbnailUrl),
            duration: Duration.zero,
          ),
        );
  
        await _playlist.insert(currentIndex + 1, audioSource);
        _queueController.add(_queue);
      } catch (e) {
        printERROR('Error al agregar siguiente canción: $e');
      }
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
    if (_justAudioPlayer.hasNext) {
      final nextIndex = (_justAudioPlayer.currentIndex ?? -1) + 1;
      if (nextIndex < _queue.length) {
        final nextSong = _queue[nextIndex];
        if (nextSong.streamUrl.isEmpty || nextSong.streamUrl == 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3') {
          // Si la siguiente no tiene URL, eliminarla y probar con la siguiente
          _queue.removeAt(nextIndex);
          _queueController.add(_queue);
          await playNext();
          return;
        }
      }
      await _justAudioPlayer.seekToNext();
      await _justAudioPlayer.play();
    } else if (_queue.isNotEmpty) {
      final nextSong = _queue[0];
      await playSong(nextSong);
    } else {
      await _justAudioPlayer.stop();
      _isPlaying = false;
    }
    _queueController.add(_queue);
  }

  // Reproducir canción anterior
  Future<void> playPrevious() async {
    if (_justAudioPlayer.hasPrevious) {
      await _justAudioPlayer.seekToPrevious();
      await _justAudioPlayer.play();
    } else if (_history.isNotEmpty) {
      final previousSong = _history.removeLast();
      if (_currentSong != null) {
        _queue.insert(0, _currentSong!);
      }
      await playSong(previousSong);
    } else {
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