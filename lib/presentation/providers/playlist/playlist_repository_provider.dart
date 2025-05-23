import 'package:ritmora/infrastructure/datasources/sqflite_playlist_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/repositories/playlist_repository_impl.dart';

final playlistRepositoryProvider = Provider((ref) => 
  PlaylistRepositoryImpl(datasource: SqflitePlaylistDatasource())
);