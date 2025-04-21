// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:finmusic/presentation/providers/playlist/playlist_provider.dart';
import 'package:finmusic/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/helpers/permissions_helper.dart';
import '../../config/utils/constants.dart';
import '../../config/utils/pretty_print.dart';
import '../../config/utils/responsive.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
import '../../infrastructure/services/youtube_service.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/widgets.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  final String playlistID;
  final String isLocalPlaylist;
  final Playlist? playlist;

  const PlaylistScreen({
    super.key,
    required this.playlistID,
    required this.isLocalPlaylist,
    this.playlist
  });

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _opacity = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override 
  void dispose() {
    _scrollController.dispose();
    _opacity.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 400) {
      _opacity.value = 1.0;
    } else {
      _opacity.value = 0.0;
    }
  }

  Future<List<Song>> getPlaylistSongs(String playlistID) async {
    try {
      if (widget.isLocalPlaylist == '0') { // Para playlists locales
        return await ref.read(playlistProvider.notifier).getSongsFromPlaylist(int.parse(playlistID));
      } else { // Para playlists de youtube
        final ytService = YoutubeService();
        final songs = await ytService.getPlaylistSongs(playlistID);
        return songs;
      }
    } catch (e) {
      printERROR('Hola Error $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {

    // bool isLocalPlaylist = widget.isLocalPlaylist == '0';
    final bool isTabletOrDesktop = Responsive.isTabletOrDesktop(context);

    return Scaffold(
      appBar: isTabletOrDesktop
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ValueListenableBuilder(
                valueListenable: _opacity,
                builder: (context, double opacity, _) {
                  return AppBar(
                    elevation: 0,
                    backgroundColor: Colors.grey[800]?.withOpacity(opacity),
                    title: Opacity(
                      opacity: opacity,
                      child: Text(
                        widget.playlist?.title ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () {
                        if (widget.isLocalPlaylist == '0') {
                          context.go('/library');
                        } else {
                          context.go('/');
                        }
                      },
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Iconsax.setting_2_outline, color: Colors.white),
                              onPressed: () {
                                // Acción de más opciones
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
      body: FutureBuilder<List<Song>>(
        future: getPlaylistSongs(widget.playlistID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
            );
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay canciones en esta playlist'),
            );
          }
          
          final songs = snapshot.data!;
          
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    if (isTabletOrDesktop)
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                            onPressed: () {
                              if (widget.isLocalPlaylist == '0') {
                                context.go('/library');
                              } else {
                                context.go('/');
                              }
                            },
                          ),
                        ),
                      ),
                    isTabletOrDesktop
                        ? _TabletDesktopPlaylistHeader(
                            title: widget.playlist?.title ?? '',
                            thumbnail: widget.playlist?.thumbnailUrl ?? '',
                            playlistID: widget.playlistID,
                            isLocalPlaylist: widget.isLocalPlaylist == '0',
                            songs: songs,
                          )
                        : _MobilePlaylistHeader(
                            title: widget.playlist?.title ?? '',
                            thumbnail: widget.playlist?.thumbnailUrl ?? '',
                            playlistID: widget.playlistID,
                            isLocalPlaylist: widget.isLocalPlaylist == '0',
                            songs: songs,
                          ),
                  ],
                ),
              ),
              _PlaylistSongsList(
                songs: songs,
                isLocalPlaylist: widget.isLocalPlaylist,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlaylistSongsList extends StatefulWidget {
  final String isLocalPlaylist;
  final List<Song> songs;
  
  const _PlaylistSongsList({
    required this.songs,
    required this.isLocalPlaylist,
  });

  @override
  State<_PlaylistSongsList> createState() => _PlaylistSongsListState();
}

class _PlaylistSongsListState extends State<_PlaylistSongsList> {
  bool _showReversed = false;

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 5),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final songIndex = _showReversed
              ? (widget.songs.length - 1 - index) 
              : index;

            return Column(
              children: [

                const SizedBox(height: 8.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                  
                      // Ordenar canciones
                      if (index == 0) 
                        IconButton(
                          icon: Icon(
                            _showReversed 
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _showReversed = !_showReversed;
                            });
                          },
                        ),
                  
                      if (index == 0) 
                        Text(
                          'Posición',
                          style: textStyle.bodyLarge!.copyWith(
                            color: Colors.white
                          ),
                        ),
                  
                      const Spacer(),
                  
                      // Botón de búsqueda
                      if (index == 0)
                        IconButton(
                          icon: const Icon(MingCute.search_line, size: 22, color: Colors.white),
                          onPressed: () { // Acción de búsqueda de canciones
                            
                          },
                        ),
                  
                    ],  
                  ),
                ),
                
                SongListTile(
                  song: widget.songs[songIndex],
                  onSongOptions: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheetBarWidget(
                          song: widget.songs[songIndex],
                        );
                      },
                    );
                  },
                  isPlaylist: widget.isLocalPlaylist == '0' ? true : false,
                  isVideo: widget.songs[songIndex].author.contains('Video') || widget.songs[songIndex].author.contains('Episode'),
                ),
              ],
            );
          },
          childCount: widget.songs.length,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _MobilePlaylistHeader extends ConsumerWidget {
  final String title;
  final String thumbnail;
  final String playlistID;  // Changed from int to String
  final bool isLocalPlaylist;
  List<Song> songs;

  _MobilePlaylistHeader({
    required this.title, 
    required this.thumbnail,
    required this.playlistID,
    required this.isLocalPlaylist,
    required this.songs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    Future<void> updateThumbnail() async {
      bool isGranted = await PermissionsHelper.storagePermission();
      if (!isGranted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permisos de almacenamiento'),
            content: const Text('No tienes permisos de almacenamiento. Por favor, actívalos manualmente en la configuración de tu dispositivo.'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  bool isGranted = await PermissionsHelper.storagePermission();
                  if (isGranted) {
                    final image = await ImagePickerWidget.pickImage(context);
                    if (image != null) {
                      ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), image.path);
                      context.push('/library');
                    }
                  }
                },
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );
      } else {
        final image = await ImagePickerWidget.pickImage(context);
        if (image != null) {
          ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), image.path);
          context.push('/library');
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: MouseRegion(
              child: GestureDetector(
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Iconsax.edit_outline, size: 28, color: Colors.white),
                              title: Text(
                                'Cambiar nombre',
                                style: textStyle.titleLarge!.copyWith(
                                  color: Colors.white
                                ),
                              ),
                              onTap: () {
                                context.pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Iconsax.gallery_edit_outline, size: 28, color: Colors.white),
                              title: Text(
                                'Cambiar imagen',
                                style: textStyle.titleLarge!.copyWith(
                                  color: Colors.white
                                ),
                              ),
                              onTap: () {
                                context.pop();
                                updateThumbnail();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center( 
                    child: SizedBox(
                      width: 260,
                      height: 260,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(
                          image: isLocalPlaylist 
                            ? (thumbnail.startsWith('assets/')
                                ? AssetImage(thumbnail)
                                : FileImage(File(thumbnail)) as ImageProvider)
                            : NetworkImage(thumbnail) as ImageProvider,
                          height: 260,
                          width: 260,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 260,
                            width: 260,
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
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Botones de control
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reproducir playlist
              _ControlButton(
                icon: Icons.play_arrow_rounded,
                onPressed: () {},
              ),
          
              const SizedBox(width: 8),
          
              // Reproducir en modo aleatorio
              _ControlButton(
                icon: MingCute.shuffle_2_line,
                onPressed: () {
                  songs = songs..shuffle();
                  final playerProvider = ref.read(songPlayerProvider);
                  playerProvider.playSong(songs.first);
                },
              ),
          
              const SizedBox(width: 8),
          
              // Marcar como favorita
              _ControlButton(
                icon: MingCute.heart_line,
                onPressed: () {
                  // TODO: Implementar marcar playlist como favorita
                },
              ),
          
              const SizedBox(width: 8),
          
              // Recargar playlist y todas sus canciones (sincronizar)
              _ControlButton(
                icon: MingCute.refresh_1_line,
                onPressed: () {
                  // TODO: Implementar recargar playlist (sincronizar)
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _TabletDesktopPlaylistHeader extends ConsumerWidget {
  final String title;
  final String thumbnail;
  final String playlistID;
  final bool isLocalPlaylist;
  List<Song> songs;

  _TabletDesktopPlaylistHeader({
    required this.title, 
    required this.thumbnail,
    required this.playlistID,
    required this.isLocalPlaylist,
    required this.songs,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    Future<void> updateThumbnail() async {
      if(Platform.isAndroid) {
        bool isGranted = await PermissionsHelper.storagePermission();
        if (!isGranted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permisos de almacenamiento'),
              content: const Text('No tienes permisos de almacenamiento. Por favor, actívalos manualmente en la configuración de tu dispositivo.'),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    bool isGranted = await PermissionsHelper.storagePermission();
                    if (isGranted) {
                      final image = await ImagePickerWidget.pickImage(context);
                      if (image != null) {
                        ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), image.path);
                        context.push('/library');
                      }
                    }
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        } else {
          final image = await ImagePickerWidget.pickImage(context);
          if (image != null) {
            ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), image.path);
            context.push('/library');
          }
        }
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'jpeg'],
          allowMultiple: false,
          dialogTitle: 'Seleccionar imagen',
        );
        if (result != null && result.files.single.path != null) {
          ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), result.files.single.path!);
          context.push('/library');
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              // Carátula de la playlist
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onLongPress: () {
                    updateThumbnail();
                  },
                  child: SizedBox(
                    width: 260,
                    height: 260,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image(
                        image: isLocalPlaylist 
                          ? (thumbnail.startsWith('assets/')
                              ? AssetImage(thumbnail)
                              : FileImage(File(thumbnail)) as ImageProvider)
                          : NetworkImage(thumbnail) as ImageProvider,
                        height: 260,
                        width: 260,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 260,
                          width: 260,
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
                ),
              ),
            ],
          ),
      
          const SizedBox(height: 16.0),
      
          Expanded(
            child: SizedBox(
              height: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 10),
                        child: Text(
                          isLocalPlaylist
                            ? 'Lista Local'
                            : 'Lista de Youtube',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.only(right: 40, left: 10),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Botones de control
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Reproducir playlist
                        _ControlButton(
                          icon: Icons.play_arrow_rounded,
                          onPressed: () {},
                        ),
                    
                        const SizedBox(width: 8),
                    
                        // Reproducir en modo aleatorio
                        _ControlButton(
                          icon: MingCute.shuffle_2_line,
                          onPressed: () {
                            songs = songs..shuffle();
                            final playerProvider = ref.read(songPlayerProvider);
                            playerProvider.playSong(songs.first);
                          },
                        ),
                    
                        const SizedBox(width: 8),
                    
                        // Marcar como favorita
                        _ControlButton(
                          icon: MingCute.heart_line,
                          onPressed: () {
                            // TODO: Implementar marcar playlist como favorita
                          },
                        ),
                    
                        const SizedBox(width: 8),
                    
                        // Recargar playlist y todas sus canciones (sincronizar)
                        _ControlButton(
                          icon: MingCute.refresh_1_line,
                          onPressed: () {
                            // TODO: Implementar recargar playlist (sincronizar)
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;

  const _ControlButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.primary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}

