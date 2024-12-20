import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

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
        context.go('/search');
        break;
      case 2:
        context.go('/library');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white 
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
            backgroundColor: Colors.grey[900],
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Iconsax.home_2_outline,
                  color: selectedIndex == 0
                      ? Colors.white
                      : Colors.white
                ),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.search_normal_1_outline,
                  color: selectedIndex == 2
                      ? Colors.white
                      : Colors.white
                ),
                label: 'Buscar',
              ),
              NavigationDestination(
                icon: Icon(
                  Iconsax.music_playlist_outline,
                  color: selectedIndex == 1
                      ? Colors.white
                      : Colors.white
                ),
                label: 'Biblioteca',
              ),
            ],
          ),
        ],
      ),
    );
  }
}