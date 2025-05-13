// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ModernPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isFavorite;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onShuffle;
  final VoidCallback onToggleFavorite;
  final Color primaryColor;
  final Color secondaryColor;

  const ModernPlayerControls({
    super.key,
    required this.isPlaying,
    required this.isFavorite,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onShuffle,
    required this.onToggleFavorite,
    this.primaryColor = Colors.white,
    this.secondaryColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Botón de reproducción aleatoria
                  IconButton(
                    icon: Icon(
                      Iconsax.shuffle_outline,
                      color: secondaryColor,
                    ),
                    iconSize: 24,
                    onPressed: onShuffle,
                  ),
                  
                  // Botón anterior
                  IconButton(
                    icon: Icon(
                      Iconsax.previous_bold,
                      color: primaryColor,
                    ),
                    iconSize: 32,
                    onPressed: onPrevious,
                  ),
                  
                  // Botón reproducir/pausar
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onPlayPause,
                        child: Center(
                          child: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Botón siguiente
                  IconButton(
                    icon: Icon(
                      Iconsax.next_bold,
                      color: primaryColor,
                    ),
                    iconSize: 32,
                    onPressed: onNext,
                  ),
                  
                  // Botón de favorito
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : primaryColor,
                    ),
                    iconSize: 28,
                    onPressed: onToggleFavorite,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
