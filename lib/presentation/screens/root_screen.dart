import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/song.dart';
import '../providers/song_player_provider.dart';
import '../widgets/widgets.dart';

class RootScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({super.key, required this.navigationShell});

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends ConsumerState<RootScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isQueuePanelVisible = false;

  void _toggleQueuePanel() {
    setState(() {
      _isQueuePanelVisible = !_isQueuePanelVisible;
    });
  }

  void _hideQueuePanel() {
    setState(() {
      _isQueuePanelVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final playerService = ref.read(songPlayerProvider);
    final navbarHeight = isMobile ? kBottomNavigationBarHeight : 0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Row(
        children: [
          if (!isMobile)
            StreamBuilder<Song?>(
              stream: playerService.currentSongStream,
              builder: (context, snapshot) {
                final hasCurrentSong = snapshot.data != null;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: hasCurrentSong ? 88 : 0
                  ),
                  child: const CustomMusicSidebar(),
                );
              },
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<Song?>(
                    stream: playerService.currentSongStream,
                    builder: (context, songSnapshot) {
                      final currentSong = songSnapshot.data;
                      final bottomPadding = currentSong != null 
                        ? (Responsive.isMobile(context) ? navbarHeight.toDouble() + 20 : 80) 
                        : 0.0;
                
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: bottomPadding.toDouble(),
                        ),
                        child: widget.navigationShell,
                      );
                    },
                  ),
                ),
                StreamBuilder<Song?>(
                  stream: playerService.currentSongStream,
                  builder: (context, songSnapshot) {
                    final currentSong = songSnapshot.data;
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: currentSong != null 
                        ? (Responsive.isMobile(context) ? navbarHeight.toDouble() + 80 : 80) 
                        : 0,
                      padding: EdgeInsets.only(
                        bottom: Responsive.isMobile(context) ? navbarHeight.toDouble() + 20 : 0,
                      ),
                      child: currentSong != null 
                        ? StreamBuilder<bool>(
                            stream: playerService.playingStream,
                            builder: (context, playingSnapshot) {
                              return PlayerControlWidget(
                                currentSong: currentSong,
                                playerService: playerService,
                                isPlaying: playingSnapshot.data ?? false,
                                onPlayPause: () => playerService.togglePlay(),
                                onQueueButtonPressed: _toggleQueuePanel,
                                onNextSong: () => playerService.playNext(),
                                onPreviousSong: () => playerService.playPrevious(),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),
          if (_isQueuePanelVisible)
            QueueSlidePanel(onClose: _hideQueuePanel)
        ],
      ),
      bottomNavigationBar: isMobile ? const Navbar() : null,
    );
  }
}