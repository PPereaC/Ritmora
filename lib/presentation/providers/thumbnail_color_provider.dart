import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

final thumbnailColorProvider = StateProvider<Color>((ref) => Colors.grey[900]!);

// Función para extraer color
Future<Color> extractDominantColor(String imageUrl) async {
  try {
    final imageProvider = NetworkImage(imageUrl);
    
    final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      size: const Size(200, 200),
      timeout: const Duration(seconds: 2),
    ).timeout(
      const Duration(seconds: 2),
      onTimeout: () => throw TimeoutException('Error al cargar la imagen'),
    );
    
    return paletteGenerator.dominantColor?.color ?? Colors.grey[900]!;
    
  } catch (e) {
    return Colors.blue; // Color por defecto
  }
}