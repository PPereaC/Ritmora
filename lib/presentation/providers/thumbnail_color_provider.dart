import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

final thumbnailColorProvider = StateProvider<Color>((ref) => Colors.grey[900]!);

// Función para extraer color
Future<Color> extractDominantColor(String imageUrl) async {
  final ImageProvider imageProvider = NetworkImage(imageUrl);
  final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(
    imageProvider,
    size: const Size(200, 200), // Tamaño reducido para mejor rendimiento
  );
  
  return paletteGenerator.dominantColor?.color ?? Colors.grey[900]!;
}