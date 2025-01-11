// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:finmusic/config/utils/pretty_print.dart';
import 'package:finmusic/presentation/providers/playlist/playlist_provider.dart';
import 'package:finmusic/presentation/widgets/widgets.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/helpers/permissions_helper.dart';
import '../../config/utils/constants.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
import '../../infrastructure/mappers/piped_search_songs_mapper.dart';

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
    final colors = Theme.of(context).colorScheme;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: colors.primary.withOpacity(0.5),
            width: 2,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelButtonText,
              style: TextStyle(color: colors.primary, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmButtonText,
              style: TextStyle(color: colors.primary, fontSize: 18),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _showCreatePlaylistDialog() {
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
            author: 'anonymous',
            thumbnailUrl: defaultPoster,
            playlistId: 'XXXXX'
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

  Future<void> _importPlaylist() async {
    List<Song> songList = [];
    String playlistName = '';
  
    try {
      // Verificar permisos de almacenamiento
      bool hasPermissions = await PermissionsHelper.storagePermission();
      if (!hasPermissions) {
        printERROR('No se concedieron los permisos necesarios');
        return;
      }
  
      // Configurar FilePicker para seleccionar un archivo CSV
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        dialogTitle: 'Seleccionar archivo CSV',
        withData: true,
      );
  
      if (result != null) {
        final path = result.files.single.path;
        if (path != null) {
          final file = File(path);
          if (path.toLowerCase().endsWith('.csv')) {
            final contents = await file.readAsString();
            final rows = const CsvToListConverter().convert(contents);
            
            if (rows.isEmpty) {
              printERROR('El archivo CSV está vacío');
              return;
            }
  
            // Procesar los headers (encabezados)
            final headers = rows.first;
            final mediaIdIndex = headers.indexWhere(
              (header) => header.toString().toLowerCase() == 'mediaid'
            );
            final titleIndex = headers.indexWhere(
              (header) => header.toString().toLowerCase() == 'title'
            );
            final artistsIndex = headers.indexWhere(
              (header) => header.toString().toLowerCase() == 'artists'
            );
            final playlistNameIndex = headers.indexWhere(
              (header) => header.toString().toLowerCase() == 'playlistname'
            );
  
            // Verificar que existan todas las columnas necesarias
            if (mediaIdIndex == -1 || titleIndex == -1 || 
                artistsIndex == -1 || playlistNameIndex == -1) {
                CustomSnackbar.show(
                  context,
                  'Faltan columnas requeridas en el CSV',
                  Colors.red,
                  Iconsax.warning_2_outline,
                  duration: 3,
                );
              printERROR('Faltan columnas requeridas en el CSV');
              return;
            }
  
            // Procesar filas y crear canciones
            for (var row in rows.skip(1)) {
              if (row.length > mediaIdIndex) {
                final song = Song(
                  songId: row[mediaIdIndex].toString(),
                  title: row[titleIndex].toString(),
                  author: row[artistsIndex].toString(),
                  thumbnailUrl: PipedSearchSongsMapper.getHighQualityThumbnail(row[mediaIdIndex].toString()),
                  streamUrl: '',
                  endUrl: '/watch?v=${row[mediaIdIndex].toString()}',
                  duration: '',
                );
                songList.add(song);
                playlistName = row[playlistNameIndex].toString();
              }
            }

            if (songList.isEmpty) {
              printERROR('No se encontraron canciones válidas en el CSV');
              return;
            }

            // Invertir el orden de las canciones
            songList = songList.reversed.toList();

            // Crear y guardar la playlist
            final playlist = Playlist(
              title: playlistName,
              author: '',
              thumbnailUrl: defaultPoster,
            );

            await ref.read(playlistProvider.notifier).addPlaylist(playlist);

            // Agregar todas las canciones a la playlist
            for (final song in songList) {
              await ref.read(playlistProvider.notifier).addSongToPlaylist(
                context, 
                playlist.id, 
                song,
                showNotifications: false,
                reloadPlaylists: false  // Evita recargas innecesarias
              );
            }

            // Recargar la lista una sola vez al finalizar
            await ref.read(playlistProvider.notifier).loadPlaylists();

            // Mostrar una única notificación al finalizar
            CustomSnackbar.show(
              context,
              'Playlist importada con éxito: ${songList.length} canciones agregadas',
              Colors.green,
              Iconsax.tick_circle_outline,
              duration: 3,
            );
            
          }
        }
      } else {
        printERROR('No se seleccionó ningún archivo');
      }
    } catch (e) {
      printERROR('Error al procesar el archivo: $e');
    }
  }
    

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
  
    return Scaffold(
      backgroundColor: colors.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text(
        //   'Biblioteca',
        //   style: TextStyle(
        //     fontFamily: 'Titulo',
        //     color: Colors.white,
        //     fontSize: 30
        //   ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                IconButton.filled(
                  onPressed: () => _importPlaylist(),
                  icon: const Icon(Iconsax.import_2_outline),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.secondary.withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(width: 3),
                IconButton.filled(
                  onPressed: () => _showCreatePlaylistDialog(),
                  icon: const Icon(Iconsax.add_square_outline),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.secondary.withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [

          // Gradiente
          const GradientWidget(),
  
          // Contenido Principal
          SafeArea(
            child: Column(
              children: [

                // TabBar
                _tabBar(colors),
  
                // TabBarView
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPlaylistsView(),
                      _buildAlbumsView(),
                      _buildArtistsView(),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar(ColorScheme colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.secondary,
            width: 2,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorColor: colors.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        tabs: const [
          Text('Playlists'),
          Text('Álbumes'),
          Text('Artistas'),
        ],
      ),
    );
  }

  Widget _buildPlaylistsView() {

    final bool isTabletOrDesktop = Responsive.isTablet(context) || Responsive.isDesktop(context);

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
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
  
        if (playlistState.playlists.isEmpty) {
          return const Center(
            child: Text(
              'No hay playlists creadas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        }
  
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Responsive.isMobile(context) ? 2 : Responsive.isDesktop(context) ? 8 : Responsive.isTablet(context) ? 4 : 5,
            childAspectRatio: isTabletOrDesktop ? 0.7 : 0.8,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: playlistState.playlists.length,
          itemBuilder: (context, index) {
            final playlist = playlistState.playlists[index];
            return MouseRegion(
              child: InkWell(
                onTap: () {
                  context.go(
                    '/library/playlist/0/${playlist.id}',
                    extra: playlist,
                  );
                },
                onLongPress: () async {
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
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image(
                          image: playlist.thumbnailUrl.startsWith('assets/')
                              ? AssetImage(playlist.thumbnailUrl)
                              : FileImage(File(playlist.thumbnailUrl)) as ImageProvider,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[900],
                            child: Image.asset(
                              defaultPoster,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          playlist.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAlbumsView() {
    return Container(); // TODO: Implementación futura
  }

  Widget _buildArtistsView() {
    return Container(); // TODO: Implementación futura
  }
}