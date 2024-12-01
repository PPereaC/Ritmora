// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:apolo/presentation/providers/playlist/playlist_provider.dart';
import 'package:apolo/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../config/helpers/permissions_helper.dart';
import '../../domain/entities/playlist.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/widgets.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  final String playlistID;

  const PlaylistScreen({super.key, required this.playlistID});

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  Future<Playlist> getPlaylistByID(String playlistID) async {
    final pID = int.parse(playlistID);
    final playlist = await ref.read(playlistProvider.notifier).getPlaylistByID(pID);
    return playlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.search_normal_1_outline, color: Colors.white),
                  onPressed: () {
                    // Acción de búsqueda
                  },
                ),
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
      ),
      body: FutureBuilder<Playlist>(
        future: getPlaylistByID(widget.playlistID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se encontró la playlist'));
          }

          final playlist = snapshot.data!;

          return Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: PlaylistHeader(
                          title: playlist.title,
                          thumbnail: playlist.thumbnailUrl,
                          playlistID: playlist.id,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: playlist.songs.length,
                      itemBuilder: (context, index) => SongListTile(
                        song: playlist.songs[index],
                        onSongOptions: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return BottomSheetBarWidget(
                                song: playlist.songs[index],
                              );
                            },
                          );
                        },
                      )
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class PlaylistHeader extends ConsumerWidget {
  final String title;
  final String thumbnail;
  final int playlistID;

  const PlaylistHeader({
    super.key,
    required this.title, 
    required this.thumbnail,
    required this.playlistID
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme;
    final isDarkMode = ref.watch(isDarkmodeProvider);

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
        }
      }
    }

    return Column(
      children: [
        MouseRegion(
          child: GestureDetector(
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
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
                            color: Colors.grey[600],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Iconsax.edit_outline, size: 28),
                          title: Text(
                            'Cambiar nombre',
                            style: textStyle.titleLarge,
                          ),
                          onTap: () {
                            context.pop();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Iconsax.gallery_edit_outline, size: 28),
                          title: Text(
                            'Cambiar imagen',
                            style: textStyle.titleLarge,
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
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: thumbnail.startsWith('assets/')
                      ? AssetImage(thumbnail)
                      : FileImage(File(thumbnail)) as ImageProvider,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.error_outline,
                    size: 48,
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
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
      ],
    );
  }
}