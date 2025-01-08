import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/song.dart';
import '../providers/song_player_provider.dart';
import '../widgets/widgets.dart';

class RootScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Responsive.isMobile(context);
    final playerService = ref.read(songPlayerProvider);
    final navbarHeight = isMobile ? kBottomNavigationBarHeight : 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [

          const GradientWidget(),

          Row(
            children: [
          
              if (!isMobile)
                // Sidebar
                const CustomMusicSidebar(),
          
          
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: kBottomNavigationBarHeight - 50,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: navigationShell,
                      ),
                  
                      StreamBuilder<Song?>(
                        stream: playerService.currentSongStream,
                        builder: (context, songSnapshot) {
                          final currentSong = songSnapshot.data;
                          
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: currentSong != null ? navbarHeight.toDouble() + 80 : 0,
                            child: currentSong == null 
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: EdgeInsets.only(bottom: navbarHeight.toDouble() + 15),
                                  child: StreamBuilder<bool>(
                                    stream: playerService.playingStream,
                                    builder: (context, playingSnapshot) {
                                      return PlayerControlWidget(
                                        currentSong: currentSong,
                                        playerService: playerService,
                                        isPlaying: playingSnapshot.data ?? false,
                                        onPlayPause: () => playerService.togglePlay(),
                                      );
                                    },
                                  ),
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]
      ),
      bottomNavigationBar: isMobile ? const Navbar() : null
    );
  }
}