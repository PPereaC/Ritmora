import 'package:apolo/infrastructure/datasources/youtube_songs_datasource.dart';
import 'package:apolo/infrastructure/repositories/song_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final songRepositoryProvider = Provider((ref) => 
  SongRepositoryImpl(datasource: YoutubeSongsDatasource())
);