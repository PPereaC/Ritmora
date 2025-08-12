// ignore_for_file: deprecated_member_use

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

  void _hideQueuePanel() {
    setState(() {
      _isQueuePanelVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final playerService = ref.watch(songPlayerProvider);
    final navbarHeight = isMobile ? kBottomNavigationBarHeight : 0;
    final playerHeight = isMobile ? 75.0 : 70.0;

    final isDesktop = Responsive.isTabletOrDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          // Contenido principal
          Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (!isMobile)
                      StreamBuilder<Song?>(
                        stream: playerService.currentSongStream,
                        builder: (context, snapshot) {
                          final hasCurrentSong = snapshot.data != null;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: hasCurrentSong ? playerHeight : 0,
                            ),
                            child: const CustomMusicSidebar(),
                          );
                        },
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: playerService.currentSong != null
                                ? playerHeight + (isMobile ? navbarHeight : 0)
                                : 0),
                        child: widget.navigationShell,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Player Control en la parte inferior
          Positioned(
            left: 0,
            right: 0,
            bottom: isMobile ? navbarHeight.toDouble() : 0,
            child: StreamBuilder<Song?>(
              stream: playerService.currentSongStream,
              builder: (context, songSnapshot) {
                final currentSong = songSnapshot.data;
                if (currentSong == null) return const SizedBox.shrink();

                return Padding(
                  padding: EdgeInsets.only(bottom: isDesktop ? 0 : 30),
                  child: SizedBox(
                    height: playerHeight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: isMobile ? (navbarHeight > 0 ? 8 : 0) : 0,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 8,
                        borderRadius: BorderRadius.circular(14),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            height: playerHeight,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.92),
                              border: const Border(
                                top: BorderSide(
                                    color: Colors.white24, width: 0.5),
                              ),
                            ),
                            child: PlayerControlWidget(
                              currentSong: currentSong,
                              playerService: playerService,
                              isPlaying: playerService.isPlaying,
                              onPlayPause: () => playerService.togglePlay(),
                              onQueueButtonPressed: () => setState(() {
                                _isQueuePanelVisible = true;
                              }),
                              onNextSong: () => playerService.playNext(),
                              onPreviousSong: () =>
                                  playerService.playPrevious(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Queue Panel como overlay
          if (_isQueuePanelVisible && !isMobile)
            Positioned.fill(
              child: QueueSlidePanel(
                onClose: _hideQueuePanel,
              ),
            ),
        ],
      ),
      bottomNavigationBar: isMobile ? const Navbar() : null,
    );
  }
}
