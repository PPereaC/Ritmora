// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/background_tasks.dart';
import '../../config/utils/pretty_print.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/playlist.dart';
import '../providers/playlist/playlist_provider.dart';
import '../providers/providers.dart';
import '../widgets/home/song_horizontal_listview_widget.dart';
import '../widgets/home/song_grid_horizontal_listview_widget.dart';

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
    printINFO(trendingSongs);
    final quickPicks = ref.watch(quickPicksProvider);
    final homePlaylists = ref.watch(homePlaylistsProvider);

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
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar simplificado
          SliverAppBar(
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            title: const Text(
              'INICIO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
                color: Colors.white,
                iconSize: 24,
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Contenido Principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Quick Picks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selecciones para ti',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Iconsax.arrow_right_3_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Quick Picks
                  SizedBox(
                    height: 230,
                    child: SongGridHorizontalListview(songs: quickPicks),
                  ),

                  const SizedBox(height: 16),

                  // Sección descubre nueva música
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.purple.withOpacity(0.3),
                          Colors.blue.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Descubre música',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                          ),
                          InkWell(
                            onTap: () {
                              ref.read(navbarIndexProvider.notifier).state = 1;
                              context.go('/search');
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Explorar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Trending
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tendencias',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Iconsax.arrow_right_3_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 200,
                    child: SongHorizontalListview(songs: trendingSongs),
                  ),

                  // Playlists con diseño de puzle
                  if (Responsive.isTabletOrDesktop(context))
                    ...homePlaylists.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Iconsax.arrow_right_3_outline,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: entry.value.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0 ? 0 : 16,
                                      right: index == entry.value.length - 1 ? 16 : 0,
                                    ),
                                    child: _PlaylistCard(
                                      playlist: entry.value[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ))
                  else
                    ...homePlaylists.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.key,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Iconsax.arrow_right_3_outline,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final size = constraints.maxWidth * 0.65;
                              return SizedBox(
                                height: size,
                                child: Row(
                                  children: [
                                    // Playlist grande a la izquierda
                                    SizedBox(
                                      width: size,
                                      height: size,
                                      child: GestureDetector(
                                        onTap: () => context.go(
                                          '/library/playlist/1/${entry.value[0].playlistId}',
                                          extra: entry.value[0],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            entry.value[0].thumbnailUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Columna derecha con dos playlists pequeñas
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => context.go(
                                                '/library/playlist/1/${entry.value[1].playlistId}',
                                                extra: entry.value[1],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  entry.value[1].thumbnailUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () => context.go(
                                                '/library/playlist/1/${entry.value[2].playlistId}',
                                                extra: entry.value[2],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  entry.value[2].thumbnailUrl,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      )),

                  // Espacio para el bottom player
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  final Playlist playlist;

  const _PlaylistCard({
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/library/playlist/1/${playlist.playlistId}', extra: playlist),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  playlist.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              playlist.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}