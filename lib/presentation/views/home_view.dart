// ignore_for_file: unused_element

import 'package:apolo/presentation/providers/trending_songs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../domain/entities/song.dart';
import '../delegates/search_songs_delegate.dart';
import '../providers/providers.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    
    // Cargar datos iniciales
    ref.read(trendingSongsProvider.notifier).loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    // Estados de las diferentes listas
    // final trendingSongs = ref.watch(trendingSongsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                IconButton.filled(
                  onPressed: () async {
                    final searchQuery = ref.read(searchQueryProvider);
                    
                    // ignore: unused_local_variable
                    final song = await showSearch<Song?>(
                      query: searchQuery,
                      context: context,
                      delegate: SearchSongsDelegate(
                        searchSongs: ref.read(searchSongsProvider.notifier).searchSongsByQuery,
                      )
                    );
                  },
                  icon: const Icon(Iconsax.search_normal_1_outline),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.secondary.withOpacity(0.5),
                    padding: const EdgeInsets.all(10),
                  ),
                ),
                const SizedBox(width: 3),
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(Iconsax.notification_outline),
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
          Positioned(
            left: -50,
            top: -50,
            child: Container(
              height: size.height * 0.8,
              width: size.width * 1.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.5,
                  colors: [
                    colors.primary.withOpacity(0.7),
                    colors.primary.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 0.9],
                ),
              ),
            ),
          ),
          
          // Contenido original
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                      ],
                    );
                  },
                  childCount: 1
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final double verticalPadding;
  final double horizontalPadding;
  
  const _SectionTitle(
    this.title, {
    this.verticalPadding = 8.0,
    this.horizontalPadding = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implementar navegación
          },
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding, 
              horizontal: horizontalPadding
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primary.withOpacity(0.8),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: textStyle.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}