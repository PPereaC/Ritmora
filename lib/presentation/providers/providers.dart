import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'search_provider.dart';
export 'theme/theme_provider.dart';
export 'home/home_playlists_provider.dart';
export 'home/quick_picks_provider.dart';
export 'home/trending_songs_provider.dart';
export 'home/playlist_songs_provider.dart';
export 'song_player_provider.dart';
export 'song_color_provider.dart';
export 'loading_provider.dart';

final navbarIndexProvider = StateProvider<int>((ref) => 0);