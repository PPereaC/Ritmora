import 'package:ritmora/config/utils/background_tasks.dart';
import 'package:ritmora/presentation/widgets/home/song_horizontal_listview_widget.dart';
import 'package:ritmora/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:marquee/marquee.dart';

import '../../config/utils/responsive.dart';
import '../providers/playlist/playlist_provider.dart';
import '../providers/providers.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    
    // Cargar datos iniciales
    ref.read(trendingSongsProvider.notifier).loadSongs();
    ref.read(quickPicksProvider.notifier).loadSongs();
    ref.read(homePlaylistsProvider.notifier).loadSongs();

  }

  @override
  Widget build(BuildContext context) {
    // Estados de las diferentes listas
    final trendingSongs = ref.watch(trendingSongsProvider);
    final quickPicks = ref.watch(quickPicksProvider);
    final homePlaylists = ref.watch(homePlaylistsProvider);

    bool isDesktop = Responsive.isTabletOrDesktop(context);

    final playlistState = ref.watch(playlistProvider);

    // Playlists are now directly available
    final playlistLocales = playlistState.playlists;
    final youtubePlaylists = playlistState.youtubePlaylists;

    // Update expired stream URLs
    updateExpiredStreamUrls(
      ref,
      playlistLocales,
      youtubePlaylists,
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 10,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
          
              !isDesktop
                ? SliverAppBar(
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'FinMusic',
                                style: TextStyle(
                                  fontFamily: 'Titulo',
                                  color: Colors.white,
                                  fontSize: 30
                                ),
                              )
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Iconsax.notification_outline,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Iconsax.repeate_music_outline,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Iconsax.setting_2_outline,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                : const SliverAppBar(toolbarHeight: 10),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionTitle('Selecciones rápidas', showViewAll: false),
                          const SizedBox(height: 15),
                          SongGridHorizontalListview(songs: quickPicks),
                          
                          const _SectionTitle('En tendencia'),
                          const SizedBox(height: 15),
                          SongHorizontalListview(songs: trendingSongs),
                          
                          // Iteramos sobre cada categoría de playlists
                          ...homePlaylists.entries.map((entry) => [
                            _SectionTitle(entry.key, showViewAll: false),
                            const SizedBox(height: 15),
                            PlaylistHorizontalListview(
                              onTap: (playlist) {
                                
                                context.go(
                                  '/library/playlist/1/${playlist.playlistId}',
                                  extra: playlist
                                );
                              },
                              playlists: entry.value
                            ),
                            const SizedBox(height: 20), // Espaciado entre secciones
                          ]).expand((widgets) => widgets),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 70,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

// _SectionTitle class remains unchanged
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool showViewAll;
  
  const _SectionTitle(
    this.title, {
    this.showViewAll = true
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: BoxConstraints(maxWidth: screenWidth),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth * 0.8,
            child: title.length > 30
                ? SizedBox(
                    height: textStyle.titleLarge?.fontSize != null
                        ? textStyle.titleLarge!.fontSize! * 1.5
                        : 24.0,
                    child: Marquee(
                      text: title,
                      style: textStyle.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      scrollAxis: Axis.horizontal,
                      blankSpace: 10.0,
                      velocity: 30.0,
                      pauseAfterRound: const Duration(seconds: 3),
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 500),
                      decelerationCurve: Curves.easeOut,
                    ),
                  )
                : Text(
                    title,
                    style: textStyle.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
          ),
        ],
      ),
    );
  }
}