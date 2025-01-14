import 'dart:async';

import 'package:finmusic/infrastructure/services/base_player_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../../config/utils/background_tasks.dart';
import '../../../config/utils/pretty_print.dart';
import '../../../domain/entities/song.dart';

class JustAudioService extends BasePlayerService {
  final AudioPlayer _justAudioPlayer = AudioPlayer();
  final _songController = StreamController<Song?>.broadcast();
  final _queueController = StreamController<List<Song>>.broadcast();
  StreamSubscription? _playerStateListener;
  final _playlist = ConcatenatingAudioSource(children: []);
  Song? _currentSong;
  bool _isPlaying = false;

  JustAudioService() {
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
  @override
  Song? get currentSong => _currentSong;

  @override
  bool get isPlaying => _isPlaying;

  @override
  Stream<bool> get playingStream => _justAudioPlayer.playingStream;

  @override
  Stream<Song?> get currentSongStream => _songController.stream;

  @override
  List<Song> get queue => List.unmodifiable(_queue);

  @override
  Stream<List<Song>> get queueStream => _queueController.stream;

  // Getters para la posición y duración de la canción
  @override
  Duration get currentPosition => _justAudioPlayer.position;

  @override
  Duration get totalDuration => _justAudioPlayer.duration ?? Duration.zero;

  @override
  Stream<Duration> get positionStream => _justAudioPlayer.positionStream;

  @override
  Stream<Duration?> get durationStream => _justAudioPlayer.durationStream;

  // Método para buscar una posición específica
  @override
  Future<void> seek(Duration position) async {
    await _justAudioPlayer.seek(position);
  }

  // Reproducir una canción
  @override
  Future<void> playSong(Song song, [int retryCount = 0]) async {
    // Verificar URL primero
    if(song.streamUrl.isEmpty) {
      final streamUrl = await getStreamUrlInBackground(song.songId);
      if (streamUrl == null || streamUrl.isEmpty) {
        // Remover la canción de la cola si está en ella
        final songIndex = _queue.indexWhere((s) => s.songId == song.songId);
        if (songIndex != -1) {
          _queue.removeAt(songIndex);
          _queueController.add(List.from(_queue));
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
  
    // Verificar si la canción está en la cola y eliminarla
    final queueIndex = _queue.indexWhere((s) => s.songId == song.songId);
    if (queueIndex != -1) {
      _queue.removeAt(queueIndex);
      // No es necesario remover del playlist aquí ya que se limpiará después
    }
  
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
  
      await _playlist.clear();
      await _playlist.addAll(sources);
      await _justAudioPlayer.setAudioSource(_playlist, initialPosition: Duration.zero);
      await _justAudioPlayer.play();
      _isPlaying = true;
      
      // Notificar cambios en la cola
      _queueController.add(List.from(_queue));
      
    } catch (e) {
      printERROR('Error al reproducir la canción: $e');
      if (_queue.isNotEmpty) {
        final nextSong = _queue.removeAt(0);
        await playSong(nextSong);
      }
    }
  }

  @override
  Future<void> pause() async {
    await _justAudioPlayer.pause();
    _isPlaying = false;
  }

  @override
  Future<void> resume() async {
    if (_currentSong != null) {
      await _justAudioPlayer.play();
      _isPlaying = true;
    }
  }

  @override
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
  @override
  Future<void> addToQueue(Song song) async {
    // Evitar duplicados verificando por songId
    if (!_queue.any((s) => s.songId == song.songId)) {
      // Validar URL
      if(song.streamUrl.isEmpty) {
        final streamUrl = await getStreamUrlInBackground(song.songId);
        if (streamUrl == null || streamUrl.isEmpty) return;
        song.streamUrl = streamUrl;
      }

      try {
        // Si no hay canción reproduciéndose, reproducir esta
        if (_currentSong == null) {
          await playSong(song);
          return;
        }

        // Añadir a la cola
        _queue.add(song);
        
        // Crear AudioSource para la nueva canción
        final audioSource = AudioSource.uri(
          Uri.parse(song.streamUrl),
          tag: MediaItem(
            id: song.songId,
            title: song.title,
            artist: song.author,
            artUri: Uri.parse(song.thumbnailUrl),
          ),
        );

        // Añadir al playlist y notificar cambios
        await _playlist.add(audioSource);
        _queueController.add(List.from(_queue)); // Enviar copia de la lista
      } catch (e) {
        // Si hay error, revertir cambios
        final index = _queue.indexWhere((s) => s.songId == song.songId);
        if (index != -1) {
          _queue.removeAt(index);
          await _playlist.removeAt(index);
        }
        _queueController.add(List.from(_queue));
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
  @override
  Future<void> addNext(Song song) async {
    if (!_queue.contains(song)) {
      // Validar URL
      if(song.streamUrl.isEmpty) {
        final streamUrl = await getStreamUrlInBackground(song.songId);
        if (streamUrl == null || streamUrl.isEmpty) return;
        song.streamUrl = streamUrl;
      }
  
      try {
        if (_currentSong == null) {
          await playSong(song);
          return;
        }
  
        // Usar índice del reproductor actual
        final currentIndex = _justAudioPlayer.currentIndex ?? 0;
        
        // Crear AudioSource
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
  
        // Insertar en queue y playlist
        _queue.insert(currentIndex + 1, song);
        await _playlist.insert(currentIndex + 1, audioSource);
        
        // Notificar cambios
        _queueController.add(_queue);
  
      } catch (e) {
        printERROR('Error al agregar siguiente canción: $e');
        // Revertir cambios si hay error
        final index = _queue.indexOf(song);
        if (index != -1) {
          _queue.removeAt(index);
          _queueController.add(_queue);
        }
      }
    }
  }

  // Este método modifica la lista mutable interna _queue y luego actualiza el stream de la cola.
  @override
  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _queue.length) return;
    
    // Ajustar el índice cuando se mueve hacia abajo
    if (newIndex > oldIndex) newIndex--;
    
    // Mover en la cola
    final item = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, item);

    // Sincronizar con el playlist
    _playlist.move(oldIndex, newIndex).then((_) {
      // Notificar cambios con una copia de la lista
      _queueController.add(List.from(_queue));
    });
  }

  // Reproducir siguiente canción
  @override
  Future<void> playNext() async {
    try {
      if (_justAudioPlayer.hasNext) {
        // Esperar a que se complete la transición
        await _justAudioPlayer.seekToNext();
        await _justAudioPlayer.play();
        
        // Actualizar la cola después de confirmar la transición
        if (_queue.isNotEmpty) {
          _queue.removeAt(0);
          _queueController.add(List.from(_queue));
        }
        
      } else if (_queue.isNotEmpty) {
        // Si no hay siguiente en el playlist pero hay canciones en cola
        final nextSong = _queue[0];
        await playSong(nextSong); 
      } else {
        await _justAudioPlayer.stop();
        _isPlaying = false;
      }
    } catch (e) {
      printERROR('Error en playNext: $e');
      if (_queue.isNotEmpty) {
        _queue.removeAt(0);
        _queueController.add(List.from(_queue));
        await playNext();
      }
    }
  }

  // Reproducir canción anterior
  @override
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
  @override
  void removeFromQueue(int index) {
    if (index < 0 || index >= _queue.length) return;
    _queue.removeAt(index);
    _queueController.add(_queue);
  }

  @override
  void dispose() {
    _justAudioPlayer.dispose();
    _songController.close();
    _queueController.close();
    _playerStateListener?.cancel();
  }
}