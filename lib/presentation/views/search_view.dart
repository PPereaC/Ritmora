import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../domain/entities/song.dart';
import '../delegates/search_songs_delegate.dart';
import '../providers/providers.dart';

class SearchView extends ConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkmodeProvider);
    final genres = [
      {'name': 'Rock', 'icon': Icons.music_note_rounded},
      {'name': 'Pop', 'icon': Icons.music_note},
      {'name': 'Jazz', 'icon': Icons.piano},
      {'name': 'Clásica', 'icon': Icons.queue_music},
      {'name': 'Hip Hop', 'icon': Icons.mic},
      {'name': 'Electrónica', 'icon': Icons.album},
      {'name': 'R&B', 'icon': Icons.headphones},
      {'name': 'Latino', 'icon': Icons.playlist_play},
    ];

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
            elevation: 0,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                child: GestureDetector(
                  onTap: () async {
                    final searchQuery = ref.read(searchQueryProvider);
                    
                    // ignore: unused_local_variable
                    final song = await showSearch<Song?>(
                      query: searchQuery,
                      context: context,
                      delegate: SearchSongsDelegate(
                        searchSongs: ref.read(searchSongsProvider.notifier).searchSongsByQuery,
                        isDarkMode: isDarkMode,
                      )
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      ),
                    ),
                    height: 50,
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.search_normal_1_outline,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Buscar canciones, artistas o álbumes',
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descubrir por género',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final genre = genres[index];
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode 
                          ? [Colors.grey[850]!, Colors.grey[900]!]
                          : [Colors.grey[100]!, Colors.grey[200]!],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          // Navegar a la vista de género
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              genre['icon'] as IconData,
                              size: 32,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              genre['name'] as String,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: genres.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}