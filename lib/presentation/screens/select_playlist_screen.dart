import 'package:animate_do/animate_do.dart';
import 'package:apolo/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../domain/entities/playlist.dart';

class SelectPlaylistScreen extends ConsumerStatefulWidget {
  final List<Playlist> playlists;

  const SelectPlaylistScreen({
    super.key,
    required this.playlists,
  });

  @override
  ConsumerState<SelectPlaylistScreen> createState() => _SelectPlaylistScreenState();
}

class _SelectPlaylistScreenState extends ConsumerState<SelectPlaylistScreen> {
  final Set<Playlist> selectedPlaylists = {};

  void togglePlaylist(Playlist playlist) {
    setState(() {
      if (selectedPlaylists.contains(playlist)) {
        selectedPlaylists.remove(playlist);
      } else {
        selectedPlaylists.add(playlist);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkmodeProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDarkMode ? colors.onSurface : colors.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Añadir a lista',
          style: TextStyle(
            color: isDarkMode ? colors.onSurface : colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.playlists.length,
              itemBuilder: (context, index) {
                final playlist = widget.playlists[index];
                final isSelected = selectedPlaylists.contains(playlist);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? colors.surface : colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => togglePlaylist(playlist),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            _PlaylistImage(
                              thumbnailUrl: playlist.thumbnailUrl,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PlaylistInfo(
                                playlist: playlist,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                            IconButton(
                              onPressed: () => togglePlaylist(playlist),
                              icon: isSelected
                                  ? FadeIn(
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(
                                        Iconsax.tick_circle_outline,
                                        color: colors.primary,
                                        size: 28,
                                      ),
                                    )
                                  : FadeIn(
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                        Icons.circle_outlined,
                                        color: colors.onSurfaceVariant,
                                        size: 28,
                                      ),
                                  ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              splashRadius: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _BottomButton(
            selectedPlaylists: selectedPlaylists,
            onPressed: selectedPlaylists.isNotEmpty
                ? () {
                    final selectedIds = selectedPlaylists
                      .map((playlist) => playlist.id.toString())
                      .toList();

                    context.pop(selectedIds);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _PlaylistImage extends StatelessWidget {
  final String? thumbnailUrl;
  final bool isDarkMode;

  const _PlaylistImage({
    required this.thumbnailUrl,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: thumbnailUrl != null
          ? Image.network(
              thumbnailUrl!,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            )
          : Container(
              width: 56,
              height: 56,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              child: Icon(
                Icons.music_note,
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
    );
  }
}

class _PlaylistInfo extends StatelessWidget {
  final Playlist playlist;
  final bool isDarkMode;

  const _PlaylistInfo({
    required this.playlist,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${playlist.songs.length} canciones',
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _BottomButton extends StatelessWidget {
  final Set<Playlist> selectedPlaylists;
  final VoidCallback? onPressed;

  const _BottomButton({
    required this.selectedPlaylists,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Hecho',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}