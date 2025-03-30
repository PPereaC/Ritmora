// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/data/nav_bar_items.dart';

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
    return Container(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.only(top: 8),
        color: Colors.black.withOpacity(0.9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            bottomNavItems.length,
            (index) {
              final isSelected = selectedIndex == index;
              return InkWell(
                onTap: () => onItemTapped(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? bottomNavItems[index].iconSelected : bottomNavItems[index].icon,
                        size: index == 2 ? 30 : 28,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bottomNavItems[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}