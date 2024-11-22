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
              routes: const [
                // GoRoute(
                //   path: 'home',
                //   name: MovieScreen.name,
                //   builder: (context, state) {
                //     // Obtenemos el ID de la película a través de la ruta
                //     final movieID = state.pathParameters['id'] ?? 'no-id';
                //     return MovieScreen(movieId: movieID);
                //   },
                // )
              ]
            )
          ]
        ),

        // Inicio
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => SettingsView(),
              routes: const [
                // GoRoute(
                //   path: 'home',
                //   name: MovieScreen.name,
                //   builder: (context, state) {
                //     // Obtenemos el ID de la película a través de la ruta
                //     final movieID = state.pathParameters['id'] ?? 'no-id';
                //     return MovieScreen(movieId: movieID);
                //   },
                // )
              ]
            )
          ]
        ),

        // // Categorías
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: '/categories',
        //       builder: (context, state) => const CategoriesView(),
        //       routes: [
        //         GoRoute(
        //           path: '/:categoryID/:categoryName',
        //           name: MoviesByGenreScreen.name,
        //           builder: (context, state) {
        //             // Obtenemos el ID del género a través de la ruta
        //             final genreID = state.pathParameters['categoryID'] ?? 'no-id';
        //             final genreName = state.pathParameters['categoryName'] ?? 'no-name';
        //             return MoviesByGenreScreen(genreId: int.parse(genreID), genreName: genreName);
        //           },
        //         )
        //       ]
        //     )
        //   ]
        // ),

        // // Favoritos
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: '/favorites',
        //       builder: (context, state) => const FavoritesView(),
        //     )
        //   ]
        // )



      ],
    )

  ]
);