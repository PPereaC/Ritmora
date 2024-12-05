import 'package:apolo/config/utils/pretty_print.dart';
import 'package:apolo/domain/datasources/songs_datasource.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:dio/dio.dart';

import '../../config/utils/constants.dart';

class YoutubeSongsDatasource extends SongsDatasource {

  CancelToken? _cancelToken;

  final dioSearch = Dio(BaseOptions(
    baseUrl: 'https://music.youtube.com/youtubei/v1/',
    queryParameters: {
      'key': kPartIOS,
      'prettyPrint': 'false',
    },
  ));

  Future<Response> sendRequest(String action, Map<String, dynamic> body) async {
    try {
      final response = await dioSearch.post(action, options: Options(headers: headers), data: body);
      return response;
    } catch (e) {
      printERROR('Error sending request: $e');
      rethrow;
    }
  }

  Future<List<Song>> _jsonToSongs(Map<String, dynamic> json) async {
    final List<dynamic> sections = json['contents']['tabbedSearchResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

    final List<Song> songs = [];

    for (var section in sections) {
      if (section.containsKey('itemSectionRenderer')) {
        final items = section['itemSectionRenderer']['contents'];
        for (var item in items) {
          if (item.containsKey('musicResponsiveListItemRenderer')) {
            final musicItem = item['musicResponsiveListItemRenderer'];
            final title = musicItem['flexColumns']?[0]['musicResponsiveListItemFlexColumnRenderer']['text']['runs']?[0]['text'];
            final artist = musicItem['flexColumns']?[1]['musicResponsiveListItemFlexColumnRenderer']['text']['runs']?[0]['text'];
            final videoId = musicItem['playlistItemData']?['videoId'];
            final subtitle = item['musicResponsiveListItemFlexColumnRenderer']['text']?['runs']?[8]['text'];
            String? durationText;

            final thumbnails = musicItem['thumbnail']?['musicThumbnailRenderer']['thumbnail']['thumbnails'];
            String? thumbnailUrl;

            if (thumbnails != null) {
              // Ordenar thumbnails por tamaño (width * height) de mayor a menor
              final sortedThumbnails = List.from(thumbnails)
                ..sort((a, b) => 
                  (b['width'] * b['height']).compareTo(a['width'] * a['height'])
                );
                
              // Tomar la URL base de la thumbnail más grande
              String baseUrl = sortedThumbnails.first['url'];
              
              // Modificar la URL para obtener la máxima calidad
              // Reemplazar los parámetros w{X}-h{X} por w1000-h1000
              thumbnailUrl = baseUrl.replaceAll(RegExp(r'=w\d+-h\d+'), '=w1000-h1000');
            }


            if (subtitle != null) {
              for (var run in subtitle) {
                if (run['text'] != null && run['text'].contains(':')) {
                  durationText = run['text'];
                  break;
                }
              }
            }

            if (title != null && artist != null && thumbnailUrl != null && videoId != null) {
              songs.add(Song(
                title: title,
                author: artist,
                thumbnailUrl: thumbnailUrl,
                streamUrl: '',
                endUrl: '',
                songId: videoId,
                duration: durationText!,
              ));
            }
          }
        }
      } else if (section.containsKey('musicShelfRenderer')) {
        final items = section['musicShelfRenderer']['contents'];
        for (var item in items) {
          if (item.containsKey('musicResponsiveListItemRenderer')) {
            final musicItem = item['musicResponsiveListItemRenderer'];
            final title = musicItem['flexColumns']?[0]['musicResponsiveListItemFlexColumnRenderer']['text']['runs']?[0]['text'];
            final artist = musicItem['flexColumns']?[1]['musicResponsiveListItemFlexColumnRenderer']['text']['runs']?[0]['text'];
            final videoId = musicItem['playlistItemData']?['videoId'];
            final subtitle = musicItem['flexColumns']?[1]['musicResponsiveListItemFlexColumnRenderer']['text']['runs'];
            String? durationText;

            final thumbnails = musicItem['thumbnail']?['musicThumbnailRenderer']['thumbnail']['thumbnails'];
            String? thumbnailUrl;

            if (thumbnails != null) {
              // Ordenar thumbnails por tamaño (width * height) de mayor a menor
              final sortedThumbnails = List.from(thumbnails)
                ..sort((a, b) => 
                  (b['width'] * b['height']).compareTo(a['width'] * a['height'])
                );
                
              // Tomar la URL base de la thumbnail más grande
              String baseUrl = sortedThumbnails.first['url'];
              
              // Modificar la URL para obtener la máxima calidad
              // Reemplazar los parámetros w{X}-h{X} por w1000-h1000
              thumbnailUrl = baseUrl.replaceAll(RegExp(r'=w\d+-h\d+'), '=w1000-h1000');
            }

            if (subtitle != null) {
              for (var run in subtitle) {
                if (run['text'] != null && RegExp(r'^\d+:\d+$').hasMatch(run['text'])) {
                  durationText = run['text'];
                  break;
                }
              }
            }

            if (title != null && artist != null && thumbnailUrl != null && videoId != null) {
              songs.add(Song(
                title: title,
                author: artist,
                thumbnailUrl: thumbnailUrl,
                streamUrl: '',
                endUrl: '',
                songId: videoId,
                duration: durationText ?? '',
              ));
            }
          }
        }
      }
    }

    return songs;
  }

  String _getSearchParams(String filter) {
    if (filter == 'songs') {
      return 'Eg-KAQwIARAAGAAgACgAMABqChAEEAMQCRAFEAo%3D';
    } else if (filter == 'videos') {
      return 'Eg-KAQwIAhABGAE%3D';
    }
    return '';
  }

  @override
  Future<List<Song>> searchSongs(String query, String filter) async {
    
    // Cancelar la solicitud anterior
    _cancelToken?.cancel();

    // Comprobar que la query no esté vacía
    if (query.isEmpty) {
      return [];
    }

    final body = getBody(2);
    body['query'] = query;
    printINFO('Body: $body');

    // Añadir parámetros de búsqueda si el filtro no está vacío
    if (filter.isNotEmpty) {
      body['params'] = _getSearchParams(filter);
    }

    final response = await sendRequest('search', body);

    printINFO(response.data);

    final songs = await _jsonToSongs(response.data);

    return songs;

  }

}