import 'dart:io';

import 'package:apolo/presentation/providers/playlist/playlist_provider.dart';
import 'package:apolo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../domain/entities/playlist.dart';
import '../providers/theme/theme_provider.dart';

class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({super.key});

  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _playlistNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => _loadPlaylists());
  }

  Future<void> _loadPlaylists() async {
    await ref.read(playlistProvider.notifier).loadPlaylists();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _playlistNameController.dispose();
    super.dispose();
  }

  Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    String cancelButtonText,
    String confirmButtonText,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelButtonText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmButtonText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _showCreatePlaylistDialog(bool isDarkMode) {
    return showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Nueva Playlist',
        hintText: 'Nombre de la playlist',
        cancelButtonText: 'Cancelar',
        confirmButtonText: 'Crear',
        controller: _playlistNameController,
        onCancel: () {
          _playlistNameController.clear();
          Navigator.pop(context);
        },
        onConfirm: (value) async {
          final playlist = Playlist(
            title: value,
            author: '',
            thumbnailUrl: 'assets/images/playlist_default.jpg',
          );
          
          await ref.read(playlistProvider.notifier).addPlaylist(playlist);
          
          if (context.mounted) {
            Navigator.pop(context);
          }
          _playlistNameController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkmodeProvider);
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Biblioteca',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.add_circle_bold,
              color: isDarkMode ? Colors.white : Colors.grey,
              size: 28,
            ),
            onPressed: () => _showCreatePlaylistDialog(isDarkMode),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDarkMode ? Colors.white : Colors.black87,
          unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey,
          indicatorColor: isDarkMode ? Colors.white : Colors.black87,
          tabs: const [
            Tab(text: 'Playlists'),
            Tab(text: 'Álbumes'),
            Tab(text: 'Artistas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlaylistsView(isDarkMode),
          _buildAlbumsView(isDarkMode),
          _buildArtistsView(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildPlaylistsView(bool isDarkMode) {
    return Consumer(
      builder: (context, ref, child) {
        final playlistState = ref.watch(playlistProvider);
  
        if (playlistState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
  
        if (playlistState.errorMessage != null) {
          return Center(
            child: Text(
              playlistState.errorMessage!,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          );
        }
  
        if (playlistState.playlists.isEmpty) {
          return Center(
            child: Text(
              'No hay playlists creadas',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          );
        }
  
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: playlistState.playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlistState.playlists[index];
            return MouseRegion(
              child: InkWell(
                onTap: () { // Acción al tocar la playlist
                  context.go('/library/playlist/${playlist.id}');
                },
                onLongPress: () async { // Acción al mantener presionado la playlist (borrar)
                  final shouldDelete = await showConfirmationDialog(
                    context,
                    '¿Seguro que quieres eliminar la playlist?',
                    'Esta acción no se puede deshacer',
                    'Cancelar',
                    'Eliminar',
                  );
                  if (shouldDelete) {
                    await ref.read(playlistProvider.notifier).deletePlaylist(playlist);
                    if (context.mounted && context.canPop()) {
                      context.pop();
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode 
                          ? Colors.black.withOpacity(0.4)
                          : Colors.black.withOpacity(0.2),
                        blurRadius: 8.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      children: [

                        Image(
                          image: playlist.thumbnailUrl.startsWith('assets/')
                              ? AssetImage(playlist.thumbnailUrl)
                              : FileImage(File(playlist.thumbnailUrl)) as ImageProvider,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.error_outline,
                            size: 48,
                            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                          ),
                        ),
                        
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playlist.title,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAlbumsView(bool isDarkMode) {
    return Container(); // TODO: Implementación futura
  }

  Widget _buildArtistsView(bool isDarkMode) {
    return Container(); // TODO: Implementación futura
  }
}