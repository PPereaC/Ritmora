import 'dart:convert';
import 'package:dio/dio.dart';

import '../../domain/entities/youtube_song.dart';

class MusicService {
  final Dio dio = Dio();
  final Map<String, String> headers = {
    'user-agent': 'Apidog/1.0.0 (https://apidog.com)',
    'accept': '*/*',
    'accept-encoding': 'gzip, deflate, br',
    'content-type': 'application/json',
    'origin': 'https://music.youtube.com',
  };

  final Map<String, dynamic> context = {
    'context': {
      'client': {
        'clientName': 'WEB_REMIX',
        'clientVersion': '1.20250401.01.00',
        'hl': 'es',
        'gl': 'ES',
        'platform': 'DESKTOP',
        'userAgent': 'Apidog/1.0.0 (https://apidog.com)',
        'visitorData': 'CgtVQkJBMTBDLXQ4SSjDy6PABjInCgJFUxIhEh0SGwsMDg8QERITFBUWFxgZGhscHR4fICEiIyQlJiAZ',
      },
      'capabilities': {},
      'request': {
        'internalExperimentFlags': [],
        'sessionIndex': '',
      },
    },
  };

  // Generar visitorId dinámicamente
  Future<String?> generateVisitorId() async {
    try {
      final response = await dio.get('https://music.youtube.com', options: Options(headers: headers));
      final reg = RegExp(r'ytcfg\.set\s*\(\s*({.+?})\s*\)\s*;');
      final matches = reg.firstMatch(response.data.toString());
      if (matches != null) {
        final ytcfg = json.decode(matches.group(1)!);
        return ytcfg['VISITOR_DATA']?.toString();
      }
      return null;
    } catch (e) {
      print('Error generando visitorId: $e');
      return null;
    }
  }

  // Inicializar headers y context con visitorId dinámico
  Future<void> initialize() async {
    final visitorId = await generateVisitorId();
    if (visitorId != null) {
      headers['X-Goog-Visitor-Id'] = visitorId;
      context['context']['client']['visitorData'] = visitorId;
      print('Nuevo visitorId: $visitorId');
    } else {
      print('No se pudo generar visitorId, usando valor por defecto');
    }
  }

  Future<List<YoutubeSong>> getAllPlaylistSongs(String playlistId) async {
    try {
      // Inicializar visitorId
      await initialize();

      // Asegurar que el browseId tenga el prefijo VL
      final browseId = playlistId.startsWith('VL') ? playlistId : 'VL$playlistId';
      print('Usando browseId: $browseId');

      final data = Map<String, dynamic>.from(context)..['browseId'] = browseId;

      // Primera solicitud
      final response = await _sendRequest('browse', data);
      final json = response.data;

      // Depuración
      print('Código de estado: ${response.statusCode}');
      if (json.containsKey('error')) {
        print('Error en la respuesta JSON: ${json['error']}');
      }
      if (json.containsKey('contents')) {
        print('Claves en contents: ${json['contents'].keys}');
      }

      // Nueva ruta para musicPlaylistShelfRenderer
      var shelf = _nav(json, [
        'contents',
        'twoColumnBrowseResultsRenderer',
        'secondaryContents',
        'sectionListRenderer',
        'contents',
        '0',
        'musicPlaylistShelfRenderer'
      ]);

      // Ruta alternativa para álbumes o listas generadas
      if (shelf == null) {
        shelf = _nav(json, [
          'contents',
          'twoColumnBrowseResultsRenderer',
          'secondaryContents',
          'sectionListRenderer',
          'contents',
          '0',
          'musicShelfRenderer'
        ]);
      }

      if (shelf == null) {
        throw Exception(
            'No se encontró un estante de playlist válido (musicPlaylistShelfRenderer o musicShelfRenderer). '
            'Verifica el playlistId ($playlistId) y browseId ($browseId). '
            'Posibles causas: playlist no válida, privada, álbum, mix, o cambios en la API.');
      }

      List<YoutubeSong> songs = _parsePlaylistItems(shelf['contents'] ?? [], playlistId);

      // Manejar continuaciones
      if (shelf.containsKey('continuations')) {
        String? continuationToken = _nav(shelf, [
          'continuations',
          '0',
          'nextContinuationData',
          'continuation'
        ], defaultValue: null);

        while (continuationToken != null) {
          final continuationData = Map<String, dynamic>.from(context)
            ..['browseId'] = browseId;
          final continuationResponse = await _sendRequest(
            'browse',
            continuationData,
            additionalParams: '&ctoken=$continuationToken&continuation=$continuationToken',
          );
          final continuationJson = continuationResponse.data;
          final continuationShelf = _nav(continuationJson, [
            'continuationContents',
            'musicPlaylistShelfContinuation'
          ]) ?? _nav(continuationJson, [
            'continuationContents',
            'musicShelfContinuation'
          ]);

          if (continuationShelf == null) {
            print('No se encontró continuationShelf, terminando continuaciones.');
            break;
          }

          songs.addAll(_parsePlaylistItems(continuationShelf['contents'] ?? [], playlistId));

          continuationToken = _nav(continuationShelf, [
            'continuations',
            '0',
            'nextContinuationData',
            'continuation'
          ], defaultValue: null);
        }
      }

      return songs;
    } catch (e) {
      print('Error fetching playlist songs: $e');
      rethrow;
    }
  }

  Future<Response> _sendRequest(String action, Map<String, dynamic> data,
      {String additionalParams = ''}) async {
    try {
      final response = await dio.post(
        'https://music.youtube.com/youtubei/v1/$action?prettyPrint=false$additionalParams',
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          validateStatus: (status) => status != null && status < 500,
        ),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        if (response.data is! Map<String, dynamic>) {
          throw Exception('La respuesta no es un JSON válido: ${response.data}');
        }
        return response;
      }
      throw Exception('Failed to fetch data: ${response.statusCode} - ${response.data}');
    } catch (e) {
      if (e is DioException) {
        print('DioException: ${e.message}');
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
      }
      throw Exception('Network error: $e');
    }
  }

  dynamic _nav(Map<String, dynamic> json, List<String> path, {dynamic defaultValue}) {
    dynamic current = json;
    for (var key in path) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else if (current is List && int.tryParse(key) != null && current.length > int.parse(key)) {
        current = current[int.parse(key)];
      } else {
        print('Clave no encontrada: $key en la ruta ${path.join(' -> ')}');
        return defaultValue;
      }
    }
    return current;
  }

  List<YoutubeSong> _parsePlaylistItems(List<dynamic> contents, String playlistId) {
    if (contents.isEmpty) {
      print('No se encontraron contenidos en el estante de la playlist.');
      return [];
    }

    return contents.map((item) {
      final renderer = item['musicResponsiveListItemRenderer'] ?? {};
      final videoId = _nav(renderer, ['playlistItemData', 'videoId'], defaultValue: '') ??
          _nav(renderer, ['navigationEndpoint', 'watchEndpoint', 'videoId'], defaultValue: '');
      final title = _nav(renderer, [
        'flexColumns',
        '0',
        'musicResponsiveListItemFlexColumnRenderer',
        'text',
        'runs',
        '0',
        'text'
      ], defaultValue: '');
      final author = _nav(renderer, [
        'flexColumns',
        '1',
        'musicResponsiveListItemFlexColumnRenderer',
        'text',
        'runs',
        '0',
        'text'
      ], defaultValue: '');
      final duration = _nav(renderer, [
        'fixedColumns',
        '0',
        'musicResponsiveListItemFixedColumnRenderer',
        'text',
        'runs',
        '0',
        'text'
      ], defaultValue: '0:00');
      final thumbnail = _nav(renderer, [
        'thumbnail',
        'musicThumbnailRenderer',
        'thumbnail',
        'thumbnails',
        '0',
        'url'
      ], defaultValue: '');

      // Validaciones
      if (videoId.isEmpty) {
        print('Advertencia: videoId no encontrado para un elemento de la playlist');
      }
      if (title.isEmpty) {
        print('Advertencia: título no encontrado para un elemento de la playlist');
      }

      return YoutubeSong(
        songId: videoId,
        playlistId: playlistId,
        title: title,
        author: author,
        thumbnailUrl: thumbnail,
        streamUrl: '',
        endUrl: '',
        isLiked: 0,
        duration: duration,
        videoId: videoId,
        isVideo: 0,
      );
    }).toList();
  }
}