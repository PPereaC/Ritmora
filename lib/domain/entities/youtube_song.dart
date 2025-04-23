class YoutubeSong {

  final String songId;
  final String playlistId;
  final String title;
  final String author;
  final String thumbnailUrl;
  String streamUrl;
  final String endUrl;
  final int isLiked;
  final String duration;
  final String videoId;
  final int isVideo;

  Duration get durationParsed {
    final parts = duration.split(':');
    if (parts.length != 2) return const Duration();
    
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    
    return Duration(minutes: minutes, seconds: seconds);
  }

  YoutubeSong({
    required this.songId,
    required this.playlistId,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.streamUrl,
    required this.endUrl,
    this.isLiked = 0,
    required this.duration,
    this.videoId = '',
    this.isVideo = 0,
  });
}