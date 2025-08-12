// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:ritmora/config/utils/pretty_print.dart';
import 'package:ritmora/presentation/providers/playlist/playlist_provider.dart';
import 'package:ritmora/presentation/widgets/widgets.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/helpers/permissions_helper.dart';
import '../../config/utils/constants.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
import '../../infrastructure/mappers/piped_search_songs_mapper.dart';
import '../../infrastructure/services/youtube_service.dart';

class LibraryView extends ConsumerStatefulWidget {
  const LibraryView({super.key});

  @override
  ConsumerState<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends ConsumerState<LibraryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController playlistNameController = TextEditingController();
  final TextEditingController youtubePlaylistUrlController =
      TextEditingController();

  // View mode (list/grid) persisted
  static const _kViewModeKey = 'library_view_mode';
  bool _isGridMode = true; // default

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => _loadPlaylists());
    _loadViewMode();
  }

  Future<void> _loadPlaylists() async {
    await ref.read(playlistProvider.notifier).loadPlaylists();
  }

  Future<void> _loadViewMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mode = prefs.getString(_kViewModeKey);
      if (mode != null) {
        setState(() {
          _isGridMode = mode == 'grid';
        });
      }
    } catch (_) {}
  }

  Future<void> _saveViewMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kViewModeKey, _isGridMode ? 'grid' : 'list');
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    playlistNameController.dispose();
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

  Future<void> _importPlaylist() async {
    List<Song> songList = [];
    String playlistName = '';

    try {
      // Verificar permisos de almacenamiento en Android
      if (Platform.isAndroid) {
        bool hasPermissions = await PermissionsHelper.storagePermission();
        if (!hasPermissions) {
          printERROR('No se concedieron los permisos necesarios');
          return;
        }
      }

      // Configurar FilePicker para seleccionar un archivo CSV
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        allowMultiple: false,
        dialogTitle: 'Seleccionar archivo CSV',
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
                (header) => header.toString().toLowerCase() == 'mediaid');
            final titleIndex = headers.indexWhere(
                (header) => header.toString().toLowerCase() == 'title');
            final artistsIndex = headers.indexWhere(
                (header) => header.toString().toLowerCase() == 'artists');
            final playlistNameIndex = headers.indexWhere(
                (header) => header.toString().toLowerCase() == 'playlistname');

            // Verificar que existan todas las columnas necesarias
            if (mediaIdIndex == -1 ||
                titleIndex == -1 ||
                artistsIndex == -1 ||
                playlistNameIndex == -1) {
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
                  thumbnailUrl: PipedSearchSongsMapper.getHighQualityThumbnail(
                      row[mediaIdIndex].toString()),
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
                  context, playlist.id, song,
                  showNotifications: false,
                  reloadPlaylists: false // Evita recargas innecesarias
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
    bool isDesktop = Responsive.isTabletOrDesktop(context);

    var playlistP = ref.watch(playlistProvider.notifier);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            // Header con título y acciones
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 10,
                top: isDesktop ? 16 : 6,
              ),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tu Biblioteca',
                        style: GoogleFonts.montserrat(
                          fontSize: isDesktop ? 28 : 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      // Acciones como "pills" sutiles
                      Row(
                        children: [
                          // Guardar playlist de Youtube
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  title: 'Guardar Playlist de Youtube',
                                  hintText: 'URL de la playlist',
                                  cancelButtonText: 'Cancelar',
                                  confirmButtonText: 'Guardar',
                                  controller: youtubePlaylistUrlController,
                                  onCancel: () {
                                    youtubePlaylistUrlController.clear();
                                    Navigator.pop(context);
                                  },
                                  onConfirm: (value) async {
                                    var yt = YoutubeService();
                                    final youtubePlaylist =
                                        await yt.getYoutubePlaylistInfo(
                                      youtubePlaylistUrlController.text,
                                    );
                                    playlistP
                                        .addYoutubePlaylist(youtubePlaylist);
                                    final songs =
                                        await yt.getYoutubePlaylistSongs(
                                      youtubePlaylistUrlController.text,
                                    );
                                    playlistP.addSongsToYoutubePlaylist(
                                      youtubePlaylist.playlistId,
                                      songs,
                                    );
                                    if (context.mounted) Navigator.pop(context);
                                    youtubePlaylistUrlController.clear();
                                  },
                                ),
                              );
                            },
                            icon: const Icon(MingCute.youtube_line, size: 22),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.08),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Importar playlist
                          IconButton(
                            onPressed: () => _importPlaylist(),
                            icon:
                                const Icon(Iconsax.import_2_outline, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.08),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Crear playlist local
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(playlistProvider.notifier)
                                  .createLocalPlaylist(
                                    context,
                                    playlistNameController,
                                    ref,
                                  );
                            },
                            icon: const Icon(Iconsax.add_square_outline,
                                size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.08),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Chips de categorías + toggle de vista (lista/grid)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: double.infinity,
                  ),
                  child: Row(
                    children: [
                      _chipsBar(colors),
                      const Spacer(),
                      _viewToggle(colors),
                    ],
                  ),
                ),
              ),
            ),

            // Contenido
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
    );
  }

  Widget _chipsBar(ColorScheme colors) {
    final selected = _tabController.index;
    void select(int i) {
      if (_tabController.index != i) {
        setState(() => _tabController.index = i);
      }
    }

    const chipStyle = TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('Playlists'),
          labelStyle: chipStyle,
          selected: selected == 0,
          onSelected: (_) => select(0),
          selectedColor: Colors.white.withOpacity(0.14),
          backgroundColor: Colors.white.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.white.withOpacity(0.10)),
          ),
        ),
        ChoiceChip(
          label: const Text('Álbumes'),
          labelStyle: chipStyle,
          selected: selected == 1,
          onSelected: (_) => select(1),
          selectedColor: Colors.white.withOpacity(0.14),
          backgroundColor: Colors.white.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.white.withOpacity(0.10)),
          ),
        ),
        ChoiceChip(
          label: const Text('Artistas'),
          labelStyle: chipStyle,
          selected: selected == 2,
          onSelected: (_) => select(2),
          selectedColor: Colors.white.withOpacity(0.14),
          backgroundColor: Colors.white.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(color: Colors.white.withOpacity(0.10)),
          ),
        ),
      ],
    );
  }

  Widget _viewToggle(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
      ),
      child: Row(
        children: [
          _toggleButton(
            icon: Iconsax.row_vertical_outline,
            selected: !_isGridMode,
            onTap: () async {
              if (_isGridMode) {
                setState(() => _isGridMode = false);
                await _saveViewMode();
              }
            },
          ),
          _toggleButton(
            icon: Iconsax.element_4_outline,
            selected: _isGridMode,
            onTap: () async {
              if (!_isGridMode) {
                setState(() => _isGridMode = true);
                await _saveViewMode();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _toggleButton(
      {required IconData icon,
      required bool selected,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildPlaylistsView() {
    final bool isTabletOrDesktop =
        Responsive.isTablet(context) || Responsive.isDesktop(context);

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
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final allPlaylists = [
          ...playlistState.playlists,
          ...playlistState.youtubePlaylists.map((yt) => Playlist(
              id: 0,
              title: yt.title,
              author: yt.author,
              thumbnailUrl: yt.thumbnailUrl,
              playlistId: yt.playlistId,
              isLocal: 1))
        ];

        if (allPlaylists.isEmpty) {
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

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: double.infinity,
            ),
            child: _isGridMode
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: isTabletOrDesktop ? 200 : 180,
                      childAspectRatio: isTabletOrDesktop ? 0.70 : 0.75,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: allPlaylists.length,
                    itemBuilder: (context, index) {
                      final playlist = allPlaylists[index];
                      return PlaylistCard(
                        playlist: playlist,
                        onTap: () {
                          context.go(
                            '/library/playlist/${playlist.isLocal}/${playlist.isLocal == 0 ? playlist.id : playlist.playlistId}',
                            extra: playlist,
                          );
                        },
                        onLongPress: () async {
                          // SI es una playlist local
                          if (playlist.isLocal == 0) {
                            final shouldDelete = await showConfirmationDialog(
                              context,
                              '¿Seguro que quieres eliminar la playlist?',
                              'Esta acción no se puede deshacer',
                              'Cancelar',
                              'Eliminar',
                            );
                            if (shouldDelete) {
                              await ref
                                  .read(playlistProvider.notifier)
                                  .deletePlaylist(playlist);
                            }
                          }

                          // SI es una playlist de youtube
                          if (playlist.isLocal == 1) {
                            final shouldDelete = await showConfirmationDialog(
                              context,
                              '¿Seguro que quieres eliminar la playlist?',
                              'Esta acción no se puede deshacer',
                              'Cancelar',
                              'Eliminar',
                            );
                            if (shouldDelete) {
                              await ref
                                  .read(playlistProvider.notifier)
                                  .removeYoutubePlaylist(playlist.playlistId);
                            }
                          }
                        },
                      );
                    },
                  )
                : ListView.separated(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: allPlaylists.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: Colors.white.withOpacity(0.08),
                    ),
                    itemBuilder: (context, index) {
                      final playlist = allPlaylists[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image(
                            image: playlist.thumbnailUrl.startsWith('http')
                                ? NetworkImage(playlist.thumbnailUrl)
                                : playlist.thumbnailUrl.startsWith('assets/')
                                    ? AssetImage(playlist.thumbnailUrl)
                                    : (playlist.thumbnailUrl.isNotEmpty
                                        ? FileImage(File(playlist.thumbnailUrl))
                                            as ImageProvider
                                        : const AssetImage(defaultPoster)),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              defaultPoster,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          playlist.title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'Lista ${playlist.isLocal == 0 ? 'Local' : 'de Youtube'}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Iconsax.more_outline,
                            color: Colors.white70, size: 18),
                        onTap: () {
                          context.go(
                            '/library/playlist/${playlist.isLocal}/${playlist.isLocal == 0 ? playlist.id : playlist.playlistId}',
                            extra: playlist,
                          );
                        },
                        onLongPress: () async {
                          // SI es una playlist local
                          if (playlist.isLocal == 0) {
                            final shouldDelete = await showConfirmationDialog(
                              context,
                              '¿Seguro que quieres eliminar la playlist?',
                              'Esta acción no se puede deshacer',
                              'Cancelar',
                              'Eliminar',
                            );
                            if (shouldDelete) {
                              await ref
                                  .read(playlistProvider.notifier)
                                  .deletePlaylist(playlist);
                            }
                          }
                          // SI es una playlist de youtube
                          if (playlist.isLocal == 1) {
                            final shouldDelete = await showConfirmationDialog(
                              context,
                              '¿Seguro que quieres eliminar la playlist?',
                              'Esta acción no se puede deshacer',
                              'Cancelar',
                              'Eliminar',
                            );
                            if (shouldDelete) {
                              await ref
                                  .read(playlistProvider.notifier)
                                  .removeYoutubePlaylist(playlist.playlistId);
                            }
                          }
                        },
                      );
                    },
                  ),
          ),
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
