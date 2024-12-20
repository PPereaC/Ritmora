import 'dart:io';

import 'package:animate_do/animate_do.dart';
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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Añadir a lista',
          style: TextStyle(
            color: colors.onSurface,
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
                    color: colors.surface,
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
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _PlaylistInfo(
                                playlist: playlist,
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

  const _PlaylistImage({
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: thumbnailUrl != null
          ? Image(
              image: thumbnailUrl!.startsWith('assets/')
                  ? AssetImage(thumbnailUrl!)
                  : FileImage(File(thumbnailUrl!)) as ImageProvider,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: Colors.grey[800],
                child: Icon(
                  Icons.error_outline,
                  color: Colors.grey[600],
                ),
              ),
            )
          : Container(
              width: 56,
              height: 56,
              color: Colors.grey[800],
              child: Icon(
                Icons.music_note,
                color: Colors.grey[600],
              ),
            ),
    );
  }
}

class _PlaylistInfo extends StatelessWidget {
  final Playlist playlist;

  const _PlaylistInfo({
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlist.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${playlist.songs.length} canciones',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
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