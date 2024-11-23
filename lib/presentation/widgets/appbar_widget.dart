import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../domain/entities/song.dart';
import '../delegates/search_songs_delegate.dart';
import '../providers/providers.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.grey[900],
      elevation: 0,
      title: Row(
        children: [
          // Imagen circular (logo)
          Image.asset(
            'assets/images/logo.png',
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
          
          const SizedBox(width: 12),
          
          // Texto
          const Text(
            'MUSIC',
            style: TextStyle(
              fontFamily: 'Appbar',
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),

          const Spacer(),

          // Botón de búsqueda
          IconButton(
            onPressed: () async {
              final searchedSongs = ref.read(searchSongsProvider);
              final searchQuery = ref.read(searchQueryProvider);
              final song = await showSearch<Song?>(
                query: searchQuery,
                context: context,
                delegate: SearchSongsDelegate(
                  initialSongs: searchedSongs,
                  searchSongs: ref.read(searchSongsProvider.notifier).searchSongsByQuery
                )
              );
            },
            icon: const Icon(
              Iconsax.search_normal_1_outline,
              color: Colors.white,
              size: 25,
            ),
          ),

        ],
      ),
    );
  }
}