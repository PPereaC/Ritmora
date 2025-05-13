// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class TidalStyleBackground extends ConsumerWidget {
  final String? imageUrl;
  
  const TidalStyleBackground({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final colorProvider = ref.watch(songColorProvider);
    
    return Stack(
      children: [
        // Fondo negro base
        Container(
          width: size.width,
          height: size.height,
          color: Colors.black,
        ),
        
        // Imagen de carátula muy difuminada como fondo
        if (imageUrl != null)
          Positioned.fill(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Opacity(
                  opacity: 0.4,
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        
        // Capa de oscurecimiento para mejorar contraste
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        
        // Efecto de degradado superior con el color dominante de la carátula
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: size.height * 0.5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorProvider.withOpacity(0.4),
                  colorProvider.withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),
        
        // Efecto de viñeta para oscurecer los bordes
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
