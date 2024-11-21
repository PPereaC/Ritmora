import '../../domain/entities/song.dart';
import '../models/piped_search_songs_response.dart';

class PipedSearchSongsMapper {

  static String? extractVideoId(String url) {
    final regex = RegExp(r'v=([^&]+)');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  static Song itemToEntity(Item item) => Song(
    title: item.title,
    author: item.uploaderName,
    thumbnailUrl: item.thumbnail,
    streamUrl: "",
    endUrl: item.url,
    songId: extractVideoId(item.url)!,
    duration: item.duration.toString()
  );

}