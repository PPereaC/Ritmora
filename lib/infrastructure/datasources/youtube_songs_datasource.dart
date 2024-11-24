import 'package:apolo/config/utils/pretty_print.dart';
import 'package:apolo/domain/datasources/songs_datasource.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:dio/dio.dart';

import '../../config/utils/constants.dart';
import '../mappers/piped_search_songs_mapper.dart';
import '../models/piped_search_songs_response.dart';

class YoutubeSongsDatasource extends SongsDatasource {

  CancelToken? _cancelToken;
  final dioSearch = Dio();

  Future<List<Song>> _jsonToSongs(Map<String, dynamic> json, String query) async {
    final songsResponse = PipedSearchSongsResponse.fromJson(json);
    
    final List<Song> songs = [];
    
    for (final item in songsResponse.items) {
      // ignore: unnecessary_null_comparison
      if (item.thumbnail != null) {
        songs.add(PipedSearchSongsMapper.itemToEntity(item));
      }
    }
  
    return songs;
  }

  @override
  Future<List<Song>> searchSongs(String query, String filter) async {
    
    // Cancelar la solicitud anterior
    _cancelToken?.cancel();

    // Comprobar que la query no esté vacía
    if (query.isEmpty) {
      return [];
    }

    // Realiza la solicitud a la API de búsqueda
    final response = await dioSearch.get(
      '$instance/search',
      queryParameters: {
        'q': query,
        'filter': filter,
      },
      cancelToken: _cancelToken, // Pasar el token de cancelación
    );

    printINFO("Buscando canciones con nombre => $query");

    return _jsonToSongs(response.data, query);

  }

}