import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/song.dart';

class SongsSlideshow extends StatelessWidget {
  final List<Song> songs;

  const SongsSlideshow({
    Key? key,
    required this.songs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.9,
        scale: 0.95,
        autoplay: true,
        itemCount: songs.length,
        pagination: null, // Eliminamos la paginación
        itemBuilder: (context, index) => _Slide(song: songs[index]),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Song song;

  const _Slide({required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Miniatura del video
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Image.network(
            song.thumbnailUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 180, // Ajustamos la altura de la imagen
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                );
              }
              return FadeIn(child: child);
            },
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[900],
              child: Image.asset(
                defaultPoster,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180, // Ajustamos la altura de la imagen
              ),
            ),
          ),
        ),
        // Título del video en una línea con fondo de color
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Text(
            song.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}