import 'package:apolo/domain/repositories/songs_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/song.dart';
import '../song_repository_provider.dart';

// Estado: Lista de canciones
final quickPicksProvider = StateNotifierProvider<QuickPicksNotifier, List<Song>>((ref) {
  final songRepository = ref.watch(songRepositoryProvider);
  return QuickPicksNotifier(songRepository: songRepository);
});

// Notifier que maneja el estado
class QuickPicksNotifier extends StateNotifier<List<Song>> {
  final SongsRepository songRepository;

  QuickPicksNotifier({
    required this.songRepository
  }): super([]); // Estado inicial: lista vacía

  Future<void> loadSongs() async {
    try {
      final quickpicks = await songRepository.getQuickPicks();
      state = quickpicks;
    } catch (e) {
      // En caso de error mantenemos el estado anterior
      throw Exception('Error al cargar las selecciones rápidas');
    }
  }
}