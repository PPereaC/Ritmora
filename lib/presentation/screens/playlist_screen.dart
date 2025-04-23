// ignore_for_file: use_build_context_synchronously, deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
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
import '../../domain/entities/youtube_song.dart';
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

  Future<List<dynamic>> getPlaylistSongs(String playlistID) async {
    try {
      if (widget.isLocalPlaylist == '0') {
        // Para playlists locales
        return await ref.read(playlistProvider.notifier).getSongsFromPlaylist(int.parse(playlistID));
      } else {
        // Para playlists de YouTube
        final localSongs = await ref.read(playlistProvider.notifier).getYoutubeSongsFromPlaylist(playlistID);
        
        if (localSongs.isNotEmpty) {
          printINFO('Usando canciones guardadas localmente');
          return localSongs;
        }
  
        // Si no hay canciones locales, obtener de YouTube y guardarlas
        printINFO('Obteniendo canciones de YouTube');
        final youtubeSongs = await YoutubeService().getYoutubePlaylistSongs('https://www.youtube.com/playlist?list=$playlistID');
        
        // Guardar las canciones localmente
        await ref.read(playlistProvider.notifier).addSongsToYoutubePlaylist(playlistID, youtubeSongs);
        
        return youtubeSongs;
      }
    } catch (e) {
      printERROR('Error al obtener canciones: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {

    // bool isLocalPlaylist = widget.isLocalPlaylist == '0';
    final bool isTabletOrDesktop = Responsive.isTabletOrDesktop(context);
    final textStyle = Theme.of(context).textTheme;

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
                          context.go('/library');
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
      body: FutureBuilder<List<dynamic>>(
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
              child: Text('No hay canciones en esta playlist', style: TextStyle(color: Colors.white)),
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
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (widget.isLocalPlaylist == '0') {
                                  context.go('/library');
                                } else {
                                  context.go('/library');
                                }
                              },
                              child: Row(
                                children: [
                              
                                  // Icono de retroceso
                                  const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                              
                                  const SizedBox(width: 5),
                              
                                  // Texto de retroceso
                                  Text(
                                    'Atrás',
                                    style: textStyle.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontSize: 22
                                    )
                                  )
                              
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    isTabletOrDesktop
                        ? _TabletDesktopPlaylistHeader(
                            title: widget.playlist?.title ?? '',
                            thumbnail: widget.playlist?.thumbnailUrl ?? '',
                            playlistID: widget.playlistID,
                            isLocalPlaylist: widget.isLocalPlaylist == '0',
                            songs: songs.map((song) => widget.isLocalPlaylist == '0' ? (song as Song) : Song(
                              title: (song as YoutubeSong).title,
                              author: song.author,
                              thumbnailUrl: song.thumbnailUrl,
                              streamUrl: song.streamUrl,
                              endUrl: song.endUrl,
                              songId: song.songId,
                              duration: song.duration,
                              videoId: song.videoId,
                              isVideo: song.isVideo,
                              isLiked: song.isLiked,
                            )).toList(),
                            owner: widget.playlist!.author,
                          )
                        : _MobilePlaylistHeader(
                            title: widget.playlist?.title ?? '',
                            thumbnail: widget.playlist?.thumbnailUrl ?? '',
                            playlistID: widget.playlistID,
                            isLocalPlaylist: widget.isLocalPlaylist == '0',
                            songs: songs.map((song) => widget.isLocalPlaylist == '0' ? (song as Song) : Song(
                              title: (song as YoutubeSong).title,
                              author: song.author,
                              thumbnailUrl: song.thumbnailUrl,
                              streamUrl: song.streamUrl,
                              endUrl: song.endUrl,
                              songId: song.songId,
                              duration: song.duration,
                              videoId: song.videoId,
                              isVideo: song.isVideo,
                              isLiked: song.isLiked,
                            )).toList(),
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
  final List<dynamic> songs;
  
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
    final isLocal = widget.isLocalPlaylist == '0';

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 5),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final songIndex = _showReversed
              ? (widget.songs.length - 1 - index) 
              : index;

            final currentSong = widget.songs[songIndex];
            final song = isLocal ? currentSong : Song(
              title: currentSong.title,
              author: currentSong.author,
              thumbnailUrl: currentSong.thumbnailUrl,
              streamUrl: currentSong.streamUrl,
              endUrl: currentSong.endUrl,
              songId: currentSong.songId,
              duration: currentSong.duration,
              videoId: currentSong.videoId,
              isVideo: currentSong.isVideo,
              isLiked: currentSong.isLiked,
            );

            return Column(
              children: [
                const SizedBox(height: 8.0),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
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
                  
                      if (index == 0)
                        IconButton(
                          icon: const Icon(MingCute.search_line, size: 22, color: Colors.white),
                          onPressed: () {},
                        ),
                    ],  
                  ),
                ),
                
                SongListTile(
                  song: song,
                  onSongOptions: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheetBarWidget(
                          song: song,
                        );
                      },
                    );
                  },
                  isPlaylist: isLocal,
                  isVideo: song.author.contains('Video') || song.author.contains('Episode'),
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
  final String playlistID;
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
                      if (isLocalPlaylist) {
                        ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), image.path);
                      } else {
                        ref.read(playlistProvider.notifier).updateYoutubePlaylistThumbnail(playlistID, image.path);
                      }
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
          if (isLocalPlaylist) {
            ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), image.path);
          } else {
            ref.read(playlistProvider.notifier).updateYoutubePlaylistThumbnail(playlistID, image.path);
          }
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
                onTap: () {
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
                          image: (thumbnail.startsWith('assets/')
                            ? AssetImage(thumbnail)
                            : FileImage(File(thumbnail)) as ImageProvider),
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
  final String owner;

  _TabletDesktopPlaylistHeader({
    required this.title, 
    required this.thumbnail,
    required this.playlistID,
    required this.isLocalPlaylist,
    required this.songs,
    this.owner = 'Anónimo',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    int _durationStringToSeconds(String duration) {
      final parts = duration.split(':');
      
      if (parts.length == 2) {
        // Formato mm:ss
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return minutes * 60 + seconds;
      } else if (parts.length == 3) {
        // Formato h:mm:ss
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);
        return hours * 3600 + minutes * 60 + seconds;
      }
      
      return 0; // En caso de formato desconocido
    }

    // Formatea segundos totales a "Xh Ym" o "Ym" si menos de 1 hora
    String _formatDuration(int totalSeconds) {
      final hours = totalSeconds ~/ 3600;
      final minutes = (totalSeconds % 3600) ~/ 60;
      
      if (hours > 0) {
        return '$hours h $minutes min aproximadamente';
      } else {
        return '${minutes}m';
      }
    }

    String getTotalPlaylistDuration() {
      int totalSeconds = 0;
      
      for (final song in songs) {
        totalSeconds += _durationStringToSeconds(song.duration);
      }
      
      return _formatDuration(totalSeconds);
    }

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
                        if (isLocalPlaylist) {
                          ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), image.path);
                        } else {
                          ref.read(playlistProvider.notifier).updateYoutubePlaylistThumbnail(playlistID, image.path);
                        }
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
          if (isLocalPlaylist) {
            ref.read(playlistProvider.notifier).updatePlaylistThumbnail(int.parse(playlistID), result.files.single.path!);
          } else {
            ref.read(playlistProvider.notifier).updateYoutubePlaylistThumbnail(playlistID, result.files.single.path!);
          }
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
                  onTap: () {
                    updateThumbnail();
                  },
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image(
                        image: (thumbnail.startsWith('assets/')
                              ? AssetImage(thumbnail)
                              : FileImage(File(thumbnail)) as ImageProvider),
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

              // Botones de control
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
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
      
          const SizedBox(height: 16.0),
      
          Expanded(
            child: SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
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
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                  
                      Padding(
                        padding: const EdgeInsets.only(right: 40, left: 10),
                        child: AutoSizeText(
                          title,
                          style: const TextStyle(
                            fontSize: 55,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                          minFontSize: 18,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ),
                    ],
                  ),

                  // Canciones en la playlist y tiempo en total de todas las canciones
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      children: [
                        // Icono
                        const Icon(
                          MingCute.user_1_line,
                          size: 28
                        ),

                        const SizedBox(width: 8),

                        // Propietario de la playlist
                        Text(
                          owner,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[200]
                          )
                        ),

                        const SizedBox(width: 2),

                        Text(
                          ' 🔹 ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[200]
                          )
                        ),

                        // Canciones en total
                        Text(
                          '${songs.length} canciones',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[200]
                          )
                        ),

                        const SizedBox(width: 2),

                        Text(
                          ' 🔹 ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[200]
                          )
                        ),

                        // Duración en total de la playlist
                        Text(
                          getTotalPlaylistDuration(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[200]
                          )
                        )
                      ],
                    ),
                  )
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
          color: colors.primary,
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}

