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
  Dio dio = Dio(BaseOptions(
    baseUrl: 'https://music.youtube.com/youtubei/v1/',
    queryParameters: {
      'key': 'AIzaSyB-63vPrdThhKuerbB2N_l7Kwwcxj6yUAc',
      'prettyPrint': 'false',
    },
  ));

  Future<Response> sendRequest(String action, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(action, options: Options(headers: headers), data: body);
      return response;
    } catch (e) {
      printERROR('Error sending request: $e');
      rethrow;
    }
  }

  // Método para obtener la URL de la carátula de mayor calidad desde Youtube directamente
  Future<List<String?>> _getHigherQualityThumbnail(String query) async {
    List<String?> thumbnailUrls = [];
    final Map<String, dynamic> body = Map<String, dynamic>.from(context);
    body['query'] = query;

    final youtubeResponse = await sendRequest('search', body);
    String? thumbnailUrl;

    final List<dynamic> sections = youtubeResponse.data['contents']['tabbedSearchResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];
    for (var section in sections) {
      if (section.containsKey('musicShelfRenderer')) {
        final items = section['musicShelfRenderer']['contents'];
        for (var item in items) {
          if (item.containsKey('musicResponsiveListItemRenderer')) {
            final musicItem = item['musicResponsiveListItemRenderer'];
            final thumbnails = musicItem['thumbnail']?['musicThumbnailRenderer']['thumbnail']['thumbnails'];
            
            if (thumbnails != null) {
              // Ordenar thumbnails por tamaño (width * height) de mayor a menor
              final sortedThumbnails = List.from(thumbnails)
                ..sort((a, b) => 
                  (b['width'] * b['height']).compareTo(a['width'] * a['height'])
                );
                
              // Tomar la URL base de la thumbnail más grande
              String baseUrl = sortedThumbnails.first['url'];
              
              // Modificar la URL para obtener la máxima calidad de las carátulas
              // Reemplazar los parámetros w{X}-h{X} por w1000-h1000 para mayor calidad
              thumbnailUrl = baseUrl.replaceAll(RegExp(r'=w\d+-h\d+'), '=w1000-h1000');
              thumbnailUrls.add(thumbnailUrl);
            }
          }
        }
      }
    }
    return thumbnailUrls;
  }

  Future<List<Song>> _jsonToSongs(Map<String, dynamic> json, String query) async {
    final thumbnailsUrls = await _getHigherQualityThumbnail(query);
    printINFO('Thumbnails de Youtube: $thumbnailsUrls');
    final songsResponse = PipedSearchSongsResponse.fromJson(json);
    
    final List<Song> songs = [];
    var index = 0;
    
    for (final item in songsResponse.items) {
      // ignore: unnecessary_null_comparison
      if (item.thumbnail != null) {
        final youtubeThumbnail = index < thumbnailsUrls.length ? thumbnailsUrls[index] : null;
        songs.add(PipedSearchSongsMapper.itemToEntity(
          item,
          youtubeThumbnail: youtubeThumbnail
        ));
        index++;
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