import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradiente
          Positioned(
            left: -50,
            top: -50,
            child: Container(
              height: size.height * 0.8,
              width: size.width * 1.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    colors.primary.withOpacity(0.7),
                    colors.primary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.9],
                ),
              ),
            ),
          ),

          // Contenido principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botones de acción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      // Botón de posición
                      FloatingActionButton.small(
                        heroTag: 'position',
                        onPressed: () {
                          // TODO: Implementar cambiar posición
                        },
                        backgroundColor: colors.secondary,
                        elevation: 4,
                        child: const Icon(
                          Icons.arrow_downward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                
                      // Botón de reproducción aleatoria
                      FloatingActionButton.small(
                        heroTag: 'shuffle',
                        onPressed: () {
                          // TODO: Implementar escuchar aleatoriamente
                        },
                        backgroundColor: colors.secondary,
                        elevation: 4,
                        child: const Icon(
                          Iconsax.shuffle_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                
                      // Botón de búsqueda
                      FloatingActionButton.small(
                        heroTag: 'search',
                        onPressed: () {
                          // TODO: Implementar búsqueda
                        },
                        backgroundColor: colors.secondary,
                        elevation: 4,
                        child: const Icon(
                          Iconsax.search_normal_1_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                // TODO: Implementar lista de canciones favoritas
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButtons extends StatelessWidget {

  final List<Widget> children;

  const _IconButtons({
    required this.colors,
    required this.children
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: children,
      ),
    );
  }
}