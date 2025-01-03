import 'package:apolo/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/song_player_provider.dart';

class CustomSnackbar {
  static void show(
    BuildContext context,
    String message,
    Color backgroundColor,
    IconData icon, {
    int duration = 2,
    double margin = 0,
  }) {
    // Obtener el ProviderScope para acceder a ref
    final ref = ProviderScope.containerOf(context);
    
    // Obtener el estado de reproducción
    final currentSong = ref.read(songPlayerProvider).currentSong == null;
    
    // Ajustar bottomMargin según si está reproduciendo
    final bottomMargin = currentSong ? 0.0 : 70.0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              )
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: duration),
        margin: EdgeInsets.only(
          bottom: bottomMargin, 
          left: margin, 
          right: margin
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}