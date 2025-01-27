import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../config/utils/pretty_print.dart';

class YoutubeService {
  static final YoutubeService _instance = YoutubeService._internal();
  final YoutubeExplode yt = YoutubeExplode();
  final Map<String, CachedUrl> _cache = {};
  
  factory YoutubeService() => _instance;
  YoutubeService._internal();

  Future<String?> getCachedStreamUrl(String videoId) async {
    // Verificar caché primero
    if (_cache.containsKey(videoId) && _cache[videoId]!.isValid) {
      printINFO('✅ URL encontrada en caché');
      return _cache[videoId]!.url;
    }

    // Timeout de 5 segundos
    try {
      final manifest = await yt.videos.streamsClient
          .getManifest(videoId)
          .timeout(const Duration(seconds: 5));
          
      final url = manifest.audioOnly.withHighestBitrate().url.toString();
          
      _cache[videoId] = CachedUrl(url);
      return url;
    } catch (e) {
      printERROR('Error: $e');
      return null;
    }
  }
}

class CachedUrl {
  final String url;
  final DateTime expiresAt;

  CachedUrl(this.url) : expiresAt = DateTime.now().add(const Duration(hours: 1));

  bool get isValid => DateTime.now().isBefore(expiresAt);
}