import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../domain/entities/song.dart';
import '../delegates/search_songs_delegate.dart';
import '../providers/search_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: const Center(
        child: Text('Pantalla de Inicio'),
      ),
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          backgroundColor: colors.primary,
          onPressed: () async {
            final searchedSongs = ref.read(searchSongsProvider);
            final searchQuery = ref.read(searchQueryProvider);
            // ignore: unused_local_variable
            final song = await showSearch<Song?>(
              query: searchQuery,
              context: context,
              delegate: SearchSongsDelegate(
                initialSongs: searchedSongs,
                searchSongs: ref.read(searchSongsProvider.notifier).searchSongsByQuery
              )
            );
          },
          child: const Icon(Iconsax.search_normal_1_outline, size: 30),
        ),
      ),
    );
  }
}