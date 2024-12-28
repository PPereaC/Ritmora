import 'package:apolo/domain/entities/song.dart';
import 'package:isar/isar.dart';
part 'playlist.g.dart';

@collection
class Playlist {

  Id id = Isar.autoIncrement;

  final String title;
  final String author;
  String thumbnailUrl;
  String playlistId;
  final bool isLocal;

  @Ignore()
  List<Song> songs = [];

  // Para almacenar la relación en Isar
  @Backlink(to: 'playlist')
  final songLinks = IsarLinks<Song>();

  Playlist({
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    this.playlistId = '',
    this.isLocal = true
  });
}