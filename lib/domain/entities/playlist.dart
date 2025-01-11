class Playlist {

  final int id;
  final String title;
  final String author;
  String thumbnailUrl;
  String playlistId;
  final int isLocal;

  Playlist({
    int? id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    this.playlistId = '',
    this.isLocal = 0
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

}