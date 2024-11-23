import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/utils/responsive.dart';
import '../../domain/entities/song.dart';
import '../../infrastructure/services/song_player_service.dart';
import '../providers/song_player_provider.dart';
import '../widgets/widget.dart';

class RootScreen extends ConsumerWidget {

  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isMobile = Responsive.isMobile(context);
    // ignore: unused_local_variable
    final isDesktop = Responsive.isDesktop(context);
    final SongPlayerService playerService = ref.read(songPlayerProvider);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Contenido principal
          navigationShell,
      
          // PlayerControl con StreamBuilders
          StreamBuilder<Song?>(
            stream: playerService.currentSongStream,
            builder: (context, songSnapshot) {
              return StreamBuilder<bool>(
                stream: playerService.playingStream,
                builder: (context, playingSnapshot) {
                  final currentSong = songSnapshot.data;
                  if (currentSong == null) return const SizedBox.shrink();
      
                  return PlayerControlWidget(
                    currentSong: currentSong,
                    playerService: playerService,
                    isPlaying: playingSnapshot.data ?? false,
                    onPlayPause: () => playerService.togglePlay(),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: isMobile ? const Navbar() : const SizedBox(),
    );
  }
}