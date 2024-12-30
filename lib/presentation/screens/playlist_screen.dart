// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:apolo/presentation/providers/playlist/playlist_provider.dart';
import 'package:apolo/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/helpers/permissions_helper.dart';
import '../../config/utils/constants.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
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

  Future<Playlist> getPlaylistByID(String playlistID) async {
    try {
      if (widget.isLocalPlaylist == '0') {
        final pID = int.parse(playlistID);
        return await ref.read(playlistProvider.notifier).getPlaylistByID(pID);
      }
      
      // Para playlists de YouTube
      await ref.read(playlistSongsProvider(playlistID).notifier).loadPlaylist();
      return ref.read(playlistSongsProvider(playlistID));
    } catch (e) {
      return Playlist(
        title: 'Error',
        author: '',
        thumbnailUrl: ''
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    bool isLocalPlaylist = widget.isLocalPlaylist == '0';

    return Scaffold(
      backgroundColor: colors.surface,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder(
          valueListenable: _opacity,
          builder: (context, double opacity, _) {
            return AppBar(
              elevation: 0,
              backgroundColor: colors.secondary.withOpacity(opacity),
              title: Opacity(
                opacity: opacity,
                child: Text(
                  isLocalPlaylist ? widget.playlist?.title ?? '' : widget.playlist?.title ?? '',
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
                    ref.read(playlistSongsProvider(widget.playlistID)).songs = [];
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
          }
        ),
      ),
      body: Stack(
        children: [

          const GradientWidget(),

          FutureBuilder<Playlist>(
            future: getPlaylistByID(widget.playlistID),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.songs.isEmpty) {
                return const Scaffold(
                  body: Stack(
                    children: [
                      GradientWidget(),
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                );
              } 
          
              final playlistLocal = snapshot.data!;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: PlaylistHeader(
                      title: isLocalPlaylist ? playlistLocal.title : widget.playlist!.title,
                      thumbnail: isLocalPlaylist ? playlistLocal.thumbnailUrl : widget.playlist!.thumbnailUrl,
                      playlistID: playlistLocal.id,
                      isLocalPlaylist: isLocalPlaylist,
                      songs: playlistLocal.songs,
                    ),
                  ),
                  _PlaylistSongsList(songs: playlistLocal.songs, isLocalPlaylist: widget.isLocalPlaylist),
                ],
              );
            },
          ),

        ]
        
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

                Row(
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
                        icon: const Icon(Iconsax.search_normal_1_outline, size: 22, color: Colors.white),
                        onPressed: () { // Acción de búsqueda de canciones
                          
                        },
                      ),

                  ],  
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
class PlaylistHeader extends ConsumerWidget {
  final String title;
  final String thumbnail;
  final int playlistID;
  final bool isLocalPlaylist;
  List<Song> songs;

  PlaylistHeader({
    super.key,
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
                      ref.read(playlistProvider.notifier).updatePlaylistThumbnail(playlistID, image.path);
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
          ref.read(playlistProvider.notifier).updatePlaylistThumbnail(playlistID, image.path);
          context.push('/library');
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 85),
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
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          // Botones de play y shuffle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.play_arrow_rounded, size: 32),
                    SizedBox(width: 8),
                    Text('Reproducir', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {
                  songs = songs..shuffle();
                  final playerProvider = ref.read(songPlayerProvider);
                  playerProvider.playSong(songs.first);
                  playerProvider.addSongsToQueue(songs);
                },
                child: const Row(
                  children: [
                    Icon(Icons.shuffle_rounded, size: 32),
                    SizedBox(width: 8),
                    Text('Aleatorio', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}