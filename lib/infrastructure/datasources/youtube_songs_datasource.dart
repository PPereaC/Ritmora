import 'package:apolo/config/utils/pretty_print.dart';
import 'package:apolo/domain/datasources/songs_datasource.dart';
import 'package:apolo/domain/entities/song.dart';
import 'package:apolo/infrastructure/mappers/youtube_search_songs_response.dart';
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

  Future<Response> _sendRequest(String action, Map<String, dynamic> body) async {
    try {
      final response = await dioSearch.post(action, options: Options(headers: headers), data: body);
      return response;
    } catch (e) {
      printERROR('Error sending request: $e');
      rethrow;
    }
  }

  static String _getHighQualityThumbnail(String videoId) {
    return 'https://i.ytimg.com/vi/$videoId/maxresdefault.jpg';
  }

  Future<List<Song>> _jsonToSongs(Map<String, dynamic> json) async {
    final response = YoutubeSearchSongsResponse.fromJson(json);
    final sections = response.contents.tabbedSearchResultsRenderer.tabs.first.tabRenderer.content.sectionListRenderer.contents;
    final List<Song> songs = [];

    for (var section in sections) {

      // Verificar si tiene ItemSectionRenderer
      if (section.itemSectionRenderer != null) {
        final items = section.itemSectionRenderer?.contents ?? [];
        for (var item in items) {
          if (item.musicResponsiveListItemRenderer != null) {
            _processListItem(item.musicResponsiveListItemRenderer!, songs);
          }
        }
      }
      else if (section.musicShelfRenderer != null) { // Verificar si tiene MusicShelfRenderer
        final items = section.musicShelfRenderer?.contents ?? [];
        for (var item in items) {
          _processListItem(item.musicResponsiveListItemRenderer, songs);
        }
      }
    }

    return songs;
  }
  
  void _processListItem(MusicResponsiveListItemRenderer musicItem, List<Song> songs) {

    // Verificar que existan los flexColumns necesarios
    if (musicItem.flexColumns.length < 2) return;

    // Extraer datos usando acceso seguro con ?. y ?? para valores por defecto
    final title = musicItem.flexColumns[0].musicResponsiveListItemFlexColumnRenderer.text?.runs.firstOrNull?.text ?? '';
    final artist = musicItem.flexColumns[1].musicResponsiveListItemFlexColumnRenderer.text?.runs.firstOrNull?.text ?? '';
    final videoId = musicItem.playlistItemData.videoId;

    // Obtener duración de la canción
    String? durationText;
    final runs = musicItem.flexColumns[1].musicResponsiveListItemFlexColumnRenderer.text?.runs ?? [];
    for (var run in runs) {
      if ((run.text).contains(':')) {
        durationText = run.text;
        break;
      }
    }

    // Obtener thumbnail de alta calidad
    String? thumbnailUrl = _getHighQualityThumbnail(videoId);

    // Solo agregar si tenemos los datos mínimos necesarios
    if (title.isNotEmpty && artist.isNotEmpty && videoId.isNotEmpty) {
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

  // Obtener parámetros de búsqueda para filtrar por canciones o videos
  String _getSearchParams(String filter) {
    if (filter == 'songs') {
      return 'Eg-KAQwIARAAGAAgACgAMABqChAEEAMQCRAFEAo%3D'; // Para canciones
    } else if (filter == 'videos') {
      return 'Eg-KAQwIAhABGAE%3D'; // Para videos musicales
    }
    return '';
  }

  @override
  Future<List<Song>> searchSongs(String query, String filter) async {
    // Cancelar la solicitud anterior
    _cancelToken?.cancel();

    // [DEBUG] Imprimir información de la búsqueda
    printINFO('Realizando búsqueda >> $query');

    // Comprobar que la query no esté vacía
    if (query.isEmpty) {
      return [];
    }

    final body = getBody(2);
    body['query'] = query;

    // Añadir parámetros de búsqueda si el filtro no está vacío
    if (filter.isNotEmpty) {
      final params = _getSearchParams(filter);
      body['params'] = params;
    }

    final response = await _sendRequest('search', body);
    final songs = await _jsonToSongs(response.data);

    return songs;
  }

}