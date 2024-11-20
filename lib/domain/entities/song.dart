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