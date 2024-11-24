import '../../domain/entities/song.dart';
import '../models/piped_search_songs_response.dart';

class PipedSearchSongsMapper {

  static String? extractVideoId(String url) {
    final regex = RegExp(r'v=([^&]+)');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  static String getHighQualityThumbnail(String videoId) {
    // Intentar obtener la máxima calidad, con fallbacks
    return 'https://i.ytimg.com/vi/$videoId/maxresdefault.jpg';
  }

  static Song itemToEntity(Item item, {String? youtubeThumbnail}) {
    final videoId = extractVideoId(item.url);
    final highQualityThumbnail = videoId != null 
        ? getHighQualityThumbnail(videoId)
        : item.thumbnail;

    return Song(
      title: item.title,
      author: item.uploaderName,
      thumbnailUrl: highQualityThumbnail,
      streamUrl: "",
      endUrl: item.url,
      songId: videoId!,
      duration: item.duration.toString()
    );
  }

}