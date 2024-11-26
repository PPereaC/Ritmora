import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/song.dart';
import '../../infrastructure/services/song_player_service.dart';
import '../providers/song_player_provider.dart';
import '../widgets/widgets.dart';

class RootScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final SongPlayerService playerService = ref.read(songPlayerProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: navigationShell,
          ),
          StreamBuilder<Song?>(
            stream: playerService.currentSongStream,
            builder: (context, songSnapshot) {
              final currentSong = songSnapshot.data;
              if (currentSong == null) {
                return const SizedBox.shrink();
              }
              return StreamBuilder<bool>(
                stream: playerService.playingStream,
                builder: (context, playingSnapshot) {
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