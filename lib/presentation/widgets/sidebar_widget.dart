// ignore_for_file: deprecated_member_use, library_private_types_in_public_api

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/utils/constants.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/youtube_playlist.dart';
import '../providers/playlist/playlist_provider.dart';

class CustomMusicSidebar extends ConsumerStatefulWidget {
  const CustomMusicSidebar({super.key});

  @override
  CustomMusicSidebarState createState() => CustomMusicSidebarState();
}

class CustomMusicSidebarState extends ConsumerState<CustomMusicSidebar> {
  final List<_SidebarItem> mainItems = [
    _SidebarItem(icon: MingCute.home_4_line, iconSelected: MingCute.home_4_fill, label: 'Inicio', route: '/'),
    _SidebarItem(icon: MingCute.search_line, iconSelected: MingCute.search_fill, label: 'Buscar', route: '/search'),
    _SidebarItem(icon: MingCute.heart_line, iconSelected: MingCute.heart_fill, label: 'Favoritos', route: '/favorites'),
    _SidebarItem(icon: MingCute.music_3_line, iconSelected: MingCute.music_3_fill, label: 'Biblioteca', route: '/library'),
  ];

  final List<_SidebarItem> bottomItems = [
    _SidebarItem(icon: MingCute.settings_7_line, iconSelected: MingCute.settings_7_fill, label: 'Ajustes', route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    final TextEditingController playlistNameController = TextEditingController();

    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: colors.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface.withOpacity(0.98),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(3, 0),
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              _buildHeader(colors),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: colors.primary.withOpacity(0.1),
                  height: 1,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ...mainItems.map((item) => _SidebarIconItem(
                        icon: item.icon,
                        label: item.label,
                        route: item.route,
                      )),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'TUS PLAYLISTS',
                              style: textStyles.labelSmall?.copyWith(
                                color: Colors.white70,
                                letterSpacing: 0.5,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () { // Crear playlist local
                                ref.read(playlistProvider.notifier).createLocalPlaylist(context, playlistNameController, ref);
                              },
                              icon: const Icon(
                                Iconsax.add_circle_outline,
                                size: 18,
                                color: Colors.white70,
                              ),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildPlaylists(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: colors.primary.withOpacity(0.1),
                  height: 1,
                ),
              ),
              ...bottomItems.map((item) => _SidebarIconItem(
                icon: item.icon,
                label: item.label,
                route: item.route,
              )),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ritmora',
              style: GoogleFonts.play().copyWith(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylists() {
    return Consumer(
      builder: (context, ref, child) {
        final playlistState = ref.watch(playlistProvider);

        if (playlistState.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (playlistState.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                playlistState.errorMessage!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Combinamos ambas listas en una lista de objetos Playlist
        final allPlaylists = [
          ...playlistState.playlists,
          ...playlistState.youtubePlaylists.map((yt) => 
            Playlist(
              id: 0,
              title: yt.title,
              author: yt.author,
              thumbnailUrl: yt.thumbnailUrl,
              playlistId: yt.playlistId,
              isLocal: 1
            )
          )
        ];

        if (allPlaylists.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text(
                'No hay playlists creadas',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: allPlaylists.length,
          itemBuilder: (context, index) {
            final playlist = allPlaylists[index];
            return InkWell(
              onTap: () {
                context.go(
                  '/library/playlist/${playlist.isLocal}/${playlist.isLocal == 0 ? playlist.id : playlist.playlistId}',
                  extra: playlist,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white12,
                ),
                clipBehavior: Clip.antiAlias,
                child: playlist is YoutubePlaylist
                    ? _buildYoutubePlaylistThumbnail(playlist as YoutubePlaylist)
                    : _buildLocalPlaylistThumbnail(playlist),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildYoutubePlaylistThumbnail(YoutubePlaylist playlist) {
    // Primero intentamos cargar como File si existe localmente
    try {
      final file = File(playlist.thumbnailUrl);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultThumbnail(),
        );
      }
    } catch (e) {
      print('Error al cargar imagen local: $e');
    }
    
    // Si no existe como File, mostramos defaultPoster
    return Image.asset(
      defaultPoster,
      fit: BoxFit.cover,
    );
  }

  Widget _buildLocalPlaylistThumbnail(Playlist playlist) {
    // Para playlists locales con imagen de assets
    if (playlist.thumbnailUrl.startsWith('assets/')) {
      return Image.asset(
        playlist.thumbnailUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultThumbnail(),
      );
    }
    
    // Para playlists locales con imagen de archivo
    try {
      return Image.file(
        File(playlist.thumbnailUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultThumbnail(),
      );
    } catch (e) {
      return _buildDefaultThumbnail();
    }
  }

  Widget _buildDefaultThumbnail() {
    return Container(
      color: Colors.grey[900],
      child: Image.asset(
        defaultPoster,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final IconData iconSelected;
  final String label;
  final String route;

  _SidebarItem({
    required this.icon,
    required this.iconSelected,
    required this.label,
    required this.route,
  });
}

class _SidebarIconItem extends ConsumerWidget {
  final IconData icon;
  final String label;
  final String route;

  const _SidebarIconItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final isSelected = currentRoute == route;
    final colors = Theme.of(context).colorScheme;
  
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 2,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected 
                  ? colors.primary.withOpacity(0.9) 
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: colors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ] : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => context.go(route),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: isSelected ? Colors.white : Colors.white70,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

