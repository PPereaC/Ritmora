// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../providers/providers.dart';
import '../widgets.dart';

class SearchResultsContent extends ConsumerWidget {
  final TextEditingController searchController;

  const SearchResultsContent({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final colors = Theme.of(context).colorScheme;

    final currentFilter = ref.watch(searchFilterProvider);
    final searchResults = ref.watch(searchSongsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: FilterButton(
                  label: 'Canciones',
                  icon: Iconsax.music_outline,
                  isSelected: currentFilter == 'songs',
                  onPressed: () => ref.read(searchFilterProvider.notifier).state = 'songs',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterButton(
                  label: 'Videos',
                  icon: Iconsax.video_play_outline,
                  isSelected: currentFilter == 'videos',
                  onPressed: () => ref.read(searchFilterProvider.notifier).state = 'videos',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: searchController.text.isEmpty
            ? const Center(
                child: Text(
                  'Busca tus canciones favoritas',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final song = searchResults[index];
                  return SongListTile(
                    song: song,
                    onSongOptions: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: colors,
                          ),
                          child: BottomSheetBarWidget(song: song),
                        ),
                      );
                    },
                    isPlaylist: false,
                    isVideo: currentFilter == 'videos',
                  );
                },
              ),
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: isSelected ? colors.primary : Colors.grey[900],
        foregroundColor: Colors.white,
      ),
    );
  }
}