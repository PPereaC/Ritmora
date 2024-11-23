import 'package:isar/isar.dart';

import 'playlist.dart';
part 'song.g.dart';

@collection
class Song {

  Id id = Isar.autoIncrement;

  final String title;
  final String author;
  final String thumbnailUrl;
  String streamUrl;
  final String endUrl;
  final String songId;
  final bool isLiked;
  final String duration;

  @ignore
  Duration get durationParsed {
    final parts = duration.split(':');
    if (parts.length != 2) return const Duration();
    
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    
    return Duration(minutes: minutes, seconds: seconds);
  }

  final playlist = IsarLink<Playlist>();

  Song({
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.streamUrl,
    required this.endUrl,
    required this.songId,
    this.isLiked = false,
    required this.duration
  });
}