import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/services/song_player_service.dart';

final songPlayerProvider = Provider<SongPlayerService>((ref) {
  return SongPlayerService();
});