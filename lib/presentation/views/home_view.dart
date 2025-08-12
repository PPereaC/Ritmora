// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/utils/background_tasks.dart';
import '../../config/utils/pretty_print.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/playlist.dart';
import '../providers/playlist/playlist_provider.dart';
import '../providers/providers.dart';
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

    final screenWidth = MediaQuery.of(context).size.width;

    // Update expired stream URLs
    updateExpiredStreamUrls(
      ref,
      playlistLocales,
      youtubePlaylists,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar simplificado
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.black,
            elevation: 0,
            titleSpacing: 16,
            title: const Text(
              'Ritmora',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {},
                color: Colors.white,
                iconSize: 22,
              ),
              const SizedBox(width: 8),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 0.5,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // Contenido Principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Picks
                  Text(
                    'Selecciones para ti',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: 0.3,
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Quick Picks
                  SizedBox(
                    height: 230,
                    child: SongGridHorizontalListview(songs: quickPicks),
                  ),

                  const SizedBox(height: 16),

                  // Sección descubre nueva música (estilo glass + gradiente)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Container(
                          height: 72,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF1B2A4A),
                                Color(0xFF281B4A),
                              ],
                            ),
                          ),
                        ),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.explore,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Descubre música',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                        ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  ref.read(navbarIndexProvider.notifier).state =
                                      1;
                                  context.go('/search');
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  backgroundColor:
                                      Colors.white.withOpacity(0.08),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                ),
                                child: const Text('Explorar'),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Trending
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       'Tendencias',
                  //       style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.w700,
                  //             fontSize: 22,
                  //             letterSpacing: 0.3,
                  //           ),
                  //     ),
                  //     TextButton.icon(
                  //       onPressed: () {},
                  //       icon: const Icon(Iconsax.arrow_right_3_outline,
                  //           color: Colors.white70, size: 18),
                  //       label: const Text('Ver todo',
                  //           style: TextStyle(color: Colors.white70)),
                  //       style: TextButton.styleFrom(
                  //         foregroundColor: Colors.white70,
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 12, vertical: 8),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20)),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 16),

                  // SizedBox(
                  //   height: 200,
                  //   child: SongHorizontalListview(songs: trendingSongs),
                  // ),

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
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        letterSpacing: 0.3,
                                      ),
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
                                      right: index == entry.value.length - 1
                                          ? 16
                                          : 0,
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
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: SizedBox(
                                    width: screenWidth * 0.9,
                                    child: Text(
                                      entry.key,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                          ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
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
                                            borderRadius:
                                                BorderRadius.circular(14),
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
                                                      BorderRadius.circular(14),
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
                                                      BorderRadius.circular(14),
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
      onTap: () => context.go('/library/playlist/1/${playlist.playlistId}',
          extra: playlist),
      child: SizedBox(
        width: 156,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  playlist.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
                // Gradiente inferior para legibilidad del título
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.55),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Text(
                    playlist.title,
                    softWrap: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      height: 1.2,
                      shadows: [
                        Shadow(
                            blurRadius: 6,
                            color: Colors.black54,
                            offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
