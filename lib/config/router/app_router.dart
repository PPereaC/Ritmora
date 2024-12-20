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

        // Librería
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryView(),
              routes: [
                GoRoute(
                  path: '/playlist/:id',
                  builder: (context, state) {
                    // Obtenemos el ID de la playlist a través de la ruta
                    final playlistID = state.pathParameters['id'] ?? 'no-id';
                    return PlaylistScreen(playlistID: playlistID);
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
      builder: (context, state) => const FullPlayerScreen(),
    ),

    // Queue Screen
    GoRoute(
      path: '/queue',
      builder: (context, state) => const QueueScreen(),
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