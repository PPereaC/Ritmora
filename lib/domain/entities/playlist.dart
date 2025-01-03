class Playlist {

  final String title;
  final String author;
  String thumbnailUrl;
  String playlistId;
  final int isLocal;

  Playlist({
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    this.playlistId = '',
    this.isLocal = 0
  });

}