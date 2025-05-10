import '../../domain/entities/song.dart';

abstract class BasePlayerService {
  Future<void> playSong(Song song);
  Future<void> pause();
  Future<void> resume();
  void updateCurrentSong(Song song);
  Future<void> togglePlay();
  Future<void> playNext();
  Future<void> playPrevious();
  Future<void> seek(Duration position);
  Future<void> addToQueue(Song song);
  Future<void> addNext(Song song);
  void removeFromQueue(int index);
  void reorderQueue(int oldIndex, int newIndex);
  void dispose();
  Future<void> resetPlayer();

  // Getters
  Song? get currentSong;
  bool get isPlaying;
  Duration get currentPosition;
  Duration get totalDuration;
  List<Song> get queue;
  
  // Streams
  Stream<bool> get playingStream;
  Stream<Song?> get currentSongStream;
  Stream<List<Song>> get queueStream;
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
}