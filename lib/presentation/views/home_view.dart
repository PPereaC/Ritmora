// ignore_for_file: unused_element

import 'package:apolo/presentation/providers/trending_songs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../widgets/song_horizontal_listview_widget.dart';

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
    final isDarkMode = ref.watch(isDarkmodeProvider);
    final themeProvider = ref.watch(themeNotifierProvider.notifier);

    // Estados de las diferentes listas
    final trendingSongs = ref.watch(trendingSongsProvider);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Text(
          'Inicio',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => themeProvider.toggleDarkmode(),
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDarkMode ? Colors.white : Colors.grey,
              size: 24,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Canciones en tendencia
                    const _SectionTitle('En Tendencia'),

                    const SizedBox(height: 10),

                    if (trendingSongs.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else
                      SongHorizontalListview(songs: trendingSongs),

                    const SizedBox(height: 20),

                    // // Nuevos lanzamientos
                    // _SectionTitle('Nuevos Lanzamientos'),
                    // if (newReleases.isEmpty)
                    //   const Center(child: CircularProgressIndicator())
                    // else
                    //   SongHorizontalListview(
                    //     songs: newReleases,
                    //     title: 'Nuevos',
                    //     subTitle: 'Recién añadidos',
                    //   ),

                    // const SizedBox(height: 20)
                    // // Lista con los nombres de las canciones
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: trendingSongs.length,
                    //   itemBuilder: (context, index) {
                    //     final song = trendingSongs[index];
                    //     return SongListTile(
                    //       song: song, 
                    //       onSongOptions: () {}, 
                    //       isPlaylist: false, 
                    //       isVideo: true
                    //     );
                    //   },
                    // ),
                  ],
                );
              },
              childCount: 1
            )
          )
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