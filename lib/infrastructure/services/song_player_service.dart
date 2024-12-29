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
          _queue.removeAt(currentSongIndex);
          _queueController.add(_queue);
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

    // Máximo número de intentos
    const maxRetries = 3;

    // Si excedemos los intentos, lanzar error
    if (retryCount >= maxRetries) {
      printERROR('Número máximo de intentos excedido');
    }

    // Si hay una canción actual, moverla al historial
    if (_currentSong != null) {
      _history.add(_currentSong!);
    }

    _currentSong = song;
    _songController.add(song);

    // Cargar y reproducir la canción
    if(song.streamUrl.isEmpty) {
      final streamUrl = await getStreamUrlInBackground(song.songId);
      if (streamUrl == null || streamUrl.isEmpty) {
        // Incrementar contador y reintentar
        return playSong(song, retryCount + 1);
      }
      song.streamUrl = streamUrl;
    }

    try {
      // Crear el MediaSource para la canción actual
      final currentSource = AudioSource.uri(
        Uri.parse(song.streamUrl),
        tag: MediaItem(
          id: song.songId,
          title: song.title,
          artist: song.author,
          artUri: Uri.parse(song.thumbnailUrl),
          duration: _justAudioPlayer.duration,
          displayTitle: song.title,
          displaySubtitle: song.author,
        ),
      );

      // Limpiar la cola actual
      await _playlist.clear();
      
      // Agregar la canción actual y la cola
      await _playlist.add(currentSource);
      
      // Agregar el resto de canciones en la cola
      for (var queuedSong in _queue) {
        await _playlist.add(
          AudioSource.uri(
            Uri.parse(queuedSong.streamUrl),
            tag: MediaItem(
              id: queuedSong.songId,
              title: queuedSong.title,
              artist: queuedSong.author,
              artUri: Uri.parse(queuedSong.thumbnailUrl),
              duration: Duration.zero,
            ),
          ),
        );
      }

      // Establecer la fuente de audio como la playlist
      await _justAudioPlayer.setAudioSource(_playlist);
      await _justAudioPlayer.play();
      _isPlaying = true;
      _queueController.add(_queue);
    } catch (e) {
      printERROR('Error al reproducir la canción: $e');
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
      // Obtener URL si es necesario
      if(song.streamUrl.isEmpty) {
        song.streamUrl = (await getStreamUrlInBackground(song.songId)) ?? '';
      }
      
      // Agregar a la cola de canciones
      _queue.add(song);
      
      // Agregar al playlist de reproducción
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
      
      _queueController.add(_queue);
    }
  }

  // Añadir canción siguiente en la cola
  Future<void> addNext(Song song) async {
    if (!_queue.contains(song)) {
      // Obtener la stream URL si es necesario
      if(song.streamUrl.isEmpty) {
        song.streamUrl = (await getStreamUrlInBackground(song.songId)) ?? '';
      }
  
      try {
        // Obtener el índice actual de reproducción
        final currentIndex = _justAudioPlayer.currentIndex ?? 0;
        
        // Agregar al inicio de la cola
        _queue.insert(0, song);
        
        // Crear el AudioSource para la nueva canción
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
  
        // Insertar después de la canción actual
        await _playlist.insert(currentIndex + 1, audioSource);
        
        // Notificar cambios en la cola
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
      await _justAudioPlayer.seekToNext();
      await _justAudioPlayer.play();
    } else if (_queue.isNotEmpty) {
      final nextSong = _queue.removeAt(0);
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