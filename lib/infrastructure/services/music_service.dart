// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/utils/constants.dart';
import '../../config/utils/pretty_print.dart';
import '../../domain/entities/youtube_song.dart';

const mrlir = 'musicResponsiveListItemRenderer';

const thumbnails = [
  'thumbnail',
  'musicThumbnailRenderer',
  'thumbnail',
  'thumbnails'
];

/// Obtiene la thumbnail de un video o canción de YouTube/YouTube Music con la mejor calidad disponible.
Future<String?> getYouTubeThumbnail(String videoId) async {
  // Lista de posibles calidades de thumbnail, de mejor a peor
  final thumbnailQualities = [
    'maxresdefault',
    'sddefault',
    'hqdefault',
    'mqdefault',
    'default',
  ];

  // Base URL para las carátulas de YouTube
  const baseUrl = 'https://img.youtube.com/vi';

  // Configurar Dio
  final dio = Dio();

  // Probar cada calidad en orden
  for (String quality in thumbnailQualities) {
    final thumbnailUrl = '$baseUrl/$videoId/$quality.jpg';
    
    try {
      // Hacer una petición HEAD para verificar si la imagen existe
      final response = await dio.head(
        thumbnailUrl,
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      // Si la respuesta es 200, la imagen existe y es válida
      if (response.statusCode == 200) {
        return thumbnailUrl;
      }
    } catch (e) {
      // Ignorar errores (timeout, 404, etc.) y probar la siguiente calidad
      continue;
    }
  }

  // Si no se encuentra ninguna carátula válida, retornar null
  return null;
}

dynamic _nav(dynamic root, List items, {bool noneIfAbsent = false}) {
  try {
    dynamic res = root;
    for (final item in items) {
      if (res is Map && res.containsKey(item)) {
        res = res[item];
      } else if (res is List && item is int && item >= 0 && item < res.length) {
        res = res[item];
      } else {
        return noneIfAbsent ? null : null;
      }
    }
    return res;
  } catch (e) {
    return noneIfAbsent ? null : null;
  }
}

Map<String, dynamic> _getFlexColumnItem(Map<String, dynamic> item, int index) {
  if ((item['flexColumns']?.length ?? 0) <= index ||
      !item['flexColumns'][index]['musicResponsiveListItemFlexColumnRenderer']
          .containsKey('text') ||
      !item['flexColumns'][index]['musicResponsiveListItemFlexColumnRenderer']
              ['text']
          .containsKey('runs')) {
    return {};
  }
  return item['flexColumns'][index]
      ['musicResponsiveListItemFlexColumnRenderer'];
}

String? _getItemText(Map<String, dynamic> item, int index) {
  final flexItem = _getFlexColumnItem(item, index);
  return _nav(flexItem, ['text', 'runs', 0, 'text']);
}

List<Map<String, dynamic>>? _parseSongArtistsNav(
    Map<String, dynamic> data, int index) {
  dynamic flexItem = _getFlexColumnItem(data, index);
  if (flexItem == null || flexItem.isEmpty) {
    return null;
  }
  var runs = _nav(flexItem, ['text', 'runs']);
  if (runs == null) return null;

  final artists = <Map<String, dynamic>>[];
  for (int i = 0; i < runs.length; i++) {
    final run = runs[i];
    if (run['text'] == ', ' || run['text'] == ' & ') {
      continue; // Separadores comunes
    }
    artists.add({
      'name': run['text'],
      'id': _nav(run, ['navigationEndpoint', 'browseEndpoint', 'browseId']),
    });
  }
  return artists;
}

Map<String, dynamic> _getFixedColumnItem(Map<String, dynamic> item, int index) {
  if ((item['fixedColumns']?.length ?? 0) <= index ||
      !item['fixedColumns'][index]['musicResponsiveListItemFixedColumnRenderer']
          .containsKey('text')) {
    return {};
  }
  return item['fixedColumns'][index]
      ['musicResponsiveListItemFixedColumnRenderer'];
}

// --- FIN: Constantes y helpers de navegación ---

// --- INICIO: Constantes y helpers de continuación ---
const _continuation_token_path = [
  "continuationItemRenderer",
  "continuationEndpoint",
  "continuationCommand",
  "token"
];
const _continuation_items_path = [
  "onResponseReceivedActions",
  0,
  "appendContinuationItemsAction",
  "continuationItems"
];

String? _getContinuationTokenFromContents(List<dynamic> contents) {
  if (contents.isEmpty) return null;
  return _nav(contents.last, _continuation_token_path);
}
// --- FIN: Constantes y helpers de continuación ---

class MusicService {
  final Dio dio = Dio();

  final Map<String, String> _headers = {
    'user-agent': userAgent,
    'accept': '*/*',
    'accept-encoding': 'gzip, deflate',
    'content-type': 'application/json',
    'origin': domain,
    'cookie': 'CONSENT=YES+1',
  };

  final Map<String, dynamic> _context = getBody(2);

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    // Actualiza la versión del cliente dinámicamente
    final date = DateTime.now();
    _context['context']['client']['clientVersion'] = "1.${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}.01.00";

    // Intenta obtener el visitorId de SharedPreferences
    final visitorIdDataString = prefs.getString('visitorId');
    if (visitorIdDataString != null) {
      try {
        final visitorData =
            jsonDecode(visitorIdDataString) as Map<String, dynamic>;
        if (visitorData['id'] != null &&
            visitorData['exp'] != null &&
            !_isExpired(epoch: visitorData['exp'])) {
          _headers['X-Goog-Visitor-Id'] = visitorData['id'];
          await prefs.setString(
              'visitorId',
              jsonEncode({
                'id': visitorData['id'],
                'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 +
                    2592000 // Extiende 30 días
              }));
        }
      } catch (e) {
        printERROR("Error decoding visitorId from SharedPreferences: $e");
        await prefs.remove('visitorId');
      }
    }

    // Si no hay visitorId válido, genera uno nuevo
    if (!_headers.containsKey('X-Goog-Visitor-Id')) {
      final visitorId = await _generateVisitorId();
      if (visitorId != null) {
        _headers['X-Goog-Visitor-Id'] = visitorId;
        await prefs.setString(
            'visitorId',
            jsonEncode({
              'id': visitorId,
              'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 2592000
            }));
      } else {
        // Usa el valor por defecto si no se pudo generar
        _headers['X-Goog-Visitor-Id'] = "CgttN24wcmd5UzNSWSi2lvq2BjIKCgJKUBIEGgAgYQ%3D%3D"; // Visitor ID por defecto
      }
    }
  }

  bool _isExpired({required int epoch}) {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000 > epoch;
  }

  Future<String?> _generateVisitorId() async {
    try {
      final response = await dio.get(domain,
          options: Options(headers: _headers..remove('X-Goog-Visitor-Id')));
      final reg =
          RegExp(r'ytcfg\.set\s*\(\s*({.+?})\s*\)\s*;', multiLine: true);
      final matches = reg.firstMatch(response.data.toString());
      if (matches != null) {
        final ytcfg = json.decode(matches.group(1).toString());
        final visitorId = ytcfg['VISITOR_DATA']?.toString();
        if (visitorId != null && visitorId.isNotEmpty) {
          return visitorId;
        }
      }
      printERROR('No se encontró VISITOR_DATA en la respuesta de $domain');
    } catch (e) {
      printERROR('Error al generar visitorId: $e');
    }
    return null;
  }

  Future<List<YoutubeSong>> getPlaylistSongs(String playlistUrl) async {
    await _init();

    try {
      final playlistId = _extractPlaylistId(playlistUrl);
      if (playlistId.isEmpty) {
        throw Exception('URL de lista de reproducción inválida');
      }

      final playlistData =
          await _getPlaylistOrAlbumSongs(playlistId: playlistId);

      // El 'tracks' que devuelve _getPlaylistOrAlbumSongs ya debería ser una lista de mapas procesados por _parsePlaylistItems
      final List<Map<String, dynamic>> tracks =
          playlistData['tracks']?.cast<Map<String, dynamic>>() ?? [];

      final songs = await Future.wait(tracks.map<Future<YoutubeSong>>((track) async {
        final thumbnailUrl = await getYouTubeThumbnail(track['videoId']) ?? '';
        return YoutubeSong(
          songId: track['videoId'] ?? '',
          playlistId: playlistId,
          title: track['title'] ?? 'Desconocido',
          author: track['artists']?.isNotEmpty ?? false
              ? (track['artists'][0] is Map
                      ? track['artists'][0]['name']
                      : track['artists'][0].toString()) ??
                  'Desconocido'
              : 'Desconocido',
          thumbnailUrl: thumbnailUrl,
          streamUrl: '',
          endUrl: '/watch?v=${track['videoId']}',
          duration: track['length']?.toString() ?? '0',
        );
      }));

      printINFO('Total canciones obtenidas: ${songs.length}');
      return songs;
    } catch (e) {
      printERROR('Error al obtener canciones de playlist: $e');
      rethrow;
    } finally {}
  }

  Future<Map<String, dynamic>> _getPlaylistOrAlbumSongs({String? playlistId, int limit = 3000}) async {
    String browseId = playlistId!.startsWith("VL") ? playlistId : "VL$playlistId";

    final data = Map<String, dynamic>.from(_context);
    data['browseId'] = browseId;

    final responseData = (await _sendRequest('browse', data)).data as Map<String, dynamic>;

    // Verificación de error simple
    if (responseData.containsKey('error')) {
      printERROR('Error en la respuesta de la API: ${responseData['error']}');
      throw Exception(
          'Error en la respuesta de la API: ${responseData['error']['message']}');
    }

    final Map<String, dynamic>? results = _nav(responseData, [
          'contents',
          "singleColumnBrowseResultsRenderer",
          "tabs",
          0,
          "tabRenderer",
          "content",
          'sectionListRenderer',
          'contents',
          0,
          "musicPlaylistShelfRenderer"
        ]) ??
        _nav(responseData, [
          "contents",
          "twoColumnBrowseResultsRenderer",
          "secondaryContents",
          "sectionListRenderer",
          "contents",
          0,
          "musicPlaylistShelfRenderer"
        ]) ??
        _nav(responseData, [
          "contents",
          "twoColumnBrowseResultsRenderer",
          "tabs",
          0,
          "tabRenderer",
          "content",
          "sectionListRenderer",
          "contents",
          0,
          "musicPlaylistShelfRenderer"
        ]);

    if (results == null) {
      printERROR(
          'No se encontraron "musicPlaylistShelfRenderer" en la respuesta. JSON (primeros 1000 chars): ${jsonEncode(responseData).substring(0, 1000)}');
      _logJsonStructure(responseData, depth: 3);
      throw Exception('No se pudo encontrar musicPlaylistShelfRenderer en la respuesta.');
    }

    final Map<String, dynamic> playlistOutput = {
      'id': results['playlistId'] ?? playlistId
    };

    // Información del encabezado de la playlist
    final Map<String, dynamic>? header =
        _nav(responseData, ['header', "musicDetailHeaderRenderer"]) ??
            _nav(responseData,
                ['header', "musicEditablePlaylistDetailHeaderRenderer"]) ??
            _nav(responseData, [
              'contents',
              "twoColumnBrowseResultsRenderer",
              'tabs',
              0,
              "tabRenderer",
              "content",
              "sectionListRenderer",
              "contents",
              0,
              "musicResponsiveHeaderRenderer"
            ]);

    if (header != null) {
      playlistOutput['title'] = _nav(header, ['title', 'runs', 0, 'text']);
      playlistOutput['thumbnails'] = _nav(header,
          ['thumbnail', 'musicThumbnailRenderer', 'thumbnail', 'thumbnails']);
    }

    List<Map<String, dynamic>> tracks = [];
    if (results.containsKey('contents')) {
      tracks = _parsePlaylistItems(results['contents']);
    }

    // Manejo de continuaciones
    String? continuationToken =
        _getContinuationTokenFromContents(results['contents'] ?? []);

    while (continuationToken != null && tracks.length < limit) {
      final continuationData = Map<String, dynamic>.from(_context);
      continuationData['continuation'] = continuationToken;

      final continuationResponseData = (await _sendRequest(
              'browse', continuationData,
              additionalParams:
                  "&continuation=$continuationToken&ctoken=$continuationToken"))
          .data as Map<String, dynamic>;

      final List<dynamic>? continuationItems =
          _nav(continuationResponseData, _continuation_items_path);

      if (continuationItems == null || continuationItems.isEmpty) break;

      final newTracks = _parsePlaylistItems(continuationItems);
      if (newTracks.isEmpty) break;

      tracks.addAll(newTracks);
      continuationToken = _getContinuationTokenFromContents(continuationItems);
    }

    playlistOutput['tracks'] = tracks;
    return playlistOutput;
  }

  List<Map<String, dynamic>> _parsePlaylistItems(List<dynamic> results) {
    final songs = <Map<String, dynamic>>[];

    for (var result in results) {
      final musicItemRenderer = _nav(result, [mrlir], noneIfAbsent: true);
      if (musicItemRenderer == null) {
        continue;
      }
      dynamic data = musicItemRenderer;
      String? videoId = _nav(data, ['playlistItemData', 'videoId']);

      if (videoId == null) {
        // Intenta obtener videoId del botón de reproducción si no está en playlistItemData
        if (_nav(
                    data,
                    [
                      'overlay',
                      'musicItemThumbnailOverlayRenderer',
                      'content',
                      'musicPlayButtonRenderer'
                    ],
                    noneIfAbsent: true) !=
                null &&
            _nav(
                    data,
                    [
                      ...[
                        'overlay',
                        'musicItemThumbnailOverlayRenderer',
                        'content',
                        'musicPlayButtonRenderer',
                        'playNavigationEndpoint',
                        'watchEndpoint',
                        'videoId'
                      ]
                    ],
                    noneIfAbsent: true) !=
                null) {
          videoId = _nav(data, [
            ...[
              'overlay',
              'musicItemThumbnailOverlayRenderer',
              'content',
              'musicPlayButtonRenderer',
              'playNavigationEndpoint',
              'watchEndpoint',
              'videoId'
            ]
          ]);
        }
      }
      // Por ahora, si no se encuentra videoId, se omite.
      if (videoId == null) {
        continue;
      }

      String? title = _getItemText(data, 0);
      if (title == 'Song deleted') {
        continue;
      }

      List<Map<String, dynamic>>? artists = _parseSongArtistsNav(data, 1);

      String? duration;
      if (_nav(data, ['fixedColumns'], noneIfAbsent: true) != null) {
        final fixedItem = _getFixedColumnItem(data, 0);
        if (fixedItem.isNotEmpty) {
          duration = _nav(fixedItem, ['text', 'simpleText']) ??
              _nav(fixedItem, ['text', 'runs', 0, 'text']);
        }
      }

      final thumbs = _nav(data, thumbnails) ?? [];

      bool isAvailable = true;
      if (_nav(data, ['musicItemRendererDisplayPolicy'], noneIfAbsent: true) !=
          null) {
        isAvailable = data['musicItemRendererDisplayPolicy'] !=
            'MUSIC_ITEM_RENDERER_DISPLAY_POLICY_GREY_OUT';
      }

      if (isAvailable) {
        songs.add({
          'videoId': videoId,
          'title': title ?? 'Desconocido',
          'artists': artists ?? [],
          'length': duration ?? '0',
          'thumbnails': thumbs,
        });
      }
    }
    return songs;
  }

  Future<Response> _sendRequest(String action, Map<dynamic, dynamic> data,
      {String additionalParams = ''}) async {
    final url = '$baseUrl$action$fixedParams$additionalParams';
    try {
      final response = await dio.post(
        url,
        options: Options(headers: _headers),
        data: data,
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        printERROR(
            'Error en la solicitud: ${response.statusCode} - ${response.data}');
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Error en la solicitud: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      printERROR(
          'DioException al enviar solicitud a $url: ${e.response?.statusCode} - ${e.response?.data ?? e.message}');
      if (e.response?.data != null) {
        printERROR('DioException response data: ${e.response!.data}');
      }
      throw Exception(
          'Error en la solicitud: ${e.response?.data ?? e.message}');
    } catch (e) {
      printERROR('Error inesperado al enviar solicitud a $url: $e');
      rethrow;
    }
  }

  void _logJsonStructure(Map<String, dynamic> data,
      {int depth = 1, String prefix = ''}) {
    if (depth <= 0) {
      return;
    }
    data.forEach((key, value) {
      String typeString = value.runtimeType.toString();
      if (value == null) {
        typeString = "Null";
      }
      printINFO('$prefix$key: $typeString');

      if (value is Map<String, dynamic>) {
        _logJsonStructure(value, depth: depth - 1, prefix: '$prefix  ');
      } else if (value is List) {
        if (value.isNotEmpty) {
          String itemTypeString = value.first.runtimeType.toString();
          if (value.first == null) {
            itemTypeString = "Null";
          }
          printINFO('$prefix  List<$itemTypeString> (size: ${value.length})');
          if (value.first is Map<String, dynamic>) {
            printINFO(
                '$prefix  [0]: (Estructura del primer elemento de la lista)');
            _logJsonStructure(value.first as Map<String, dynamic>,
                depth: depth - 1, prefix: '$prefix    ');
          }
        } else {
          printINFO('$prefix  List<dynamic> (empty)');
        }
      }
    });
  }

  String _extractPlaylistId(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['list'] ?? '';
  }

  

}
