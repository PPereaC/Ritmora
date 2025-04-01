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

    switch (index) {
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
      decoration: BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              bottomNavItems.length,
              (index) {
                final isSelected = selectedIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => onItemTapped(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected
                              ? bottomNavItems[index].iconSelected
                              : bottomNavItems[index].icon,
                          size: 26,
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bottomNavItems[index].title,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
      ),
    );
  }
}