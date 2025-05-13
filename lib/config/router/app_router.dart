import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/playlist.dart';
import '../../presentation/screens/screens.dart';
import '../../presentation/views/views.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => RootScreen(navigationShell: navigationShell),
      branches: [

        // Inicio
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeView(),
            )
          ]
        ),

        // Canciones favoritas
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesView(),
            )
          ]
        ),

        // Búsqueda
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchView(),
            ),
          ],
        ),

        // Librería
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryView(),
              routes: [
                GoRoute(
                  path: '/playlist/:local/:id',
                  builder: (context, state) {
                    // Obtenemos el ID de la playlist a través de la ruta
                    final playlistID = state.pathParameters['id'] ?? 'no-id';
                    final isLocalPlaylist = state.pathParameters['local'] ?? 'no-local';
                    final playlist = state.extra as Playlist;
                    return PlaylistScreen (
                      playlistID: playlistID,
                      isLocalPlaylist: isLocalPlaylist,
                      playlist: playlist
                    );
                  },
                )
              ]
            )
          ]
        ),

      ],
    ),

    // Full Player Screen
    GoRoute(
      path: '/full-player',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const FullPlayerScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
        );
      },
    ),

    // Select Playlist Screen
    GoRoute(
      path: '/select-playlist',
      builder: (context, state) => SelectPlaylistScreen(
        playlists: state.extra as List<Playlist>,
      ),
    ),

  ]
);