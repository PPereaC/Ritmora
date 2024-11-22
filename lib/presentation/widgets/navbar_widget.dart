import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import '../providers/theme/theme_provider.dart';

class Navbar extends ConsumerStatefulWidget {
  const Navbar({super.key});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends ConsumerState<Navbar> {
  int selectedIndex = 0;

  void onItemTapped(int index) async {
    setState(() {
      selectedIndex = index;
    });

    switch (index){
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/library');
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = ref.watch(themeNotifierProvider);
    final isDarkMode = themeProvider.isDarkmode;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkmode ? Colors.white : Colors.grey
          ),
        ),
        indicatorColor: Colors.blue,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: Colors.grey,
          ),
          NavigationBar(
            height: 70,
            elevation: 0,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => onItemTapped(index),
            backgroundColor: themeProvider.isDarkmode ? Colors.grey[900] : Colors.white,
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Iconsax.home_2_outline, color: isDarkMode ? Colors.white : Colors.grey
                ),
                label: 'Inicio'
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.music_playlist_outline, color: isDarkMode ? Colors.white : Colors.grey
                ),
                label: 'Biblioteca'
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.heart_outline, color: isDarkMode ? Colors.white : Colors.grey
                ),
                label: 'Favoritos'
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.setting_3_outline, color: isDarkMode ? Colors.white : Colors.grey
                ),
                label: 'Ajustes'
              ),
            ]
          ),
        ],
      ),
    );
  }
}