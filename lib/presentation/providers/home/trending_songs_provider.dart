import 'package:apolo/domain/repositories/songs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/song.dart';
import '../song_repository_provider.dart';

// Estado: Lista de canciones
final trendingSongsProvider = StateNotifierProvider<TrendingSongsNotifier, List<Song>>((ref) {
  final songRepository = ref.watch(songRepositoryProvider);
  return TrendingSongsNotifier(songRepository: songRepository);
});

// Notifier que maneja el estado
class TrendingSongsNotifier extends StateNotifier<List<Song>> {
  final SongsRepository songRepository;

  TrendingSongsNotifier({
    required this.songRepository
  }): super([]); // Estado inicial: lista vacía

  Future<void> loadSongs() async {
    try {
      final songs = await songRepository.getTrendingSongs();
      state = songs;
    } catch (e) {
      // En caso de error mantenemos el estado anterior
      throw Exception('Error al cargar las canciones en tendencia');
    }
  }
}