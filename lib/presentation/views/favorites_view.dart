import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../widgets/widgets.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Gradiente
          const GradientWidget(),

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