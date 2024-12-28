// ignore_for_file: unused_element

import 'package:apolo/presentation/widgets/home/song_horizontal_listview_widget.dart';
import 'package:apolo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../domain/entities/song.dart';
import '../delegates/search_songs_delegate.dart';
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
    ref.read(playlistsHitsProvider.notifier).loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Estados de las diferentes listas
    final trendingSongs = ref.watch(trendingSongsProvider);
    final quickPicks = ref.watch(quickPicksProvider);
    final playlistsHits = ref.watch(playlistsHitsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const GradientWidget(),
          
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        IconButton.filled(
                          onPressed: () async {
                            final searchQuery = ref.read(searchQueryProvider);
                            // ignore: unused_local_variable
                            final song = await showSearch<Song?>(
                              query: searchQuery,
                              context: context,
                              delegate: SearchSongsDelegate(
                                searchSongs: ref.read(searchSongsProvider.notifier).searchSongsByQuery,
                                colors: colors,
                              )
                            );
                          },
                          icon: const Icon(Iconsax.search_normal_1_outline),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: colors.secondary.withOpacity(0.5),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                        const SizedBox(width: 3),
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Iconsax.notification_outline),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: colors.secondary.withOpacity(0.5),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
    
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _SectionTitle('Selecciones rápidas', showViewAll: false),
                          const SizedBox(height: 10),
                          SongGridHorizontalListview(songs: quickPicks),
    
                          const _SectionTitle('En tendencia'),
                          const SizedBox(height: 10),
                          SongHorizontalListview(songs: trendingSongs),
    
                          const _SectionTitle('Grandes Éxitos', showViewAll: false),
                          const SizedBox(height: 10),
                          PlaylistHorizontalListview (
                            onTap: (playlist) {
                              context.go(
                                '/library/playlist/1/${playlist.playlistId}',
                                extra: playlist
                              );
                            },
                            playlists: playlistsHits
                          )
                        ],
                      ),
                    );
                  },
                  childCount: 1
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (showViewAll)
            InkWell(
              onTap: () {
                // TODO: Implementar navegación
              },
              child: Row(
                children: [
                  Text(
                    'Ver todo',
                    style: textStyle.bodyLarge?.copyWith(
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: Colors.white
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}