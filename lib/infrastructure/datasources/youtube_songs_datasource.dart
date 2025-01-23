// ignore_for_file: unnecessary_null_comparison

import 'package:finmusic/config/utils/pretty_print.dart';
import 'package:finmusic/domain/datasources/songs_datasource.dart';
import 'package:finmusic/domain/entities/song.dart';
import 'package:finmusic/infrastructure/mappers/youtube_search_songs_response.dart';
import 'package:dio/dio.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/playlist.dart';

class YoutubeSongsDatasource extends SongsDatasource {

  CancelToken? _cancelToken;

  final dio = Dio(BaseOptions(
    baseUrl: 'https://music.youtube.com/youtubei/v1/',
    queryParameters: {
      'key': kPartIOS,
      'prettyPrint': 'false',
    },
  ));

  Future<Response> _sendRequest(String action, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(action, options: Options(headers: headers), data: body);
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
    printINFO('Sections: ${sections.length}');
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
    } else if (filter == 'trendings') {
      return 'EgZzcGFpbg%3D%3D'; // Para canciones en tendencia
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

  @override
  Future<List<Song>> getTrendingSongs() async {
    final body = getBody(2);
    body['browseId'] = 'FEmusic_charts';
    body['params'] = _getSearchParams('trendings');
    final response = await _sendRequest('browse', body);
    final songs = await _jsonToTrendingSongs(response.data);

    return songs;
  }

  Future<List<Song>> _jsonToTrendingSongs(Map<String, dynamic> json) async {
    List<Song> songs = [];
  
    try {
      // Navegamos hasta llegar a la lista de canciones
      final contents = json['contents']['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];
      for (var section in contents) {
        final items = section['musicCarouselShelfRenderer']?['contents'];
        if (items != null) {
          for (var item in items) {
            final songJson = item['musicTwoRowItemRenderer'];
            if (songJson != null) {
              final title = songJson['title']['runs'][0]['text'] ?? '';
              final artist = songJson['subtitle']['runs'][0]['text'] ?? '';
              final videoId = songJson['navigationEndpoint']['watchEndpoint']['videoId'] ?? '';
              final duration = songJson['lengthText']?['runs']?[0]?['text'] ?? '';
              final endUrl = '/watch?v=$videoId';
              final thumbnailUrl = _getHighQualityThumbnail(videoId);
  
              // Solo agregar si tenemos los datos mínimos necesarios
              if (title.isNotEmpty && artist.isNotEmpty && videoId.isNotEmpty) {
                songs.add(
                  Song(
                    title: title,
                    author: artist,
                    thumbnailUrl: thumbnailUrl,
                    streamUrl: '',
                    endUrl: endUrl,
                    songId: videoId,
                    duration: duration,
                    isVideo: 1
                  )
                );
              }
            }
          }
        }
      }
    } catch (e) {
      printERROR('Error extracting song data: $e');
    }
  
    return songs;
  }

  @override
  Future<List<Song>> getQuickPicks() async {
    final body = getBody(2);
    body['browseId'] = 'FEmusic_home';
    final response = await _sendRequest('browse', body);
    return await _jsonToQuickPicks(response.data);
  }

  Future<List<Song>> _jsonToQuickPicks(Map<String, dynamic> json) async {
    List<Song> quickPicks = [];

    try {
      final sections = json['contents']['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'];

      for (var section in sections) {
        if (section.containsKey('musicCarouselShelfRenderer')) {
          final headerTitle = section['musicCarouselShelfRenderer']['header']['musicCarouselShelfBasicHeaderRenderer']['title']['runs'][0]['text'].toLowerCase();
          if (headerTitle.contains('selecciones') && headerTitle.contains('rápidas')) { // Asegúrate de ajustar según el idioma y la exactitud del texto
            final items = section['musicCarouselShelfRenderer']['contents'];

            for (var item in items) {
              if (item.containsKey('musicResponsiveListItemRenderer')) {
                final songJson = item['musicResponsiveListItemRenderer'];
                final title = songJson['flexColumns'][0]['musicResponsiveListItemFlexColumnRenderer']['text']['runs'][0]['text'];
                final artist = songJson['flexColumns'][1]['musicResponsiveListItemFlexColumnRenderer']['text']['runs'][0]['text'];
                final videoId = songJson['overlay']['musicItemThumbnailOverlayRenderer']['content']['musicPlayButtonRenderer']['playNavigationEndpoint']['watchEndpoint']['videoId'];

                final thumbnailUrl = _getHighQualityThumbnail(videoId);

                quickPicks.add(Song(
                  title: title,
                  author: artist,
                  thumbnailUrl: thumbnailUrl,
                  streamUrl: '',
                  endUrl: '/watch?v=$videoId',
                  songId: videoId,
                  duration: ''
                ));
              }
            }
            break;
          }
        }
      }
    } catch (e) {
      printERROR('Error extracting Quick Picks songs: $e');
    }

    return quickPicks;
  }

  @override
  Future<Map<String, List<Playlist>>> getHomePlaylists() async {
    final body = getBody(2);
    body['browseId'] = 'FEmusic_home';
    final response = await _sendRequest('browse', body);
    return await _jsonToPlaylistsHits(response.data);
  }

  Future<Map<String, List<Playlist>>> _jsonToPlaylistsHits(Map<String, dynamic> json) async {
    Map<String, List<Playlist>> playlistsByCategory = {};
    
    try {
      final List sections = json.containsKey('musicCarouselShelfRenderer')
          ? [json['musicCarouselShelfRenderer']]
          : json['contents']?['singleColumnBrowseResultsRenderer']?['tabs']?[0]
                  ?['tabRenderer']?['content']?['sectionListRenderer']?['contents'] ??
              [];

      for (var section in sections) {
        if (!section.containsKey('musicCarouselShelfRenderer')) continue;

        final header = section['musicCarouselShelfRenderer']?['header']?['musicCarouselShelfBasicHeaderRenderer'];
        
        String? category;
        if (header != null && header['title'] != null && header['title']['runs'] != null && header['title']['runs'].isNotEmpty) {
          category = header['title']['runs'][0]['text'];
        } else {
          category = 'Sin Categoría';
        }

        // Ignorar la sección de 'Selecciones rápidas'
        if (category?.toLowerCase().contains('selecciones') == true && category?.toLowerCase().contains('rápidas') == true) {
          continue;
        }

        if (!playlistsByCategory.containsKey(category)) {
          playlistsByCategory[category!] = [];
        }

        final items = section['musicCarouselShelfRenderer']?['contents'] ?? [];
        
        for (var item in items) {
          try {
            if (!item.containsKey('musicTwoRowItemRenderer')) continue;
    
            final playlistJson = item['musicTwoRowItemRenderer'];
            final title = playlistJson['title']?['runs']?[0]?['text'];
            final playlistId = playlistJson['navigationEndpoint']?['browseEndpoint']?['browseId'];
            final thumbnails = playlistJson['thumbnailRenderer']?['musicThumbnailRenderer']
              ?['thumbnail']?['thumbnails'] as List?;
            
            // Descartar playlist si no hay miniaturas
            if (thumbnails == null || thumbnails.isEmpty) {
              continue;
            }

            final thumbnailsList = thumbnails
                .map((t) => {
                  'url': t['url'],
                  'area': (t['height'] ?? 0) * (t['width'] ?? 0),
                })
                .toList();
            
            thumbnailsList.sort((a, b) => b['area'].compareTo(a['area']));
            
            final thumbnailUrl = thumbnailsList.first['url'];
            String? author;
            if (playlistJson['subtitle']?['runs'] != null && playlistJson['subtitle']['runs'].length > 1) {
              author = playlistJson['subtitle']['runs'][0]['text'];
            } else {
              author = ''; // Si no se puede obtener el autor, usa un valor por defecto
            }

            if (title != null && playlistId != null && thumbnailUrl != null && author != null) {
              playlistsByCategory[category]!.add(
                Playlist(
                  playlistId: playlistId,
                  title: title,
                  author: author,
                  thumbnailUrl: thumbnailUrl,
                )
              );
            } else {
              printINFO('Playlist descartada - datos incompletos: $title');
            }
          } catch (itemError) {
            printERROR('Error procesando item: $itemError');
            continue;
          }
        }
      }
    } catch (e, stackTrace) {
      printERROR('Error extracting Greatest Hits playlists: $e');
      printERROR('Stack trace: $stackTrace');
    }

    return playlistsByCategory;
  }
  
  @override
  Future<Playlist> getPlaylistWSongs(String playlistID) async {
    // final body = getBody(2);
    // body['browseId'] = playlistID;
    // final response = await _sendRequest('browse', body);
    // final playlistSongs = _jsonToPlaylistWSongs(response.data);
    // final playlist = Playlist(title: 'Prueba', author: '', thumbnailUrl: '', playlistId: playlistID);
    // playlist.songs = await playlistSongs;
    final playlist = Playlist(title: '', author: '', thumbnailUrl: '', playlistId: '');
    return playlist;
  }

  Future<List<Song>> _jsonToPlaylistWSongs(Map<String, dynamic> json) async {
    List<Song> songs = [];

    try {
      // Navegamos hasta la estructura de la playlist
      final contents = json['contents']['twoColumnBrowseResultsRenderer']['secondaryContents']['sectionListRenderer']['contents'][0]['musicPlaylistShelfRenderer']['contents'];
      for (var item in contents) {
        if (item.containsKey('musicResponsiveListItemRenderer')) {
          final songJson = item['musicResponsiveListItemRenderer'];
          final title = songJson['flexColumns'][0]['musicResponsiveListItemFlexColumnRenderer']['text']['runs'][0]['text'];
          final artist = songJson['flexColumns'][1]['musicResponsiveListItemFlexColumnRenderer']['text']['runs'][0]['text'];
          final videoId = songJson['overlay']['musicItemThumbnailOverlayRenderer']['content']['musicPlayButtonRenderer']['playNavigationEndpoint']['watchEndpoint']['videoId'];
          final duration = songJson['fixedColumns'][0]['musicResponsiveListItemFixedColumnRenderer']['text']['runs'][0]['text'];

          songs.add(
            Song(
              title: title,
              author: artist,
              thumbnailUrl: _getHighQualityThumbnail(videoId),
              streamUrl: '',
              endUrl: '/watch?v=$videoId',
              songId: videoId,
              duration: duration,
            )
          );
        }
      }
    } catch (e) {
      printERROR('Error extracting songs from playlist: $e');
    }

    return songs;
  }
  
}