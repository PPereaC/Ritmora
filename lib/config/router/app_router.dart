import 'package:go_router/go_router.dart';

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

        // Buscar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchView(),
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
    )

  ]
);